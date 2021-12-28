Scriptname CondiExp_TraumaScript extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util

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
	Int power = 20 + trauma*10
	if power > 100
		power = 100
	endif
	Int randomEffect = Utility.RandomInt(1, 12)
	trace("CondiExp_TraumaScript playing effect:" + trauma)
	_painVariants(randomEffect, PlayerRef, power, power)
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
	trace("CondiExp_TraumaScript OnEffectFinish" + safeguard)
	resetMFG(PlayerRef)
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
	trace("Playing sob: " + randomSob)
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
	;random skip 20%
	if index > 10
		return
	endif

	if Power > 100
		Power = 100
	endif
	;float modifier = PowerCur / Power
	float modifier = 1 

	if index == 1
		act.SetExpressionOverride(1, Power)
		mfgconsolefunc.SetPhoneme(act, 1, (10 * modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 5, (30* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 7, (70* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 15, (60* modifier) as Int)
	elseIf index == 2
		act.SetExpressionOverride(3, Power)
		mfgconsolefunc.SetModifier(act, 11, 50)
		mfgconsolefunc.SetModifier(act, 13, 14)
		mfgconsolefunc.SetPhoneme(act, 2, (50* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 13, (10* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 15, (20* modifier) as Int)
	elseIf index == 3
		act.SetExpressionOverride(3, Power)
		mfgconsolefunc.SetModifier(act, 11, 50)
		mfgconsolefunc.SetModifier(act, 13, 14)
		mfgconsolefunc.SetPhoneme(act, 2, (50* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 13, (15* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 15, (25* modifier) as Int)
	elseIf index == 4
		act.SetExpressionOverride(3, Power)
		mfgconsolefunc.SetModifier(act, 11, 50)
		mfgconsolefunc.SetModifier(act, 13, 14)
		mfgconsolefunc.SetPhoneme(act, 2, (50* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 13, (10* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 15, (20* modifier) as Int)
	elseIf index == 5
		act.SetExpressionOverride(9, Power)
		mfgconsolefunc.SetModifier(act, 2, 100)
		mfgconsolefunc.SetModifier(act, 3, 100)
		mfgconsolefunc.SetModifier(act, 4, 100)
		mfgconsolefunc.SetModifier(act, 5, 100)
		mfgconsolefunc.SetModifier(act, 11, 90)
		mfgconsolefunc.SetPhoneme(act, 2, (10* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 0, (10* modifier) as Int)
	elseIf index == 6
		act.SetExpressionOverride(9, Power)
		mfgconsolefunc.SetModifier(act, 2, 100)
		mfgconsolefunc.SetModifier(act, 3, 100)
		mfgconsolefunc.SetModifier(act, 4, 100)
		mfgconsolefunc.SetModifier(act, 5, 100)
		mfgconsolefunc.SetModifier(act, 11, 90)
		mfgconsolefunc.SetPhoneme(act, 0, (100* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 2, (100* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 11, (20* modifier) as Int)
	elseIf index == 7
		act.SetExpressionOverride(8, Power)
		mfgconsolefunc.SetModifier(act, 0, 100)
		mfgconsolefunc.SetModifier(act, 1, 100)
		mfgconsolefunc.SetModifier(act, 2, 100)
		mfgconsolefunc.SetModifier(act, 3, 100)
		mfgconsolefunc.SetModifier(act, 4, 100)
		mfgconsolefunc.SetModifier(act, 5, 100)
		mfgconsolefunc.SetPhoneme(act, 2, (100* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 5, (40* modifier) as Int)
	else
		act.SetExpressionOverride(8, Power)
		mfgconsolefunc.SetModifier(act, 0, 100)
		mfgconsolefunc.SetModifier(act, 1, 100)
		mfgconsolefunc.SetModifier(act, 2, 100)
		mfgconsolefunc.SetModifier(act, 3, 100)
		mfgconsolefunc.SetModifier(act, 4, 100)
		mfgconsolefunc.SetModifier(act, 5, 100)
		mfgconsolefunc.SetPhoneme(act, 2, (50* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 5, (50* modifier) as Int)
		mfgconsolefunc.SetPhoneme(act, 11, (10* modifier) as Int)
	endIf
endFunction
