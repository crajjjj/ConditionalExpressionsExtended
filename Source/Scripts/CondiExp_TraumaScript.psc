Scriptname CondiExp_TraumaScript extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util
Import mfgconsolefunc

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyTrauma Auto
GlobalVariable Property Condiexp_ModSuspended Auto
GlobalVariable Property Condiexp_GlobalTrauma Auto

GlobalVariable Property Condiexp_Sounds Auto
sound property CondiExp_BreathingFemale auto
sound property CondiExp_SobbingFemale1 auto
sound property CondiExp_SobbingFemale2 auto
sound property CondiExp_SobbingFemale3 auto
sound property CondiExp_SobbingFemale4 auto
sound property CondiExp_SobbingFemale5 auto
;todelete
Faction Property SexLabAnimatingFaction Auto
GlobalVariable Property Condiexp_Verbose Auto

bool playing = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValue(1)
	playing = true
	trace("CondiExp_TraumaScript OnEffectStart")
	Int Seconds = Utility.RandomInt(2, 4)
	Utility.Wait(Seconds)
	Int trauma = Condiexp_CurrentlyTrauma.GetValue() as Int
	Utility.Wait(1)
	ShowExpression(trauma)
	Utility.Wait(1) 
EndEvent

Function ShowExpression(int trauma) 
	Int power = 20 + trauma * 10
	if power > 100
		power = 100
	endif
	
	;random skip 20%
	Int randomSkip = Utility.RandomInt(1, 10)
	if randomSkip > 2
		int topMargin = 3
		int bottomMargin = 1
		if trauma > 4 && trauma <= 7
			topMargin = 6
		else
			bottomMargin = 4
			topMargin = 10
		endif 
		Int randomEffect = Utility.RandomInt(bottomMargin, topMargin)
		verbose("CondiExp_TraumaScript Trauma: " + trauma + ".Effect: " + randomEffect, Condiexp_Verbose.GetValue() as Int)
		_painVariants(randomEffect, PlayerRef, power, power)
	else
		verbose("CondiExp_TraumaScript skipping.Trauma: " + trauma, Condiexp_Verbose.GetValue() as Int)
	endif
	Utility.Wait(1)

	Int randomLook = Utility.RandomInt(1, 10)
	If randomLook == 2
		LookLeft(50, PlayerRef)
	ElseIf randomLook == 4
		LookRight(50, PlayerRef)
	ElseIf randomLook == 8
		LookDown(50, PlayerRef)
	endif 
	Utility.Wait(1)
	BreatheAndSob(trauma)
	Utility.Wait(6)
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
	verbose("CondiExp_TraumaScript OnEffectFinish. Time: " + safeguard, Condiexp_Verbose.GetValue() as Int)
	Utility.Wait(3)
	Condiexp_CurrentlyBusy.SetValue(0)
EndEvent


Function BreatheAndSob(int trauma)
	If PlayerRef.IsDead()
		return
	endif
	;;;;;;;;;;; SOUNDS ;;;;;;;;;;;;
	Int sobchance = Utility.RandomInt(1, 5)
	 
	If Condiexp_Sounds.GetValue() > 0 && sobchance == 3
		playBreathOrRandomSob(trauma)  
	endif
	;;;;;;;;;

	Utility.Wait(1)
EndFunction

Function playBreathOrRandomSob(int trauma)
	
	if trauma <= 3
		CondiExp_BreathingFemale.play(PlayerRef) 
		return
	endIf

	Int randomSob = Utility.RandomInt(1, 5)
	verbose("Playing sob: " + randomSob, Condiexp_Verbose.GetValue() as Int)
	if randomSob == 1
		CondiExp_SobbingFemale1.play(PlayerRef)
	elseIf randomSob == 2
		CondiExp_SobbingFemale2.play(PlayerRef)
	elseIf randomSob == 3
		CondiExp_SobbingFemale3.play(PlayerRef)
	elseIf randomSob == 4
		CondiExp_SobbingFemale4.play(PlayerRef)
	else 
		CondiExp_SobbingFemale5.play(PlayerRef)
	endif
endfunction
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
Function _painVariants(Int index, Actor act, int Power, int PowerCur)
	if Power > 100
		Power = 100
	endif

	if index == 1
		SmoothSetExpression(act,1,Power,0)
		SmoothSetPhoneme(act, 1, 10)
		SmoothSetPhoneme(act, 5, 30)
		SmoothSetPhoneme(act, 7, 70)
		SmoothSetPhoneme(act, 15, 60)
	elseIf index == 2
		
		SmoothSetExpression(act,3,Power,0)

		SmoothSetModifier(act,11,-1,50)
		SmoothSetModifier(act,13,-1,14)

		SmoothSetPhoneme(act, 2, 50)
		SmoothSetPhoneme(act, 13, 10)
		SmoothSetPhoneme(act, 15, 20)
	elseIf index == 3
	
		SmoothSetExpression(act,3,Power,0)

		SmoothSetModifier(act,11,-1,50)
		SmoothSetModifier(act,13,-1,14)

		SmoothSetPhoneme(act, 2, 50)
		SmoothSetPhoneme(act, 13, 15)
		SmoothSetPhoneme(act, 15, 25)
	elseIf index == 4
		SmoothSetExpression(act,3,Power,0)
	
		SmoothSetModifier(act,11,-1,50)
		SmoothSetModifier(act,13,-1,14)

		SmoothSetPhoneme(act, 2, 50)
		SmoothSetPhoneme(act, 13, 10)
		SmoothSetPhoneme(act, 15, 20)
	elseIf index == 5
	
		SmoothSetExpression(act,9, Power, 0)
	
		SmoothSetModifier(act,2,3,100)
		SmoothSetModifier(act,4,5,100)
		SmoothSetModifier(act,11,-1,90)

		SmoothSetPhoneme(act, 2, 10)
		SmoothSetPhoneme(act, 0, 10)
	elseIf index == 6
		SmoothSetExpression(act,9,Power,0)

		SmoothSetModifier(act,2,3,100)
		SmoothSetModifier(act,4,5,100)
		SmoothSetModifier(act,11,-1,90)

		SmoothSetPhoneme(act, 0, 10)
		SmoothSetPhoneme(act, 2, 100)
		SmoothSetPhoneme(act, 11, 20)
	elseIf index == 7
		SmoothSetExpression(act,8,Power,0)

		SmoothSetModifier(act,0,1,100)
		SmoothSetModifier(act,2,3,100)

		SmoothSetModifier(act,4,5,100)
		SmoothSetPhoneme(act, 2, 100)
		SmoothSetPhoneme(act, 5, 40)
	else
		SmoothSetExpression(act,8,Power,0)
	
		SmoothSetModifier(act,0,1,100)
		SmoothSetModifier(act,2,3,100)
		SmoothSetModifier(act,4,5,100)

		SmoothSetPhoneme(act, 2, 50)
		SmoothSetPhoneme(act, 5, 50)
		SmoothSetPhoneme(act, 11, 10)
	endIf
endFunction
