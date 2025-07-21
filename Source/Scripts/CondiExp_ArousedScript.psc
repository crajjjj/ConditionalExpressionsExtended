Scriptname CondiExp_ArousedScript extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util
import CondiExp_Expression_Util

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
GlobalVariable Property Condiexp_GlobalAroused Auto
GlobalVariable Property Condiexp_CurrentlyAroused Auto
GlobalVariable Property Condiexp_ModSuspended Auto
GlobalVariable Property Condiexp_Sounds Auto
GlobalVariable Property Condiexp_Verbose Auto
CondiExp_BaseExpression Property arousalExpr Auto

condiexp_MCM Property config auto

bool playing = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValueInt(1)
	playing = true
	config.currentExpression = "Aroused"
	;verbose(akTarget, "Aroused: OnEffectStart", Condiexp_Verbose.GetValueInt())
EndEvent

Function aroused()
	If isArousedEnabled()
		Int arousal = Condiexp_CurrentlyAroused.GetValueInt()
		verbose(PlayerRef, "Aroused", config.Condiexp_Verbose.GetValueInt())
		PlayArousedExpression(PlayerRef, arousal, arousalExpr)
		Utility.Wait(2)
		resetPhonemesSmooth(PlayerRef)
		Utility.Wait(RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 2, 6))
		resetMFGSmooth(PlayerRef)
    else
		log("CondiExp_Aroused: cancelled effect")
	endif
EndFunction

bool function isArousedEnabled()
	bool enabled = !PlayerRef.IsDead() && Condiexp_GlobalAroused.GetValueInt() == 1
	enabled = enabled && Condiexp_ModSuspended.GetValueInt() == 0  && Condiexp_CurrentlyBusyImmediate.GetValueInt() == 0
	enabled = enabled && !PlayerRef.IsRunning() 
	enabled = enabled && playing && !isInDialogueMFG(PlayerRef)
	return enabled 
endfunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	;either 0 or aroused level > Condiexp_MinAroused
	aroused()
	;verbose(akTarget, "Aroused: OnEffectFinish", Condiexp_Verbose.GetValueInt())
	Utility.Wait(1)
	config.currentExpression = ""
	playing = false
	Condiexp_CurrentlyBusy.SetValueInt(0)
EndEvent


