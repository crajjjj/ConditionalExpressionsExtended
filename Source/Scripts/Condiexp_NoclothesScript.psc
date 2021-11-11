Scriptname Condiexp_NoclothesScript extends activemagiceffect  
Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
Blush()
EndEvent

Function Blush()
PlayerRef.SetExpressionOverride(4,90)
Condiexp_CurrentlyBusy.SetValue(1)
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
PlayerRef.ClearExpressionOverride()
Condiexp_CurrentlyBusy.SetValue(0)
EndEvent