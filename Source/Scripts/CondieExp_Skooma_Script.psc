Scriptname CondieExp_Skooma_Script extends activemagiceffect  
Actor Property PlayerRef Auto
GlobalVariable Property CondiExp_PlayerIsHigh Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
condiexp_MCM Property config auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
High()
EndEvent

Function High()
    int randomhappy
    int randomsmile 
    config.currentExpression = "Scooma"
    randomhappy = Utility.RandomInt(30,70)
    randomsmile = Utility.RandomInt(10,50)
    Condiexp_CurrentlyBusy.SetValueInt(1)
    MfgConsoleFunc.SetModifier(PlayerRef,11,55)
    MfgConsoleFunc.SetPhoneme(PlayerRef,4,randomsmile)
    PlayerRef.SetExpressionOverride(2,randomhappy)

    RegisterForSingleUpdateGameTime(0.5)
EndFunction

Event OnUpdateGameTime()
    CondiExp_PlayerIsHigh.SetValueInt(0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
MfgConsoleFunc.SetModifier(PlayerRef,11,0)
MfgConsoleFunc.SetPhoneme(PlayerRef,4,0)
PlayerRef.ClearExpressionOverride()
Condiexp_CurrentlyBusy.SetValueInt(0)
EndEvent