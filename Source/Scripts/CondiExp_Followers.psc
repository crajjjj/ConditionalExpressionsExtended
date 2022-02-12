Scriptname CondiExp_Followers extends ReferenceAlias

Quest Property this_quest Auto
CondiExp_StartMod Property sm Auto

Import Utility
Import CondiExp_Expression_Util
Import CondiExp_util
Import CondiExp_log
Import mfgconsolefunc


Actor act
Int exp_value

State Idle
	Event OnUpdate()
	EndEvent
EndState

Function Defaults()
	exp_value = 0
EndFunction

Event OnPlayerLoadGame()
	ResetQuest(this_quest)
	log("CondiExp_Followers OnPlayerLoadGame.Actor: " + act.GetName())
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
	log("CondiExp_Followers OnInit. Actor: " + act.GetName())
	Defaults()
	RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
EndEvent

Event OnUpdate()
	While (!SetModifier(act, 14, 0))
		If (!act)
			Return
		EndIf
		Wait(5.0)
	EndWhile

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

	If (act.GetActorValuePercentage("Health") < 0.34 && GetExpressionID(act) != 1)
		trace("CondiExp_Followers Low health emotion.Aactor: " + act.GetName())
		SmoothSetExpression(act, 1, RandomInt(50, 100), 0)
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		Return
	EndIf

	If (act.IsInCombat() && GetExpressionID(act) != 15 && act.GetActorValuePercentage("Health") >= 0.34)
		trace("CondiExp_Followers In combat emotion.Actor: " + act.GetName())
		SmoothSetExpression(act, 15, RandomInt(50, 100), 0)
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		Return
	EndIf

	int trauma = sm.getTraumaStatus(act)
	If (trauma > 0)
		trace("CondiExp_Followers Trauma emotion. Actor: " + act.GetName())
		PlayTraumaExpression( act, trauma, sm.Condiexp_Verbose.GetValue() as Int )
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		Return
	EndIf

	int dirty = sm.getDirtyStatus(act)
	If (dirty > 0)
		trace("CondiExp_Followers Dirty emotion. Actor: " + act.GetName())
		PlayDirtyExpression( act, dirty, sm.Condiexp_Verbose.GetValue() as Int)
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		Return
	EndIf

	int aroused = sm.getArousalStatus(act)
	If (aroused > 0)
		trace("CondiExp_Followers Aroused emotion. Actor: " + act.GetName())
		PlayArousedExpression( act, aroused, sm.Condiexp_Verbose.GetValue() as Int)
		RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
		Return
	EndIf

	trace("CondiExp_Followers Random emotion. Actor: " + act.GetName() + ".")
	RandomEmotion(act)
	RegisterForSingleUpdate(sm.Condiexp_FollowersUpdateInterval.GetValue())
EndEvent




