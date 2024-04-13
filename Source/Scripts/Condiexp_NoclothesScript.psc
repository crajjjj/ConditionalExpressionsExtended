Scriptname Condiexp_NoclothesScript extends activemagiceffect  
import CondiExp_log
import CondiExp_Expression_Util
import CondiExp_util

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
condiexp_MCM Property config auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
GlobalVariable Property Condiexp_Verbose Auto
;Condiexp_CurrentlyBusyImmediate is a CK guard for pain/fatigue/mana... expr
Event OnEffectStart(Actor akTarget, Actor akCaster)
    Condiexp_CurrentlyBusyImmediate.SetValueInt(1)
    Condiexp_CurrentlyBusy.SetValueInt(1)
    Utility.Wait(1)
EndEvent

Function Blush()
    Int randomLook = Utility.RandomInt(1, 10)
    verbose(PlayerRef, "No Clothes" + randomLook, Condiexp_Verbose.GetValueInt())

    if randomLook >= 5
        Surprised(90,PlayerRef, 10)
    Else
        Fear(95,PlayerRef, 10)
    endif

    If randomLook == 2
		LookLeft(50, PlayerRef)
	ElseIf randomLook == 4
		LookRight(50, PlayerRef)
	ElseIf randomLook == 8
		LookDown(50, PlayerRef)
	endif

EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    config.currentExpression = "No Clothes"
    Blush()
  ;  verbose(PlayerRef, "No Clothes: OnEffectFinish.  " , Condiexp_Verbose.GetValueInt() )
    resetMFGSmooth(PlayerRef)
    Condiexp_CurrentlyBusyImmediate.SetValueInt(0)
    Condiexp_CurrentlyBusy.SetValueInt(0)
    config.currentExpression = ""
EndEvent