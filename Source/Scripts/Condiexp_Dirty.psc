Scriptname Condiexp_Dirty extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util
import CondiExp_Expression_Util
Import mfgconsolefunc

GlobalVariable Property Condiexp_GlobalDirty Auto
GlobalVariable Property Condiexp_ModSuspended Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyDirty Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_Verbose Auto
condiexp_MCM Property config auto

bool playing = false

;dirty is not strong emotion and can be overridden by pain etc
Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValueInt(1)
	playing = true
	;verbose(PlayerRef, "Dirty: OnEffectStart", Condiexp_Verbose.GetValueInt())
EndEvent

bool function isDirtyEnabled()
	bool enabled =  !PlayerRef.IsDead() && Condiexp_GlobalDirty.GetValueInt() == 1
	enabled = enabled && Condiexp_ModSuspended.GetValueInt() == 0  && Condiexp_CurrentlyBusyImmediate.GetValueInt() == 0
	enabled = enabled && !PlayerRef.IsRunning() 
	enabled = enabled && playing
	return enabled 
endfunction

Function dirty()
	If isDirtyEnabled()
        config.currentExpression = "Dirty"
		PlayDirtyExpression(PlayerRef,  Condiexp_CurrentlyDirty.GetValueInt() as Int, config)
    else
		log("CondiExp_Dirty: cancelled effect")
	endif
	
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Utility.Wait(1)
	dirty()
	Utility.Wait(RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 4, 6))
	resetMFGSmooth(PlayerRef)
	;verbose(PlayerRef, "Dirty: OnEffectFinish", Condiexp_Verbose.GetValueInt())
	Utility.Wait(2)
	config.currentExpression = ""
	playing = false
	Condiexp_CurrentlyBusy.SetValueInt(0)
EndEvent