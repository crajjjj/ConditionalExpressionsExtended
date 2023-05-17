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
    Condiexp_CurrentlyBusyImmediate.SetValueInt(1)
    Condiexp_CurrentlyBusy.SetValueInt(1)
EndEvent

Function Drunk()
    Condiexp_CurrentlyBusy.SetValueInt(1)
    verbose(PlayerRef, "Drunk", config.Condiexp_Verbose.GetValueInt())
    PlayerRef.SetExpressionOverride(2,80)
EndFunction


Event OnEffectFinish(Actor akTarget, Actor akCaster)
    config.currentExpression = "Drunk"
    Utility.Wait(1)
    Drunk()
    Utility.Wait(5)
    CondiExp_PlayerIsDrunk.SetValueInt(0)
    PlayerRef.ClearExpressionOverride()
    Condiexp_CurrentlyBusy.SetValueInt(0)
    Condiexp_CurrentlyBusyImmediate.SetValueInt(0)
    config.currentExpression = ""
EndEvent