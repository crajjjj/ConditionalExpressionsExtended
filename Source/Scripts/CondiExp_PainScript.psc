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
    Condiexp_CurrentlyBusyImmediate.SetValueInt(1)
    Condiexp_CurrentlyBusy.SetValueInt(1)
    resetMFG(PlayerRef)
    Utility.Wait(1)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    config.currentExpression = "Pain"
    PlayPainExpression(PlayerRef, config)
    Utility.Wait(3)
    PlayerRef.ClearExpressionOverride()
    MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
    Condiexp_CurrentlyBusyImmediate.SetValueInt(0)
    Condiexp_CurrentlyBusy.SetValueInt(0)
EndEvent