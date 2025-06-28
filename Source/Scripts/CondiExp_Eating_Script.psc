Scriptname CondiExp_Eating_Script extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util
import CondiExp_Expression_Util

GlobalVariable Property CondiExp_PlayerJustAte Auto
GlobalVariable Property Condiexp_GlobalEating Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
Actor Property PlayerRef Auto
bool property Imeatinghere auto ;deprecated
condiexp_MCM Property config auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Condiexp_CurrentlyBusy.SetValueInt(1)
    Condiexp_CurrentlyBusyImmediate.SetValueInt(1)
    config.currentExpression = "Eating"
    verbose(PlayerRef, "Eating", config.Condiexp_Verbose.GetValueInt())
    If Condiexp_GlobalEating.GetValueInt() == 1
        Utility.Wait(3.8)
    elseif Condiexp_GlobalEating.GetValueInt() == 2
        Utility.Wait(0.8)
    endif
    PlayEatingExpression(PlayerRef)
    Utility.Wait(1)
    CondiExp_PlayerJustAte.SetValueInt(0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    trace(PlayerRef, "Eating: OnEffectFinish ", config.Condiexp_Verbose.GetValueInt())
    config.currentExpression = ""
    Condiexp_CurrentlyBusy.SetValueInt(0)
    Condiexp_CurrentlyBusyImmediate.SetValueInt(0)
EndEvent

