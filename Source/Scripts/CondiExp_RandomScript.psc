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
bool playing = false
condiexp_MCM Property config auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	verbose(akTarget, "Random: OnEffectStart", Condiexp_Verbose.GetValue() as Int)
	config.currentExpression = "Random"
EndEvent

bool function isRandomEnabled()
	return  Condiexp_GlobalRandom.GetValue() == 1 && Condiexp_ModSuspended.GetValue() == 0 && Condiexp_CurrentlyBusy.GetValue() == 0 && !PlayerRef.GetAnimationVariableInt("i1stPerson") && !PlayerRef.IsRunning()
endfunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	int safeguard = 1
	While (isRandomEnabled() && safeguard <= 5)
		PlayRandomExpression(PlayerRef, config)
		safeguard = safeguard + 1
	EndWhile
	verbose(PlayerRef, "Random: OnEffectFinish. Showed times: " + safeguard, Condiexp_Verbose.GetValue() as Int )
	If Condiexp_CurrentlyBusy.GetValue() == 0
		resetMFGSmooth(PlayerRef)
	EndIf
	
EndEvent