Scriptname CondiExp_TraumaScript extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyTrauma Auto
GlobalVariable Property Condiexp_Sounds Auto
sound property CondiExp_BreathingFemale auto
Faction Property SexLabAnimatingFaction Auto



Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValue(1)
	log("trauma triggered")
	RegisterForSingleUpdate(0.01)
EndEvent

event OnUpdate()
	ShowExpression() 
EndEvent

Function ShowExpression() 
	if (PlayerRef.IsInFaction(SexLabAnimatingFaction))
		return
	endif

    Int trauma = Condiexp_CurrentlyTrauma.GetValue() as Int

	MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
	
    If trauma == 0
        MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,0)
        Condiexp_CurrentlyBusy.SetValue(0)
		Condiexp_CurrentlyTrauma.SetValue(0)
        return
    endif

	Utility.Wait(1)
	log("Trauma playing effect")
	Int randomseed = Utility.RandomInt(1, 20)
	_painVariants(trauma, PlayerRef, randomseed + trauma*10)
	Utility.Wait(2)
	Breathe()
EndFunction

Function Breathe()
	If PlayerRef.IsDead()
		return
	endif
	
	;;;;;;;;;;; SOUNDS ;;;;;;;;;;;;
	Int breathRandom = Utility.RandomInt(1, 5)
	If Condiexp_Sounds.GetValue() > 0 && breathRandom == 1
		int Breathe = CondiExp_BreathingfeMale.play(PlayerRef)     
	endif 
	;;;;;;;;;
	
	Inhale(33,73, PlayerRef)
	Exhale(73,33, PlayerRef)

	Int randomLook = Utility.RandomInt(1, 10)
	If randomLook == 2
		LookLeft(50, PlayerRef)
	ElseIf randomLook == 4
		LookRight(50, PlayerRef)
	ElseIf randomLook == 8
		LookDown(50, PlayerRef)
	endif 
	Utility.Wait(2)
	
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	log("Trauma OnEffectFinish")
	Utility.Wait(2)
	if (Condiexp_CurrentlyTrauma.GetValue() == 0)
		PlayerRef.ClearExpressionOverride()
		MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
	endif

	Condiexp_CurrentlyBusy.SetValue(0)
EndEvent


; Sets an expression to override any other expression other systems may give this actor.
;							7 - Mood Neutral
; 0 - Dialogue Anger		8 - Mood Anger		15 - Combat Anger
; 1 - Dialogue Fear			9 - Mood Fear		16 - Combat Shout
; 2 - Dialogue Happy		10 - Mood Happy
; 3 - Dialogue Sad			11 - Mood Sad
; 4 - Dialogue Surprise		12 - Mood Surprise
; 5 - Dialogue Puzzled		13 - Mood Puzzled
; 6 - Dialogue Disgusted	14 - Mood Disgusted
; aiStrength is from 0 to 100 (percent)
Function _painVariants(Int index, Actor act, Int Power)
	
	if Power > 100
		Power = 100
	endif

	if index == 1
		act.SetExpressionOverride(1, Power)
		mfgconsolefunc.SetModifier(act, 0, 30)
		mfgconsolefunc.SetModifier(act, 1, 20)
		mfgconsolefunc.SetModifier(act, 12, 90)
		mfgconsolefunc.SetModifier(act, 13, 90)
		mfgconsolefunc.SetPhoneme(act, 2, 100)
		mfgconsolefunc.SetPhoneme(act, 5, 80)
	elseIf index == 2
		act.SetExpressionOverride(3, Power)
		mfgconsolefunc.SetModifier(act, 2, 10)
		mfgconsolefunc.SetModifier(act, 3, 10)
		mfgconsolefunc.SetModifier(act, 6, 50)
		mfgconsolefunc.SetModifier(act, 7, 50)
		mfgconsolefunc.SetModifier(act, 11, 30)
		mfgconsolefunc.SetModifier(act, 12, 30)
		mfgconsolefunc.SetModifier(act, 13, 30)
		mfgconsolefunc.SetPhoneme(act, 0, 20)
	elseIf index == 3
		act.SetExpressionOverride(3, Power)
		mfgconsolefunc.SetModifier(act, 0, 30)
		mfgconsolefunc.SetModifier(act, 1, 30)
		mfgconsolefunc.SetModifier(act, 4, 80)
		mfgconsolefunc.SetModifier(act, 5, 80)
		mfgconsolefunc.SetPhoneme(act, 2, 100)
		mfgconsolefunc.SetPhoneme(act, 4, 50)
		mfgconsolefunc.SetPhoneme(act, 5, 100)
	elseIf index == 4
		act.SetExpressionOverride(8, Power)
		mfgconsolefunc.SetModifier(act, 0, 100)
		mfgconsolefunc.SetModifier(act, 1, 100)
		mfgconsolefunc.SetModifier(act, 2, 100)
		mfgconsolefunc.SetModifier(act, 3, 100)
		mfgconsolefunc.SetModifier(act, 4, 100)
		mfgconsolefunc.SetModifier(act, 5, 100)
		mfgconsolefunc.SetPhoneme(act, 2, 100)
		mfgconsolefunc.SetPhoneme(act, 5, 40)
	elseIf index == 5
		act.SetExpressionOverride(9, Power)
		mfgconsolefunc.SetModifier(act, 2, 100)
		mfgconsolefunc.SetModifier(act, 3, 100)
		mfgconsolefunc.SetModifier(act, 4, 100)
		mfgconsolefunc.SetModifier(act, 5, 100)
		mfgconsolefunc.SetModifier(act, 11, 90)
		mfgconsolefunc.SetPhoneme(act, 0, 30)
		mfgconsolefunc.SetPhoneme(act, 2, 30)
	elseIf index == 6
		act.SetExpressionOverride(9, Power)
		mfgconsolefunc.SetModifier(act, 2, 100)
		mfgconsolefunc.SetModifier(act, 3, 100)
		mfgconsolefunc.SetModifier(act, 4, 100)
		mfgconsolefunc.SetModifier(act, 5, 100)
		mfgconsolefunc.SetModifier(act, 11, 90)
		mfgconsolefunc.SetPhoneme(act, 0, 100)
		mfgconsolefunc.SetPhoneme(act, 2, 100)
		mfgconsolefunc.SetPhoneme(act, 11, 40)
	elseIf index == 7
		act.SetExpressionOverride(3, Power)
		mfgconsolefunc.SetModifier(act, 11, 50)
		mfgconsolefunc.SetModifier(act, 13, 14)
		mfgconsolefunc.SetPhoneme(act, 2, 50)
		mfgconsolefunc.SetPhoneme(act, 13, 20)
		mfgconsolefunc.SetPhoneme(act, 15, 40)
	else
		act.SetExpressionOverride(8, Power)
		mfgconsolefunc.SetModifier(act, 0, 100)
		mfgconsolefunc.SetModifier(act, 1, 100)
		mfgconsolefunc.SetModifier(act, 2, 100)
		mfgconsolefunc.SetModifier(act, 3, 100)
		mfgconsolefunc.SetModifier(act, 4, 100)
		mfgconsolefunc.SetModifier(act, 5, 100)
		mfgconsolefunc.SetPhoneme(act, 2, 100)
		mfgconsolefunc.SetPhoneme(act, 5, 100)
		mfgconsolefunc.SetPhoneme(act, 11, 40)
	endIf
endFunction
