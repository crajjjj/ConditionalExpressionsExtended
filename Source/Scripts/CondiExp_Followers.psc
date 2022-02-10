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
EndEvent

Event OnInit()
	act = self.GetRef() as Actor
	If (!act)
		Return
	EndIf
	While (!ResetPhonemeModifier(act))
		Wait(1.0)
	EndWhile
	Defaults()
	RegisterForSingleUpdate(sm.Condiexp_UpdateInterval.GetValue())
EndEvent

Event OnUpdate()
	While (!SetModifier(act, 14, 0))
		If (!act)
			Return
		EndIf
		Wait(5.0)
	EndWhile
	
	if (sm.checkIfModShouldBeSuspended(act))
		return
	endif

	If (!sm.isModEnabled())
		return
	endif

	If (act.IsDead())
		ResetPhonemeModifier(act)
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
			ResetPhonemeModifier(act)
			SmoothSetModifier(act, 0, 1, 90)
		EndIf
		RegisterForSingleUpdate(sm.Condiexp_UpdateInterval.GetValue())
		Return
	EndIf

	If (act.GetActorValuePercentage("Health") < 0.34 && GetExpressionID(act) != 1)
		exp_value = SmoothSetExpression(act, 1, RandomInt(50, 100), exp_value)
		RegisterForSingleUpdate(sm.Condiexp_UpdateInterval.GetValue())
		Return
	EndIf

	If (act.IsInCombat() && GetExpressionID(act) != 15 && act.GetActorValuePercentage("Health") >= 0.34)
		exp_value = SmoothSetExpression(act, 15, RandomInt(50, 100), exp_value)
		RegisterForSingleUpdate(sm.Condiexp_UpdateInterval.GetValue())
		Return
	EndIf

	RandomEmotion(act)
	RegisterForSingleUpdate(sm.Condiexp_UpdateInterval.GetValue())
EndEvent




