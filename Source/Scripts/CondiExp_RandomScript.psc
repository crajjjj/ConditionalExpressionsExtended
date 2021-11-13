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
GlobalVariable Property Condiexp_CurrentlyDirty Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Utility.Wait(0.5)
	ShowExpression()
EndEvent

Function ShowExpression() 
	RandomEmotion(PlayerRef)
	Utility.Wait(1)
	Int Seconds = Utility.RandomInt(2, 5)
	RegisterForSingleUpdate(Seconds)
EndFunction

Event OnUpdate()
	If Condiexp_CurrentlyBusy.GetValue() == 0
		RandomEmotion(PlayerRef)
	EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Utility.Wait(2)
	PlayerRef.ClearExpressionOverride()
	MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
EndEvent