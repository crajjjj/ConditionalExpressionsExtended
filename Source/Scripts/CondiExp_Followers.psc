Scriptname CondiExp_Followers extends ReferenceAlias

Quest Property this_quest Auto
CondiExp_StartMod Property sm Auto

Import Utility
Import CondiExp_Expression_Util
Import CondiExp_util
Import CondiExp_log
Import mfgconsolefunc


Actor act

Event OnPlayerLoadGame()
	ResetQuest(this_quest)
	log("CondiExp_Followers OnPlayerLoadGame.Actor: " + act.GetLeveledActorBase().GetName())
EndEvent

Event OnInit()
	act = self.GetActorReference()
	If (!act)
		Return
	EndIf
	While (!ResetPhonemeModifier(act))
		Wait(1.0)
	EndWhile
	If act == Game.GetPlayer()
		Notification("FollowersQuest: started")
		Return
	EndIf
	log("CondiExp_Followers OnInit. Actor: " + act.GetLeveledActorBase().GetName())
	RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
EndEvent

Event OnUpdate()
	While (!SetModifier(act, 14, 0))
		If (!act)
			Return
		EndIf
		Wait(5.0)
	EndWhile
	int verboseInt = sm.Condiexp_Verbose.GetValue() as Int
	resetMFGSmooth(act)

	If (sm.checkIfModShouldBeSuspended(act))
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		return
	endif
	
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
		Return
	EndIf

	If (act.GetSleepState() == 3)
		If (GetModifier(act, 0) != 90)
			SmoothSetModifier(act, 0, 1, 90)
		EndIf
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		Return
	EndIf

	If (act.GetActorValuePercentage("Health") < 0.40)
		PlayPainExpression(act, verboseInt)
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		Return
	EndIf
	
	;Combat Anger
	If (act.IsInCombat() && act.GetActorValuePercentage("Health") >= 0.40)
		SmoothSetExpression(act, 15, RandomInt(50, 100), 0)
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		Return
	EndIf
	
	If (!act.IsInCombat() && act.GetActorValuePercentage("Stamina") < 0.6 && act.GetActorValuePercentage("Health") >= 0.40)
		verbose(act, "Fatigue: Effect: Breathing", verboseInt)
		Breathe(act)
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		Return
	EndIf

	int trauma = sm.getTraumaStatus(act)
	If (trauma > 0)
		PlayTraumaExpression( act, trauma, verboseInt)
		resetMFGSmooth(act)
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		Return
	EndIf

	int dirty = sm.getDirtyStatus(act)
	If (dirty > 0)
		PlayDirtyExpression( act, dirty, verboseInt)
		resetMFGSmooth(act)
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		Return
	EndIf

	int aroused = sm.getArousalStatus(act)
	If (aroused > 0)
		PlayArousedExpression( act, aroused, verboseInt)
		resetMFGSmooth(act)
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		Return
	EndIf

	RandomEmotion(act, verboseInt)
	RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
EndEvent




