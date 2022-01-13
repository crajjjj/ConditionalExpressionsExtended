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
GlobalVariable Property Condiexp_Verbose Auto

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
	
	;random skip 20%
	Int randomSkip = Utility.RandomInt(1, 10)
	if randomSkip > 2
		int topMargin = 3
		if aroused > 50 &&  aroused <= 80
			topMargin = 5
		else
			topMargin = 6
		endif 
		Int randomEffect = Utility.RandomInt(1, topMargin)
		verbose("CondiExp_ArousedScript arousal: " + aroused + ".Effect: " + randomEffect, Condiexp_Verbose.GetValue() as Int)
		_arousedVariants(randomEffect, PlayerRef, power, power)
	else
		verbose("CondiExp_ArousedScript skipping.Arousal: " + aroused, Condiexp_Verbose.GetValue() as Int)
	endif

	Int randomLook = Utility.RandomInt(1, 10)
	If randomLook == 2
		LookLeft(50, PlayerRef)
	ElseIf randomLook == 4
		LookRight(50, PlayerRef)
	ElseIf randomLook == 8
		LookDown(50, PlayerRef)
	endif 
	
	Utility.Wait(5)
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
	verbose("CondiExp_ArousedScript OnEffectFinish. Time: " + safeguard, Condiexp_Verbose.GetValue() as Int)
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
	if Power > 100
		Power = 100
	endif
	
	if index == 1

		SmoothSetExpression(act, 2, Power, 0)
		SmoothSetPhoneme(act, 5, 30)
		SmoothSetPhoneme(act, 6, 10)
	elseIf  index == 2
		SmoothSetExpression(act, 10, Power, 0)
		
		SmoothSetModifier(act,0,1,10)
		SmoothSetModifier(act,2,3,25)
		SmoothSetModifier(act,6,7,100)
		SmoothSetModifier(act,12,13,30)
		
		SmoothSetPhoneme(act, 4, 35)
		SmoothSetPhoneme(act, 10, 20)
		SmoothSetPhoneme(act, 12, 30)
	elseIf  index == 3
		SmoothSetExpression(act, 4, Power, 0)

		SetModifier(act, 11, 20)

		SmoothSetPhoneme(act, 1, 10)
		SmoothSetPhoneme(act, 11, 10)
	elseIf  index == 4

		SmoothSetExpression(act, 10, Power, 0)
		SmoothSetPhoneme(act, 0, 30)
		SmoothSetPhoneme(act, 7, 60)
		SmoothSetPhoneme(act, 12, 60)

		SmoothSetModifier(act,0,1,30)
		SmoothSetModifier(act,4,5,100)
		SmoothSetModifier(act,12,13,30)
	elseIf index == 5
		SmoothSetExpression(act, 10, Power, 0)
		SmoothSetPhoneme(act, 0, 60)
		SmoothSetPhoneme(act, 6, 50)
		SmoothSetPhoneme(act, 7, 50)

		SmoothSetModifier(act,0,1,30)
		SmoothSetModifier(act,2,3,70)
		SmoothSetModifier(act,4,5,100)
		SmoothSetModifier(act,12,13,40)
	else
		SmoothSetExpression(act, 7, Power, 0)
		SmoothSetPhoneme(act, 0, 60)
		SmoothSetPhoneme(act, 6, 50)
		SmoothSetPhoneme(act, 7, 50)

		SmoothSetModifier(act,0,1,30)
		SmoothSetModifier(act,2,3,80)
		SmoothSetModifier(act,4,5,100)
		SmoothSetModifier(act,12,13,60)
	endIf
endFunction
