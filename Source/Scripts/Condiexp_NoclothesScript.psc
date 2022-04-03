Scriptname Condiexp_NoclothesScript extends activemagiceffect  
Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
condiexp_MCM Property config auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
;Condiexp_CurrentlyBusyImmediate is a CK guard for pain/fatigue/mana... expr
Event OnEffectStart(Actor akTarget, Actor akCaster)
    Condiexp_CurrentlyBusyImmediate.SetValue(1)
    Condiexp_CurrentlyBusy.SetValue(1)
    Blush()
EndEvent

Function Blush()
    
    config.currentExpression = "No Clothes"
    PlayerRef.SetExpressionOverride(4,90)
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    Utility.Wait(1)
    PlayerRef.ClearExpressionOverride()
    Condiexp_CurrentlyBusyImmediate.SetValue(0)
    Condiexp_CurrentlyBusy.SetValue(0)
EndEvent