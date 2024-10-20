Scriptname CondiExp_PainScript extends ActiveMagicEffect  
import CondiExp_util
import CondiExp_log
import CondiExp_Expression_Util

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
condiexp_MCM Property config auto
CondiExp_BaseExpression Property painExpr Auto

;Condiexp_CurrentlyBusyImmediate is a CK guard for pain/fatigue/mana.. expr
Event OnEffectStart(Actor akTarget, Actor akCaster)
    Condiexp_CurrentlyBusyImmediate.SetValueInt(1)
    Condiexp_CurrentlyBusy.SetValueInt(1)
    SendSLAModEvent(config.Go.arousalPainThreshold, config.Go.arousalPain, "not feeling aroused because of very strong pain", PlayerRef, "CondiExpPain")
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    config.currentExpression = painExpr.Name
    PlayPainExpression(PlayerRef, painExpr)
    Utility.Wait(3)
    resetMFGSmooth(PlayerRef)
    config.currentExpression = ""
    Condiexp_CurrentlyBusyImmediate.SetValueInt(0)
    Condiexp_CurrentlyBusy.SetValueInt(0)
EndEvent