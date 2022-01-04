Scriptname Condiexp_Dirty extends ActiveMagicEffect  
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyDirty Auto
Actor Property PlayerRef Auto
import CondiExp_log
import CondiExp_util

bool playing = false

;no loops cause dirty is not strong emotion and can be overridden by pain etc
Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValue(1)
	playing = true
	Int Seconds = Utility.RandomInt(2, 4)
	Utility.Wait(Seconds)
	trace("Condiexp_Dirty OnEffectStart")
	ShowExpression() 
EndEvent


Function ShowExpression() 
    Int dirty = Condiexp_CurrentlyDirty.GetValue() as Int

	Utility.Wait(1)
	trace("Condiexp_Dirty OnEffectStart")
	Int power = 100

	;random skip 33%
	Int randomSkip = Utility.RandomInt(1, 10)
	if randomSkip > 3
    	_sadVariants(dirty, PlayerRef, power, power)
	endif

	Int randomLook = Utility.RandomInt(1, 10)
	If randomLook == 2
		LookLeft(50, PlayerRef)
	ElseIf randomLook == 4
		LookRight(50, PlayerRef)
	ElseIf randomLook == 8
		LookDown(50, PlayerRef)
	endif 
	Utility.Wait(10)
	playing = false
EndFunction


Event OnEffectFinish(Actor akTarget, Actor akCaster)
	; keep script running
	int safeguard = 0
	While (playing && safeguard <= 30)
		Utility.Wait(1)
		safeguard = safeguard + 1
	EndWhile
	trace("Condiexp_Dirty OnEffectFinish" + safeguard)
	resetMFG(PlayerRef)
	Utility.Wait(3)
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

Function _sadVariants(Int index, Actor act, int Power, int PowerCur)
	Int expression = Utility.RandomInt(1, index)

	if expression == 1
		act.SetExpressionOverride(3, 30)
		mfgconsolefunc.SetPhoneme(act, 2, 100)
	elseIf expression == 2
		act.SetExpressionOverride(3, 60)
		mfgconsolefunc.SetModifier(act, 2, 50)
		mfgconsolefunc.SetModifier(act, 3, 50)
		mfgconsolefunc.SetModifier(act, 4, 50)
		mfgconsolefunc.SetModifier(act, 5, 50)
		mfgconsolefunc.SetModifier(act, 12, 50)
		mfgconsolefunc.SetModifier(act, 13, 50)
        mfgconsolefunc.SetPhoneme(act, 1, 10)
		mfgconsolefunc.SetPhoneme(act, 2, 100)
	else
		act.SetExpressionOverride(3, 90)
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