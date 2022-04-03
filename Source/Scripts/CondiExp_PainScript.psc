Scriptname CondiExp_PainScript extends ActiveMagicEffect  
import CondiExp_util
import CondiExp_log
import CondiExp_Expression_Util

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
condiexp_MCM Property config auto

;Condiexp_CurrentlyBusyImmediate is a CK guard for pain/fatigue/mana.. expr
Event OnEffectStart(Actor akTarget, Actor akCaster)
    Condiexp_CurrentlyBusyImmediate.SetValue(1)
    Condiexp_CurrentlyBusy.SetValue(1)
    config.currentExpression = "Pain"
    PlayerRef.ClearExpressionOverride()
    MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
    Utility.Wait(0.9)
    PlayPainExpression(PlayerRef, config)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    Utility.Wait(1)
    PlayerRef.ClearExpressionOverride()
    MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
    Condiexp_CurrentlyBusyImmediate.SetValue(0)
    Condiexp_CurrentlyBusy.SetValue(0)
EndEvent