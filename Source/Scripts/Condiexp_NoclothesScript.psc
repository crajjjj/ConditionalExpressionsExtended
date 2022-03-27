Scriptname Condiexp_NoclothesScript extends activemagiceffect  
Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
condiexp_MCM Property config auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Blush()
EndEvent

Function Blush()
    Condiexp_CurrentlyBusy.SetValue(1)
    config.currentExpression = "No Clothes"
    PlayerRef.SetExpressionOverride(4,90)
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    Utility.Wait(1)
    PlayerRef.ClearExpressionOverride()
    Condiexp_CurrentlyBusy.SetValue(0)
EndEvent