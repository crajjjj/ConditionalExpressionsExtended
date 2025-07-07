Scriptname Condiexp_Dirty extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util
import CondiExp_Expression_Util

GlobalVariable Property Condiexp_GlobalDirty Auto
GlobalVariable Property Condiexp_ModSuspended Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyDirty Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_Verbose Auto
condiexp_MCM Property config auto
CondiExp_BaseExpression Property dirtyExpr Auto
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
	enabled = enabled && playing && !isInDialogueMFG(PlayerRef)
	return enabled 
endfunction

Function dirty()
	If isDirtyEnabled()
        config.currentExpression = dirtyExpr.Name
		Int dirty = Condiexp_CurrentlyDirty.GetValueInt() as Int
		PlayDirtyExpression(PlayerRef, dirty, dirtyExpr)
		Utility.Wait(RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 4, 6))
		resetMFGSmooth(PlayerRef)
    else
		log("CondiExp_Dirty: cancelled effect")
	endif
	
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Utility.Wait(1)
	dirty()
	;verbose(PlayerRef, "Dirty: OnEffectFinish", Condiexp_Verbose.GetValueInt())
	config.currentExpression = ""
	playing = false
	Condiexp_CurrentlyBusy.SetValueInt(0)
EndEvent