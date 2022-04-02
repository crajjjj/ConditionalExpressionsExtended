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
	ShowExpression()
	doRegister() 
	playing = true
EndEvent

bool function isRandomEnabled()
	return  Condiexp_GlobalRandom.GetValue() == 1 && Condiexp_ModSuspended.GetValue() == 0 && Condiexp_CurrentlyBusy.GetValue() == 0 && !PlayerRef.GetAnimationVariableInt("i1stPerson") && !PlayerRef.IsRunning()
endfunction

Function doRegister() 
	If  isRandomEnabled()
		Int Seconds = Utility.RandomInt(2, 5)
		RegisterForSingleUpdate(Seconds)
	else
		playing = false
		return	
	endif

endfunction

Function ShowExpression() 
	Utility.Wait(1)
	verbose(PlayerRef,"Random emotion", config.Condiexp_Verbose.GetValue() as Int)
	config.currentExpression = "Random"
	RandomEmotion(PlayerRef, config)
	Utility.Wait(1)
EndFunction

Event OnUpdate()
	If isRandomEnabled()
		ShowExpression()
		doRegister()
	Else
		playing = false
	EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	trace("CondiExp_RandomScript OnEffectFinish")
	int safeguard = 0
	While (playing && safeguard <= 60)
		Utility.Wait(1)
		safeguard = safeguard + 1
	EndWhile
	
	verbose(akTarget, "Random: OnEffectFinish. Time: " + safeguard, Condiexp_Verbose.GetValue() as Int )
	If Condiexp_CurrentlyBusy.GetValue() == 0
		resetMFGSmooth(PlayerRef)
	EndIf
	
EndEvent