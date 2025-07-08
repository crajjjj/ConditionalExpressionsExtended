Scriptname CondieExp_Skooma_Script extends activemagiceffect  
import CondiExp_util
import CondiExp_log
import CondiExp_Expression_Util
Actor Property PlayerRef Auto
GlobalVariable Property CondiExp_PlayerIsHigh Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
condiexp_MCM Property config auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Condiexp_CurrentlyBusy.SetValueInt(1)
     config.currentExpression = "Scooma"
    int lock = Condiexp_CurrentlyBusyImmediate.GetValueInt() as int
    lock = lock + 1
    if lock == 1
        High()
    endif
    trace(PlayerRef, "Drunk: OnEffectStart.Lock:" + lock, config.Condiexp_Verbose.GetValueInt())
EndEvent

Function High()
    trace(PlayerRef, "Skooma: OnEffectStart", config.Condiexp_Verbose.GetValueInt())
    int randomhappy
    int randomsmile
   
    verbose(PlayerRef, "Scooma", config.Condiexp_Verbose.GetValueInt())
    PlayScoomaExpression(PlayerRef)
    PlayScoomaExpression(PlayerRef)
    CondiExp_PlayerIsHigh.SetValueInt(0)
EndFunction

Event OnUpdate()
    trace(PlayerRef, "Skooma: OnUpdate", config.Condiexp_Verbose.GetValueInt())
    CondiExp_PlayerIsHigh.SetValueInt(0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    trace(PlayerRef, "Skooma: OnEffectFinish", config.Condiexp_Verbose.GetValueInt())
    Condiexp_CurrentlyBusy.SetValueInt(0)
    Condiexp_CurrentlyBusyImmediate.SetValueInt(0)
EndEvent