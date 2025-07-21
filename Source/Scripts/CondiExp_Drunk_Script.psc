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
    Condiexp_CurrentlyBusy.SetValueInt(1)
    Condiexp_CurrentlyBusyImmediate.SetValueInt(1)
    config.currentExpression = "Drunk"
    trace(PlayerRef, "Drunk: OnEffectStart.", config.Condiexp_Verbose.GetValueInt())
EndEvent

Function Drunk()
    Condiexp_CurrentlyBusy.SetValueInt(1)
    verbose(PlayerRef, "Drunk", config.Condiexp_Verbose.GetValueInt())
    PlayDrunkExpression(PlayerRef)
    PlayDrunkExpression(PlayerRef)
    trace(PlayerRef, "Drunk: Ending", config.Condiexp_Verbose.GetValueInt())
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    trace(PlayerRef, "Drunk: OnEffectFinish - starting", config.Condiexp_Verbose.GetValueInt())
    Drunk()
    config.currentExpression = ""
    CondiExp_PlayerIsDrunk.SetValueInt(0)
    Condiexp_CurrentlyBusy.SetValueInt(0)
    Condiexp_CurrentlyBusyImmediate.SetValueInt(0)
EndEvent