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
Import mfgconsolefunc

int additionalLagSmall = 3
int additionalLag = 10
int additionalLagBig = 30

Actor act

;only for player actor
Event OnPlayerLoadGame()
	log("CondiExp_Followers OnPlayerLoadGame.Actor: " + act.GetLeveledActorBase().GetName())
	ResetQuest(this_quest)
EndEvent

Event OnInit()
	If (act)
		log("CondiExp_Followers OnInit. Actor: " + act.GetLeveledActorBase().GetName())
	else
		log("CondiExp_Followers OnInit. Actor empty", 1)
	endif
	RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt() + 10)
EndEvent

Event OnUpdate()
	int verboseInt = Condiexp_Verbose.GetValueInt()
	act = self.GetActorReference()
	If (!act)
		trace_line("Actor was removed" , verboseInt)
		self.Clear()
		act = None
		Return
	EndIf
	
	If act == PlayerRef
		verbose(act, "FollowersQuest: started" , verboseInt)
		Return
	EndIf
	
	If (config.CondiExpFollowerQuest.IsStopped())
		verbose(act, "Followers quest was stopped" , verboseInt)
		self.Clear()
		act = None
		Return
	EndIf
	
	float dist = act.GetDistance(PlayerRef)

	If (dist > 1500)
		verbose(act, "Actor is too far - removing" , verboseInt)
		self.Clear()
		act = None
		return
	EndIf

	If (sm.checkIfModShouldBeSuspended(act) || act.IsInDialogueWithPlayer())
		verbose(act, "Suspending on condition" , verboseInt)
		RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt() + additionalLag)
		return
	endif
	
	resetMFGSmooth(act)

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
		verbose(act, "Dead", verboseInt)
		self.Clear()
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
		PlayPainExpression(act, config)
		SendSLAModEvent(25, "is not feeling aroused because of pain", act)
		RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt() + 3)
		Return
	EndIf
	
	;Combat Anger
	If (act.IsInCombat() && act.GetActorValuePercentage("Health") >= 0.40 && config.Condiexp_GlobalCombat.GetValueInt() == 1)
		verbose(act, "Anger", verboseInt)
		SmoothSetExpression(act, 15, RandomInt(50, 100), 0)
		RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
		Return
	EndIf
	
	If (!act.IsInCombat() && act.GetActorValuePercentage("Stamina") < 0.6 && act.GetActorValuePercentage("Health") >= 0.40 && config.Condiexp_GlobalStamina.GetValueInt() == 1)
		verbose(act, "Fatigue: Effect: Breathing", verboseInt)
		Breathe(act, false)
		Utility.Wait(1)
		Breathe(act, false)
		Utility.Wait(1)
		Breathe(act, true)
		RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
		Return
	EndIf

	int trauma = sm.getTraumaStatus(act)
	If (trauma > 0)
		PlayTraumaExpression( act, trauma, config)
		resetMFGSmooth(act)
		RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
		Return
	EndIf

	int dirty = sm.getDirtyStatus(act)
	If (dirty > 0)
		PlayDirtyExpression( act, dirty, config)
		Utility.Wait(5)
		resetMFGSmooth(act)
		RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
		Return
	EndIf

	int aroused = sm.getArousalStatus(act)
	If (aroused > 0)
		PlayArousedExpression( act, aroused, config)
		Utility.Wait(5)
		resetMFGSmooth(act)
		RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
		Return
	EndIf
	
	If (config.Condiexp_GlobalRandom.GetValueInt() == 1)
		PlayRandomExpression(act, config)
		Int Seconds = RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 2, 5)
		Utility.Wait(Seconds)
	EndIf
	RegisterForSingleUpdate(Condiexp_FollowersUpdateInterval.GetValueInt())
EndEvent




