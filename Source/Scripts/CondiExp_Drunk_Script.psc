Scriptname CondiExp_Drunk_Script extends activemagiceffect  
Actor Property PlayerRef Auto
GlobalVariable Property CondiExp_PlayerIsDrunk Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
Drunk()
EndEvent

Function Drunk()

Condiexp_CurrentlyBusy.SetValue(1)
PlayerRef.SetExpressionOverride(2,80)

RegisterForSingleUpdateGameTime(0.5)
EndFunction

Event OnUpdateGameTime()
CondiExp_PlayerIsDrunk.SetValue(0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
Utility.Wait(1)
PlayerRef.ClearExpressionOverride()
Condiexp_CurrentlyBusy.SetValue(0)
EndEvent