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
    Condiexp_CurrentlyBusyImmediate.SetValueInt(1)
    config.currentExpression = "Scooma"
    trace(PlayerRef, "Skooma: OnEffectStart." , config.Condiexp_Verbose.GetValueInt())
EndEvent

Function High()
    trace(PlayerRef, "Skooma: OnEffectStart", config.Condiexp_Verbose.GetValueInt())
    verbose(PlayerRef, "Scooma", config.Condiexp_Verbose.GetValueInt())
    PlayScoomaExpression(PlayerRef)
    PlayScoomaExpression(PlayerRef)
    trace(PlayerRef, "Skooma: Ending", config.Condiexp_Verbose.GetValueInt())
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    trace(PlayerRef, "Skooma: OnEffectFinish - starting", config.Condiexp_Verbose.GetValueInt())
    High()
    config.currentExpression = ""
    CondiExp_PlayerIsHigh.SetValueInt(0)
    Condiexp_CurrentlyBusy.SetValueInt(0)
    Condiexp_CurrentlyBusyImmediate.SetValueInt(0)
EndEvent