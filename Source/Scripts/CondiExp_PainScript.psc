Scriptname CondiExp_PainScript extends ActiveMagicEffect  
import CondiExp_util
import CondiExp_log
import CondiExp_Expression_Util

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
    Condiexp_CurrentlyBusy.SetValue(1)
    PlayerRef.ClearExpressionOverride()
    MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
    Utility.Wait(0.9)
    PlayPainExpression(PlayerRef, 0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    Utility.Wait(1)
    Condiexp_CurrentlyBusy.SetValue(0)
    PlayerRef.ClearExpressionOverride()
    MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
EndEvent