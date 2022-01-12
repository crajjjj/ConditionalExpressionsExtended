Scriptname CondiExp_ArousedScript extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util
Import mfgconsolefunc

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

	;random skip 20%
	Int randomSkip = Utility.RandomInt(1, 10)
	if randomSkip > 2
		_arousedVariants(aroused, PlayerRef, power, power)
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
	resetMFGSmooth(PlayerRef)
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
	;float modifier = PowerCur / Power
	float modifier = 1 
	if Power > 100
		Power = 100
	endif

	if index > 0 &&  index <= 40
		;act.SetExpressionOverride(2, Power)
		SmoothSetExpression(act, 2, Power, 0)
		SmoothSetPhoneme(act, 5, (30* modifier) as Int)
		SmoothSetPhoneme(act, 6, (10* modifier) as Int)
	elseIf  index > 40 &&  index <= 50
		;act.SetExpressionOverride(10, Power)
		SmoothSetExpression(act, 10, Power, 0)
		SetModifier(act, 0, 10)
		SetModifier(act, 1, 10)
		SetModifier(act, 3, 25)
		SetModifier(act, 6, 100)
		SetModifier(act, 7, 100)
		SetModifier(act, 12, 30)
		SetModifier(act, 13, 30)
		SmoothSetPhoneme(act, 4, (35* modifier) as Int)
		SmoothSetPhoneme(act, 10, (20* modifier) as Int)
		SmoothSetPhoneme(act, 12, (30* modifier) as Int)
	elseIf  index > 50 &&  index <= 60
		;act.SetExpressionOverride(4, Power)
		SmoothSetExpression(act, 4, Power, 0)
		SetModifier(act, 11, 20)
		SmoothSetPhoneme(act, 1, (10* modifier) as Int)
		SmoothSetPhoneme(act, 11, (10* modifier) as Int)
	elseIf  index > 60 &&  index <= 70
		;act.SetExpressionOverride(10, Power)
		SmoothSetExpression(act, 10, Power, 0)
		SmoothSetPhoneme(act, 0, (30* modifier) as Int)
		SmoothSetPhoneme(act, 7, (60* modifier) as Int)
		SmoothSetPhoneme(act, 12, (60* modifier) as Int)
		SetModifier(act, 0, 30)
		SetModifier(act, 1, 30)
		SetModifier(act, 4, 100)
		SetModifier(act, 5, 100)
		SetModifier(act, 12, 30)
		SetModifier(act, 13, 30)
	elseIf index > 70 &&  index <= 80
		;act.SetExpressionOverride(10, Power)
		SmoothSetExpression(act, 10, Power, 0)
		SmoothSetPhoneme(act, 0, (60* modifier) as Int)
		SmoothSetPhoneme(act, 6, (50* modifier) as Int)
		SmoothSetPhoneme(act, 7, (50* modifier) as Int)
		SetModifier(act, 0, 30)
		SetModifier(act, 1, 30)
		SetModifier(act, 2, 70)
		SetModifier(act, 3, 70)
		SetModifier(act, 4, 100)
		SetModifier(act, 5, 100)
		SetModifier(act, 12, 40)
		SetModifier(act, 13, 40)
	else
		;act.SetExpressionOverride(7, Power)
		SmoothSetExpression(act, 7, Power, 0)
		SmoothSetPhoneme(act, 0, (60* modifier) as Int)
		SmoothSetPhoneme(act, 6, (50* modifier) as Int)
		SmoothSetPhoneme(act, 7, (50* modifier) as Int)
		SetModifier(act, 0, 30)
		SetModifier(act, 1, 30)
		SetModifier(act, 2, 80)
		SetModifier(act, 3, 80)
		SetModifier(act, 4, 100)
		SetModifier(act, 5, 100)
		SetModifier(act, 12, 60)
		SetModifier(act, 13, 60)
	endIf
endFunction
