Scriptname CondiExp_RandomScript extends ActiveMagicEffect  
import CondiExp_util
import CondiExp_log
import CondiExp_Expression_Util

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyCold Auto
GlobalVariable Property Condiexp_ColdGlobal Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property CondiExp_PlayerIsHigh Auto
GlobalVariable Property CondiExp_PlayerIsDrunk Auto
GlobalVariable Property Condiexp_GlobalRandomFrequency Auto
GlobalVariable Property Condiexp_CurrentlyTrauma Auto
GlobalVariable Property Condiexp_CurrentlyDirty Auto
GlobalVariable Property Condiexp_ModSuspended Auto
GlobalVariable Property Condiexp_GlobalRandom Auto
GlobalVariable Property Condiexp_Verbose Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
bool playing = false
condiexp_MCM Property config auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	;verbose(akTarget, "Random: OnEffectStart", Condiexp_Verbose.GetValueInt())
	config.currentExpression = "Random"
	RegisterForSingleUpdate(1)  
	playing = true
EndEvent

Event OnUpdate()
	If isRandomEnabled()
   		PlayRandomExpression(PlayerRef, config)
        RegisterForSingleUpdate( RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 2, 5))
    EndIf
EndEvent

bool function isRandomEnabled()
	bool enabled = Condiexp_GlobalRandom.GetValueInt() == 1
	enabled = enabled && Condiexp_ModSuspended.GetValueInt() == 0 && Condiexp_CurrentlyBusy.GetValueInt() == 0 && Condiexp_CurrentlyBusyImmediate.GetValueInt() == 0
	enabled = enabled && !PlayerRef.GetAnimationVariableInt("i1stPerson") && !PlayerRef.IsRunning() 
	enabled = enabled && playing
	return enabled 
endfunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	playing = false
	Utility.Wait(1)
	;verbose(PlayerRef, "Random: OnEffectFinish", Condiexp_Verbose.GetValueInt() )
	If Condiexp_CurrentlyBusy.GetValueInt() == 0 && Condiexp_CurrentlyBusyImmediate.GetValueInt() == 0
		resetMFGSmooth(PlayerRef)
	EndIf
	
EndEvent