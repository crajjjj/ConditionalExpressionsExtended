Scriptname CondiExp_Followers extends ReferenceAlias

Quest Property this_quest Auto
CondiExp_StartMod Property sm Auto
condiexp_MCM Property config auto

Import Utility
Import CondiExp_Expression_Util
Import CondiExp_util
Import CondiExp_log
Import mfgconsolefunc

int additionalLag = 10

Actor act

Event OnPlayerLoadGame()
	log("CondiExp_Followers OnPlayerLoadGame.Actor: " + act.GetLeveledActorBase().GetName())
	ResetQuest(this_quest)
EndEvent

Event OnCellLoad()
	log("CondiExp_Followers OnCellLoad.Actor: " + act.GetLeveledActorBase().GetName())
	ResetQuest(this_quest)
endEvent

Event OnInit()
	act = self.GetActorReference()
	If (!act)
		Return
	EndIf
	if (!ResetPhonemeModifier(act))
		Wait(10.0)
	endif
	If act == sm.PlayerRef
		int verboseInt = sm.Condiexp_Verbose.GetValue() as Int
		verbose(act, "FollowersQuest: started" , verboseInt)
		Return
	EndIf
	log("CondiExp_Followers OnInit. Actor: " + act.GetLeveledActorBase().GetName())
	RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
EndEvent

Event OnUpdate()
	int verboseInt = sm.Condiexp_Verbose.GetValue() as Int
	
	if (!ResetPhonemeModifier(act))
		log("CondiExp_Followers OnUpdate. ResetPhonemeModifier failed")
		If (!act)
			verbose(act, "Actor was removed" , verboseInt)
			Return
		EndIf
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue() + additionalLag)
	Endif

	float dist = act.GetDistance(sm.PlayerRef)

	If (dist > 2000)
		verbose(act, "Actor is too far - skipping" , verboseInt)
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue() + additionalLag)
		return
	EndIf

	If (sm.checkIfModShouldBeSuspended(act))
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue() + additionalLag)
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
		act.Delete()
		act = None
		Return
	EndIf

	If (act.GetSleepState() == 3)
		If (GetModifier(act, 0) != 90)
			SmoothSetModifier(act, 0, 1, 90)
		EndIf
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		Return
	EndIf

	If (act.GetActorValuePercentage("Health") < 0.40 && config.Condiexp_GlobalPain.GetValue() == 1)
		PlayPainExpression(act, config)
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		Return
	EndIf
	
	;Combat Anger
	If (act.IsInCombat() && act.GetActorValuePercentage("Health") >= 0.40 && config.Condiexp_GlobalCombat.GetValue() == 1)
		verbose(act, "Anger", verboseInt)
		SmoothSetExpression(act, 15, RandomInt(50, 100), 0)
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		Return
	EndIf
	
	If (!act.IsInCombat() && act.GetActorValuePercentage("Stamina") < 0.6 && act.GetActorValuePercentage("Health") >= 0.40 && config.Condiexp_GlobalStamina.GetValue() == 1)
		verbose(act, "Fatigue: Effect: Breathing", verboseInt)
		Breathe(act, false)
		Utility.Wait(1)
		Breathe(act, false)
		Utility.Wait(1)
		Breathe(act, true)
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		Return
	EndIf

	int trauma = sm.getTraumaStatus(act)
	If (trauma > 0)
		PlayTraumaExpression( act, trauma, config)
		resetMFGSmooth(act)
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		Return
	EndIf

	int dirty = sm.getDirtyStatus(act)
	If (dirty > 0)
		PlayDirtyExpression( act, dirty, config)
		resetMFGSmooth(act)
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		Return
	EndIf

	int aroused = sm.getArousalStatus(act)
	If (aroused > 0)
		PlayArousedExpression( act, aroused, config)
		resetMFGSmooth(act)
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		Return
	EndIf
	
	If (config.Condiexp_GlobalRandom.GetValue() == 1)
		PlayRandomExpression(act, config)
		PlayRandomExpression(act, config)
	EndIf
	
	RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue() + 3)
EndEvent




