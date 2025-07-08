Scriptname CondiExp_Sneaking_Script extends ActiveMagicEffect  
import  CondiExp_log
import CondiExp_util
import CondiExp_Expression_Util
Actor Property PlayerRef Auto
condiexp_MCM Property config auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Condiexp_CurrentlyBusyImmediate.SetValueInt(1)
    Condiexp_CurrentlyBusy.SetValueInt(1)
    config.currentExpression = "Sneaking"
EndEvent

Function KhajiitLikestoSneak(Actor akTarget)
    CondiExp_util.SetModifier(PlayerRef,12,45)
    CondiExp_util.SetModifier(PlayerRef,13,45)
    CondiExp_util.SetModifier(PlayerRef,2,20)

    Int Order =  RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 1,12)
    If Order < 3
         LookLeft(70, akTarget)
        LookRight(70, akTarget)
    Elseif Order == 3
         LookLeft(70, akTarget)
    Elseif Order == 4
        LookRight(70, akTarget)
    Elseif Order == 5
        LookRight(70, akTarget)
        LookLeft(70, akTarget)
    Endif
EndFunction


Event OnEffectFinish(Actor akTarget, Actor akCaster)
    verbose(PlayerRef, "Sneaking", config.Condiexp_Verbose.GetValueInt())
    KhajiitLikestoSneak(PlayerRef)
    CondiExp_util.SetModifier(PlayerRef,12,0)
    CondiExp_util.SetModifier(PlayerRef,13,0)
    CondiExp_util.SetModifier(PlayerRef,2,0)
    config.currentExpression = ""
    Condiexp_CurrentlyBusyImmediate.SetValueInt(0)
    Condiexp_CurrentlyBusy.SetValueInt(0)
EndEvent
