Scriptname CondiExp_ArousedScript extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util
import CondiExp_Expression_Util
Import mfgconsolefunc

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
GlobalVariable Property Condiexp_GlobalAroused Auto
GlobalVariable Property Condiexp_CurrentlyAroused Auto
GlobalVariable Property Condiexp_ModSuspended Auto
GlobalVariable Property Condiexp_Sounds Auto
GlobalVariable Property Condiexp_Verbose Auto

condiexp_MCM Property config auto

bool playing = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValueInt(1)
	playing = true
	;verbose(akTarget, "Aroused: OnEffectStart", Condiexp_Verbose.GetValueInt())
EndEvent

Function aroused()
	If isArousedEnabled()
        config.currentExpression = "Aroused"
		Int arousal = Condiexp_CurrentlyAroused.GetValueInt()
		PlayArousedExpression(PlayerRef, arousal, config)
		Utility.Wait(RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 4, 6))
    else
		log("CondiExp_Aroused: cancelled effect")
	endif
EndFunction

bool function isArousedEnabled()
	bool enabled =  !PlayerRef.IsDead() && Condiexp_GlobalAroused.GetValueInt() == 1
	enabled = enabled && Condiexp_ModSuspended.GetValueInt() == 0  && Condiexp_CurrentlyBusyImmediate.GetValueInt() == 0
	enabled = enabled && !PlayerRef.IsRunning() 
	enabled = enabled && playing
	return enabled 
endfunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	; keep script running
	Utility.Wait(1)
	;either 0 or aroused level > Condiexp_MinAroused
	aroused()
	resetMFGSmooth(PlayerRef)
	;verbose(akTarget, "Aroused: OnEffectFinish", Condiexp_Verbose.GetValueInt())
	Utility.Wait(2)
	config.currentExpression = ""
	playing = false
	Condiexp_CurrentlyBusy.SetValueInt(0)
EndEvent


