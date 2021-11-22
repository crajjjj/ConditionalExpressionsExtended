Scriptname CondiExp_ArousedScript extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_GlobalAroused Auto
GlobalVariable Property Condiexp_CurrentlyAroused Auto
GlobalVariable Property Condiexp_ModSuspended Auto
GlobalVariable Property Condiexp_Sounds Auto
bool playing = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValue(1)
	playing = true
	trace("CondiExp_ArousedScript OnEffectStart")
	Int Seconds = Utility.RandomInt(2, 4)
	Utility.Wait(Seconds)
	;either 0 or aroused level > Condiexp_MinAroused
	Int aroused = Condiexp_CurrentlyAroused.GetValue() as Int
	ShowExpression(aroused)
	Utility.Wait(1)
EndEvent

Function ShowExpression(int aroused) 
	Int power = 20 + aroused
	if power > 100
		power = 100
	endif
	int i = 0
	trace("CondiExp_ArousedScript playing effect")

	while i < power
		_arousedVariants(aroused, PlayerRef, power, i)
        i = i + 5
        if (i > power)
            i = power
        Endif
        Utility.Wait(0.5)
    endwhile

	Int randomLook = Utility.RandomInt(1, 10)
	If randomLook == 2
		LookLeft(50, PlayerRef)
	ElseIf randomLook == 4
		LookRight(50, PlayerRef)
	ElseIf randomLook == 8
		LookDown(50, PlayerRef)
	endif 
	Utility.Wait(0.5)
	
	;and back
	i = power
    while i > 0
		_arousedVariants(aroused, PlayerRef, power, i)
        i = i - 5
         if (i < 0)
             i = 0
        Endif
        Utility.Wait(1)
    endwhile
	Utility.Wait(1)
	playing = false
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	; keep script running
	int safeguard = 0
	While (playing && safeguard <= 30)
		Utility.Wait(1)
		safeguard = safeguard + 1
	EndWhile
	resetMFG(PlayerRef)
	Utility.Wait(3)
	trace("CondiExp_ArousedScript OnEffectFinish " + safeguard)
	
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
Function _arousedVariants(Int index, Actor act, int Power, int PowerCur)
	float modifier = PowerCur / Power
	if Power > 100
		Power = 100
	endif

	if index > 0 &&  index <= 40
		act.SetExpressionOverride(2, Power)
		mfgconsolefunc.SetPhoneme(act, 5, (30* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 6, (10* modifier) as Int)
	elseIf  index > 40 &&  index <= 50
		act.SetExpressionOverride(10, Power)
		mfgconsolefunc.SetModifier(act, 0, 10)
		mfgconsolefunc.SetModifier(act, 1, 10)
		mfgconsolefunc.SetModifier(act, 3, 25)
		mfgconsolefunc.SetModifier(act, 6, 100)
		mfgconsolefunc.SetModifier(act, 7, 100)
		mfgconsolefunc.SetModifier(act, 12, 30)
		mfgconsolefunc.SetModifier(act, 13, 30)
		mfgconsolefunc.SetPhoneme(act, 4, (35* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 10, (20* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 12, (30* modifier) as Int)
	elseIf  index > 50 &&  index <= 60
		act.SetExpressionOverride(4, Power)
		mfgconsolefunc.SetModifier(act, 11, 20)
		mfgconsolefunc.SetPhoneme(act, 1, (10* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 11, (10* modifier) as Int)
	elseIf  index > 60 &&  index <= 70
		act.SetExpressionOverride(10, Power)
		mfgconsolefunc.SetPhoneme(act, 0, (30* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 7, (60* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 12, (60* modifier) as Int)
		mfgconsolefunc.SetModifier(act, 0, 30)
		mfgconsolefunc.SetModifier(act, 1, 30)
		mfgconsolefunc.SetModifier(act, 4, 100)
		mfgconsolefunc.SetModifier(act, 5, 100)
		mfgconsolefunc.SetModifier(act, 12, 70)
		mfgconsolefunc.SetModifier(act, 13, 70)
	elseIf index > 70 &&  index <= 80
		act.SetExpressionOverride(10, Power)
		mfgconsolefunc.SetPhoneme(act, 0, (60* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 6, (50* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 7, (50* modifier) as Int)
		mfgconsolefunc.SetModifier(act, 0, 30)
		mfgconsolefunc.SetModifier(act, 1, 30)
		mfgconsolefunc.SetModifier(act, 2, 70)
		mfgconsolefunc.SetModifier(act, 3, 70)
		mfgconsolefunc.SetModifier(act, 4, 100)
		mfgconsolefunc.SetModifier(act, 5, 100)
		mfgconsolefunc.SetModifier(act, 12, 70)
		mfgconsolefunc.SetModifier(act, 13, 70)
	else
		act.SetExpressionOverride(7, Power)
		mfgconsolefunc.SetPhoneme(act, 0, (60* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 6, (50* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 7, (50* modifier) as Int)
		mfgconsolefunc.SetModifier(act, 0, 30)
		mfgconsolefunc.SetModifier(act, 1, 30)
		mfgconsolefunc.SetModifier(act, 2, 80)
		mfgconsolefunc.SetModifier(act, 3, 80)
		mfgconsolefunc.SetModifier(act, 4, 100)
		mfgconsolefunc.SetModifier(act, 5, 100)
		mfgconsolefunc.SetModifier(act, 12, 100)
		mfgconsolefunc.SetModifier(act, 13, 100)
	endIf
endFunction
