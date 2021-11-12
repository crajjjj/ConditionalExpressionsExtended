Scriptname CondiExp_RandomScript extends ActiveMagicEffect  
import CondiExp_util

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyCold Auto
GlobalVariable Property Condiexp_ColdGlobal Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property CondiExp_PlayerIsHigh Auto
GlobalVariable Property CondiExp_PlayerIsDrunk Auto
GlobalVariable Property Condiexp_GlobalRandomFrequency Auto
GlobalVariable Property Condiexp_CurrentlyTrauma Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)

If Condiexp_ColdGlobal.GetValue() == 1
	GlobalVariable Temp = Game.GetFormFromFile(0x00068119, "Frostfall.esp") as GlobalVariable
	If Temp.GetValue() > 2 
		Condiexp_CurrentlyCold.SetValue(1)
		else
		Condiexp_CurrentlyCold.SetValue(0)
	endif

	If Condiexp_CurrentlyCold.GetValue() == 0 && Condiexp_CurrentlyBusy.GetValue() == 0 && Condiexp_CurrentlyTrauma.GetValue() == 0
		Utility.Wait(0.5)
		ShowExpression()
	endif
endif
EndEvent

Function ShowExpression() 
	RandomEmotion(PlayerRef)
	Utility.Wait(1)
	If !PlayerRef.IsRunning() || !PlayerRef.GetAnimationVariableInt("i1stPerson")
		Int Seconds = Utility.RandomInt(2, 5)
		RegisterForSingleUpdate(Seconds)
	endif
EndFunction

Event OnUpdate()
If !PlayerRef.GetAnimationVariableInt("i1stPerson")
	If Condiexp_CurrentlyBusy.GetValue() == 0
		RandomEmotion(PlayerRef)
	EndIf
endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)

If Condiexp_CurrentlyBusy.GetValue() == 0 && Condiexp_CurrentlyTrauma.GetValue() == 0
	PlayerRef.ClearExpressionOverride()
	MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
endif

EndEvent