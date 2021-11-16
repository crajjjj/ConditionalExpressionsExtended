Scriptname Condiexp_Dirty extends ActiveMagicEffect  
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyDirty Auto
Actor Property PlayerRef Auto
import CondiExp_log
import CondiExp_util

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValue(1)
	trace("Condiexp_Dirty OnEffectStart")
	MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
	Utility.Wait(1)
	ShowExpression() 
EndEvent

Function ShowExpression() 
    Int dirty = Condiexp_CurrentlyDirty.GetValue() as Int

	Utility.Wait(1)
	trace("Condiexp_Dirty OnEffectStart")
    int i = 0

    while i < 95
        _sadVariants(dirty, PlayerRef, i)
        i = i + 5
        if (i > 95)
            i = 95
        Endif
        Utility.Wait(0.1)
    endwhile

	Int randomLook = Utility.RandomInt(1, 10)
	If randomLook == 2
		LookLeft(50, PlayerRef)
	ElseIf randomLook == 4
		LookRight(50, PlayerRef)
	ElseIf randomLook == 8
		LookDown(50, PlayerRef)
	endif 
	Utility.Wait(1)
	
	;and back
	i = 95
    while i > 0
          _sadVariants(dirty, PlayerRef, i)
        i = i - 5
         if (i < 0)
             i = 0
        Endif
        Utility.Wait(0.1)
    endwhile
EndFunction


Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Utility.Wait(3) ;wait for effect cycle to end !!!
	trace("Condiexp_Dirty OnEffectFinish")
	if (Condiexp_CurrentlyDirty.GetValue() == 0)
		resetMFG(PlayerRef)
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

Function _sadVariants(Int index, Actor act, Int Power)
	
	if Power > 100
		Power = 100
	endif

	if index == 1
		act.SetExpressionOverride(3, Power)
		mfgconsolefunc.SetPhoneme(act, 2, 100)
	elseIf index == 2
		act.SetExpressionOverride(3, Power)
		mfgconsolefunc.SetModifier(act, 2, 50)
		mfgconsolefunc.SetModifier(act, 3, 50)
		mfgconsolefunc.SetModifier(act, 4, 50)
		mfgconsolefunc.SetModifier(act, 5, 50)
		mfgconsolefunc.SetModifier(act, 12, 50)
		mfgconsolefunc.SetModifier(act, 13, 50)
        mfgconsolefunc.SetPhoneme(act, 1, 10)
		mfgconsolefunc.SetPhoneme(act, 2, 100)
	else
		act.SetExpressionOverride(3, Power)
        mfgconsolefunc.SetModifier(act, 2, 50)
		mfgconsolefunc.SetModifier(act, 3, 50)
		mfgconsolefunc.SetModifier(act, 4, 50)
		mfgconsolefunc.SetModifier(act, 5, 50)
        mfgconsolefunc.SetModifier(act, 8, 50)
        mfgconsolefunc.SetModifier(act, 12, 30)
		mfgconsolefunc.SetModifier(act, 13, 30)
		mfgconsolefunc.SetPhoneme(act, 1, 10)
		mfgconsolefunc.SetPhoneme(act, 2, 100)
		mfgconsolefunc.SetPhoneme(act, 7, 50)
	endIf
endFunction