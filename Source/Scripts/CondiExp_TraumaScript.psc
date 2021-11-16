Scriptname CondiExp_TraumaScript extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyTrauma Auto
GlobalVariable Property Condiexp_Sounds Auto
sound property CondiExp_BreathingFemale auto
sound property CondiExp_SobbingFemale1 auto
sound property CondiExp_SobbingFemale2 auto
sound property CondiExp_SobbingFemale3 auto
sound property CondiExp_SobbingFemale4 auto
sound property CondiExp_SobbingFemale5 auto
;todelete
Faction Property SexLabAnimatingFaction Auto



Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValue(1)
	trace("CondiExp_TraumaScript OnEffectStart")
	RegisterForSingleUpdate(0.01)
EndEvent

event OnUpdate()
	ShowExpression() 
EndEvent

Function ShowExpression() 
    Int trauma = Condiexp_CurrentlyTrauma.GetValue() as Int

	if trauma > 0
		MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
		Utility.Wait(1)

		trace("CondiExp_TraumaScript playing effect")
		Int randomseed = Utility.RandomInt(1, 20)
		_painVariants(trauma, PlayerRef, randomseed + trauma*10)
		Utility.Wait(2)
		BreatheAndSob(trauma)
		RegisterForSingleUpdate(3)
	endif

EndFunction

Function BreatheAndSob(int trauma)
	If PlayerRef.IsDead()
		return
	endif

	Inhale(33,73, PlayerRef)
	;;;;;;;;;;; SOUNDS ;;;;;;;;;;;;
	Int sobchance25percent= Utility.RandomInt(1, 5)
	 
	If Condiexp_Sounds.GetValue() > 0 && sobchance25percent == 3
		playBreathOrRandomSob(trauma)  
	endif
	;;;;;;;;;
	Int randomLook = Utility.RandomInt(1, 10)
	If randomLook == 2
		LookLeft(50, PlayerRef)
	ElseIf randomLook == 4
		LookRight(50, PlayerRef)
	ElseIf randomLook == 8
		LookDown(50, PlayerRef)
	endif 
	Utility.Wait(1)

	Exhale(73,10, PlayerRef)

	Utility.Wait(1)
	
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Utility.Wait(3); keep script running
	trace("CondiExp_TraumaScript OnEffectFinish")
	if (Condiexp_CurrentlyTrauma.GetValue() == 0)
		PlayerRef.ClearExpressionOverride()
		MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
	endif

	Condiexp_CurrentlyBusy.SetValue(0)
;	log("Trauma OnEffectFinish")
EndEvent

Function playBreathOrRandomSob(int trauma)
	
	if trauma<=3
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
Function _painVariants(Int index, Actor act, Int Power)
	
	if Power > 100
		Power = 100
	endif

	if index == 1
		act.SetExpressionOverride(3, Power)
		mfgconsolefunc.SetModifier(act, 11, 50)
		mfgconsolefunc.SetModifier(act, 13, 14)
		mfgconsolefunc.SetPhoneme(act, 2, 50)
		mfgconsolefunc.SetPhoneme(act, 13, 20)
		mfgconsolefunc.SetPhoneme(act, 15, 40)
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
		mfgconsolefunc.SetModifier(act, 11, 50)
		mfgconsolefunc.SetModifier(act, 13, 14)
		mfgconsolefunc.SetPhoneme(act, 2, 50)
		mfgconsolefunc.SetPhoneme(act, 13, 20)
		mfgconsolefunc.SetPhoneme(act, 15, 40)
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
		act.SetExpressionOverride(9, Power)
		mfgconsolefunc.SetModifier(act, 2, 100)
		mfgconsolefunc.SetModifier(act, 3, 100)
		mfgconsolefunc.SetModifier(act, 4, 100)
		mfgconsolefunc.SetModifier(act, 5, 100)
		mfgconsolefunc.SetModifier(act, 11, 90)
		mfgconsolefunc.SetPhoneme(act, 0, 30)
		mfgconsolefunc.SetPhoneme(act, 2, 30)
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
