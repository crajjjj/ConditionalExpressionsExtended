Scriptname CondiExp_Followers extends ReferenceAlias

Quest Property this_quest Auto
CondiExp_StartMod Property sm Auto
condiexp_MCM Property config auto
GlobalVariable Property Condiexp_Verbose Auto
GlobalVariable Property Condiexp_FollowersUpdateInterval Auto
Actor Property PlayerRef Auto

Import Utility
Import CondiExp_Expression_Util
Import CondiExp_util
Import CondiExp_log

int additionalLagSmall = 3
int distanceCounter = 6
int additionalLag = 7
int additionalLagBig = 30
bool firstRun = true
Actor act

;only for player actor
Event OnPlayerLoadGame()
	log("CondiExp_Followers OnPlayerLoadGame.Actor: " + act.GetLeveledActorBase().GetName())
	ResetQuest(this_quest)
EndEvent

Event OnInit()
	RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt() + additionalLagSmall)
EndEvent

Event OnUpdate()
	int verboseInt = Condiexp_Verbose.GetValueInt()
	act = self.GetActorReference()
	If (!act)
		trace_line("Actor was removed" , verboseInt)
		TryToClear()
		act = None
		Return
	EndIf
	;trace(act, "CondiExp_Followers OnUpdate" , verboseInt)
	; log("CondiExp_Followers OnUpdate. Actor: " + act.GetLeveledActorBase().GetName())
	If (config.CondiExpFollowerQuest.IsStopped())
		verbose(act, "Followers quest was stopped" , verboseInt)
		TryToClear()
		act = None
		Return
	EndIf
	;restart flow for player reference only
	If act == PlayerRef
		if firstRun
			RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt() + additionalLagBig)
			firstRun = false
			verbose(act, "FollowersQuest: init" , verboseInt)
			Return
		else
			verbose(act, "FollowersQuest: refresh" , verboseInt)
			firstRun = true
			ResetQuest(this_quest)
			Return
		endif
	EndIf

	float dist = act.GetDistance(PlayerRef)
	If (dist > 1024)
		if (distanceCounter <= 0)
			verbose(act, "Actor is too far for too long. Removing", verboseInt)
			TryToClear()
			act = None
			return
		else
			trace(act, "Actor is too far. Counter:" + distanceCounter, verboseInt)
			distanceCounter = distanceCounter - 1
			RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt() + additionalLagSmall)
			return
		endif
	Else
		distanceCounter = 6
	EndIf

	If (sm.checkIfModShouldBeSuspended(act))
		verbose(act, "Suspending on condition" , verboseInt)
		RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt() + additionalLag)
		return
	endif
	
	resetMFGSmooth(act)
	bool isMale = (act.GetLeveledActorBase().GetSex() == 0)

	If (act.IsDead())
		If (RandomInt(0, 1))
			SmoothSetModifier(act, 6, 7, RandomInt(80, 100))
			SmoothSetModifier(act, 11, -1, 100)
			SmoothSetPhoneme(act, 2, 50)
			SmoothSetPhoneme(act, 11, 100)
			SmoothSetModifier(act, 0, 1, RandomInt(20, 50))
		Else
			SmoothSetModifier(act,4, 5, RandomInt(0, 100))
			SmoothSetModifier(act, 0, 1, 90)
		EndIf
		trace(act, "Dead", verboseInt)
		TryToClear()
		act = None
		Return
	EndIf

	If (act.GetSleepState() == 3)
		If (GetModifier(act, 0) != 90)
			SmoothSetModifier(act, 0, 1, 90)
		EndIf
		RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
		Return
	EndIf

	If (act.GetActorValuePercentage("Health") < 0.40 && config.Condiexp_GlobalPain.GetValueInt() == 1)
		trace(act, "Pain", verboseInt)
		PlayPainExpression(act, config.painExpr)
		SendSLAModEvent(config.Go.arousalPainThreshold, config.Go.arousalPain, "is not feeling aroused because of pain", act, "CondiExpPain")
		RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt() + 3)
		Return
	EndIf
	
	;Combat Anger
	If (act.IsInCombat() && act.GetActorValuePercentage("Health") >= 0.40 && act.GetActorValuePercentage("Stamina") > 0.6 && config.Condiexp_GlobalCombat.GetValueInt() == 1)
		trace(act, "Anger", verboseInt)
		SmoothSetExpression(act, 15, RandomInt(35, 80))
		RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
		Return
	EndIf
	
	If (act.GetActorValuePercentage("Stamina") < 0.6 && act.GetActorValuePercentage("Health") >= 0.40 && config.Condiexp_GlobalStamina.GetValueInt() == 1)
		;random skip 20%
		Int randomSkip = Utility.RandomInt(1, 10)
		if randomSkip > 2
			trace(act, "Fatigue: Effect: Breathing", verboseInt)
			Breathe(act, false)
			Utility.Wait(1)
			Breathe(act, false)
			Utility.Wait(1)
			Breathe(act, true)
			RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
		endif
		Return
	EndIf

	If (act.GetActorValuePercentage("Magicka") < 0.1 && config.Condiexp_GlobalMana.GetValueInt() == 1)
		;random skip 20%
		Int randomSkip = Utility.RandomInt(1, 10)
		if randomSkip > 2
			trace(act, "Headache Effect", verboseInt)
			Headache(act)
			RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
		endif
		Return
	EndIf

	if !isMale
		int trauma = sm.getTraumaStatus(act)
		If (trauma > 0)
			PlayTraumaExpression( act, trauma, config.traumaExpr)
			resetMFGSmooth(act)
			RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
			Return
		EndIf
	endif
	
	
	int dirty = sm.getDirtyStatus(act)
	If (dirty > 0)
			PlayDirtyExpression( act, dirty, config.dirtyExpr)
			Utility.Wait(5)
			resetMFGSmooth(act)
			RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
			Return
	EndIf
	
	if !isMale
		int aroused = sm.getArousalStatus(act)
		If (aroused > 0 && !isMale)
			PlayArousedExpression( act, aroused, config.arousalExpr)
			Utility.Wait(5)
			resetMFGSmooth(act)
			RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
			Return
		EndIf
	endif
	
	If (config.Condiexp_GlobalRandom.GetValueInt() == 1)
		int rel = act.GetRelationshipRank(PlayerRef)
		RelationshipRankEmotion(act, config, config.randomExpr,rel)
		Int Seconds = RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 1, 5)
		Utility.Wait(Seconds)
		resetMFGSmooth(act)
	EndIf
	
	RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
EndEvent