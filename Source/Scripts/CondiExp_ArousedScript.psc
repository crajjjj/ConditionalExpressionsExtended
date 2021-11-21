Scriptname CondiExp_ArousedScript extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_GlobalAroused Auto
GlobalVariable Property Condiexp_CurrentlyAroused Auto
GlobalVariable Property Condiexp_ModSuspended Auto
GlobalVariable Property Condiexp_Sounds Auto



Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValue(1)
	trace("CondiExp_ArousedScript OnEffectStart")
	RegisterForSingleUpdate(0.01)
EndEvent

Function doRegister(float seconds) 
	bool isSuspended =  Condiexp_ModSuspended.GetValue() == 1
	bool isDisabled = Condiexp_GlobalAroused.GetValue() == 0
	bool lowStamina = PlayerRef.GetActorValuePercentage("Stamina") < 0.5
	bool lowHealth = PlayerRef.GetActorValuePercentage("Health") < 0.5
	bool inCombat = PlayerRef.IsInCombat()
	bool isSwimming = PlayerRef.IsSwimming()
	bool IsSneaking = PlayerRef.IsSneaking()
	If  isSuspended || isDisabled || lowStamina || lowHealth || inCombat || isSwimming || IsSneaking
		return
	endif
	RegisterForSingleUpdate(seconds)
endfunction

event OnUpdate()
	ShowExpression() 
EndEvent

Function ShowExpression() 
    Int aroused = Condiexp_CurrentlyAroused.GetValue() as Int
	;either 0 or aroused level > Condiexp_MinAroused
	if aroused > 0
		MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
		Utility.Wait(1)

		trace("CondiExp_ArousedScript playing effect")
		Int randomseed = Utility.RandomInt(1, 20)
		_arousedVariants(aroused, PlayerRef, randomseed + aroused)
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
		Int Seconds = Utility.RandomInt(2, 4)
		RegisterForSingleUpdate(Seconds)
	endif

EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Utility.Wait(3); keep script running
	trace("CondiExp_ArousedScript OnEffectFinish")
	if (Condiexp_CurrentlyAroused.GetValue() == 0)
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
Function _arousedVariants(Int index, Actor act, Int Power)
	
	if Power > 100
		Power = 100
	endif

	if index > 0 &&  index <= 40
		act.SetExpressionOverride(2, Power)
		mfgconsolefunc.SetPhoneme(act, 5, 30)
		mfgconsolefunc.SetPhoneme(act, 6, 10)
	elseIf  index > 40 &&  index <= 50
		act.SetExpressionOverride(10, Power)
		mfgconsolefunc.SetModifier(act, 0, 10)
		mfgconsolefunc.SetModifier(act, 1, 10)
		mfgconsolefunc.SetModifier(act, 3, 25)
		mfgconsolefunc.SetModifier(act, 6, 100)
		mfgconsolefunc.SetModifier(act, 7, 100)
		mfgconsolefunc.SetModifier(act, 12, 30)
		mfgconsolefunc.SetModifier(act, 13, 30)
		mfgconsolefunc.SetPhoneme(act, 4, 35)
		mfgconsolefunc.SetPhoneme(act, 10, 20)
		mfgconsolefunc.SetPhoneme(act, 12, 30)
	elseIf  index > 50 &&  index <= 60
		act.SetExpressionOverride(4, Power)
		mfgconsolefunc.SetModifier(act, 11, 20)
		mfgconsolefunc.SetPhoneme(act, 1, 10)
		mfgconsolefunc.SetPhoneme(act, 11, 10)
	elseIf  index > 60 &&  index <= 70
		act.SetExpressionOverride(10, Power)
		mfgconsolefunc.SetPhoneme(act, 0, 30)
		mfgconsolefunc.SetPhoneme(act, 7, 60)
		mfgconsolefunc.SetPhoneme(act, 12, 60)
		mfgconsolefunc.SetModifier(act, 0, 30)
		mfgconsolefunc.SetModifier(act, 1, 30)
		mfgconsolefunc.SetModifier(act, 4, 100)
		mfgconsolefunc.SetModifier(act, 5, 100)
		mfgconsolefunc.SetModifier(act, 12, 70)
		mfgconsolefunc.SetModifier(act, 13, 70)
	elseIf index > 70 &&  index <= 80
		act.SetExpressionOverride(10, Power)
		mfgconsolefunc.SetPhoneme(act, 0, 60)
		mfgconsolefunc.SetPhoneme(act, 6, 50)
		mfgconsolefunc.SetPhoneme(act, 7, 50)
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
		mfgconsolefunc.SetPhoneme(act, 0, 60)
		mfgconsolefunc.SetPhoneme(act, 6, 50)
		mfgconsolefunc.SetPhoneme(act, 7, 50)
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
