Scriptname CondiExp_RandomScript extends ActiveMagicEffect  
import CondiExp_util
import CondiExp_log
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
	trace("CondiExp_RandomScript OnEffectStart")
	ShowExpression()
EndEvent

Function ShowExpression() 
	Utility.Wait(1)
	Int Seconds = Utility.RandomInt(2, 5)
	RandomEmotion(PlayerRef)
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	trace("CondiExp_RandomScript OnEffectFinish")
	Utility.Wait(1)
	PlayerRef.ClearExpressionOverride()
	MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
EndEvent