Scriptname Condiexp_Dirty extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util
import CondiExp_Expression_Util
Import mfgconsolefunc

GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyDirty Auto
Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_Verbose Auto
condiexp_MCM Property config auto

bool playing = false

;dirty is not strong emotion and can be overridden by pain etc
Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValueInt(1)
	verbose(PlayerRef, "Dirty: OnEffectStart", Condiexp_Verbose.GetValueInt())
	config.currentExpression = "Dirty"
EndEvent

Function dirty()
    If PlayerRef.IsDead()
        return
    endif
	PlayDirtyExpression(PlayerRef,  Condiexp_CurrentlyDirty.GetValueInt() as Int, config)
	Utility.Wait(Utility.RandomInt(4, 6))
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	dirty()
	resetMFGSmooth(PlayerRef)
	verbose(PlayerRef, "Dirty: OnEffectFinish", Condiexp_Verbose.GetValueInt())
	Utility.Wait(2)
	Condiexp_CurrentlyBusy.SetValueInt(0)
EndEvent