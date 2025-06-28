Scriptname Condiexp_Headache extends activemagiceffect  
import CondiExp_log
import CondiExp_util
import CondiExp_Expression_Util

GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
GlobalVariable Property Condiexp_Verbose Auto

Actor Property PlayerRef Auto
condiexp_MCM Property config auto

;Condiexp_CurrentlyBusyImmediate is a CK guard for pain/fatigue/mana expr
Event OnEffectStart(Actor akTarget, Actor akCaster)
    Condiexp_CurrentlyBusyImmediate.SetValueInt(1)
    Condiexp_CurrentlyBusy.SetValueInt(1)
    SendSLAModEvent(config.Go.arousalHeadacheThreshold, config.Go.arousalHeadache, "not feeling very aroused because of headache", PlayerRef, "CondiExpHeadache")
EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)
    config.currentExpression = "Headache"
    verbose(PlayerRef, "Headache", Condiexp_Verbose.GetValueInt())
    Headache(PlayerRef)
    config.currentExpression = ""
    Condiexp_CurrentlyBusyImmediate.SetValueInt(0)
    Condiexp_CurrentlyBusy.SetValueInt(0)
EndEvent