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
	config.currentExpression = "Dirty"
	;verbose(PlayerRef, "Dirty: OnEffectStart", Condiexp_Verbose.GetValueInt())
EndEvent

bool function isDirtyEnabled()
	bool enabled =  !PlayerRef.IsDead() && Condiexp_GlobalDirty.GetValueInt() == 1
	enabled = enabled && Condiexp_ModSuspended.GetValueInt() == 0  && Condiexp_CurrentlyBusyImmediate.GetValueInt() == 0
	enabled = enabled && !PlayerRef.IsRunning() 
	enabled = enabled && playing && !isInDialogueMFG(PlayerRef)
	return enabled 
endfunction

bool Function isHardStop()
	bool isImmediateEffect = Condiexp_CurrentlyBusyImmediate.GetValueInt() != 0
    bool isSuspended = Condiexp_ModSuspended.GetValueInt() != 0
    
	If isImmediateEffect || isInDialogueMFG(PlayerRef) || isSuspended
		log("Condiexp_Dirty: hard stop")
		return true
	endif
    return false
endfunction

Function dirty()
	If isDirtyEnabled()
		Int dirty = Condiexp_CurrentlyDirty.GetValueInt()
		verbose(PlayerRef, "Dirty", Condiexp_Verbose.GetValueInt())
		PlayDirtyExpression(PlayerRef, dirty, dirtyExpr)
		If (!isHardStop())
			Utility.Wait(RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 4, 6))
			resetMFGSmooth(PlayerRef)
		else
			resetMFGSmooth(PlayerRef)
		EndIf
    else
		log("CondiExp_Dirty: cancelled effect")
	endif
	
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	trace_line("CondiExp_Dirty: OnEffectFinish - starting", Condiexp_Verbose.GetValueInt())
	dirty()
	;verbose(PlayerRef, "Dirty: OnEffectFinish", Condiexp_Verbose.GetValueInt())
	config.currentExpression = ""
	playing = false
	Condiexp_CurrentlyBusy.SetValueInt(0)
EndEvent