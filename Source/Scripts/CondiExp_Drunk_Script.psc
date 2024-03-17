Scriptname CondiExp_Drunk_Script extends activemagiceffect  
import CondiExp_log
import CondiExp_util
import CondiExp_Expression_Util

Actor Property PlayerRef Auto
GlobalVariable Property CondiExp_PlayerIsDrunk Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
condiexp_MCM Property config auto
;Condiexp_CurrentlyBusyImmediate is a CK guard for pain/fatigue/mana... expr
Event OnEffectStart(Actor akTarget, Actor akCaster)
    int lock = Condiexp_CurrentlyBusyImmediate.GetValueInt() as int
    lock = lock + 1
    Condiexp_CurrentlyBusyImmediate.SetValueInt(lock)
    Condiexp_CurrentlyBusy.SetValueInt(1)
    config.currentExpression = "Drunk"
    if lock == 1
        Drunk()
    endif
    trace(PlayerRef, "Drunk: OnEffectStart.Lock:" + lock, config.Condiexp_Verbose.GetValueInt())
EndEvent

Function Drunk()
    Condiexp_CurrentlyBusy.SetValueInt(1)
    verbose(PlayerRef, "Drunk", config.Condiexp_Verbose.GetValueInt())
    CondiExp_util.SmoothSetExpression(PlayerRef,2,80)
    RegisterForSingleUpdate(10.0)
EndFunction

Event OnUpdate()
    trace(PlayerRef, "Drunk: OnUpdate", config.Condiexp_Verbose.GetValueInt())
    CondiExp_PlayerIsDrunk.SetValueInt(0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    trace(PlayerRef, "Drunk: OnEffectFinish ", config.Condiexp_Verbose.GetValueInt())
    config.currentExpression = ""
    resetMFGSmooth(PlayerRef)
    Condiexp_CurrentlyBusy.SetValueInt(0)
    Condiexp_CurrentlyBusyImmediate.SetValueInt(0)
EndEvent