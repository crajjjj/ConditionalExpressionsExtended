Scriptname Condiexp_Headache extends activemagiceffect  
import CondiExp_log

GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto

Actor Property PlayerRef Auto
condiexp_MCM Property config auto

;Condiexp_CurrentlyBusyImmediate is a CK guard for pain/fatigue/mana expr
Event OnEffectStart(Actor akTarget, Actor akCaster)
    Condiexp_CurrentlyBusyImmediate.SetValue(1)
    Condiexp_CurrentlyBusy.SetValue(1)
    config.currentExpression = "Headache"
    verbose(PlayerRef, "Headache", config.Condiexp_Verbose.GetValue() as Int)
    Headache()
EndEvent


Function Headache()
    int i = 0
    while i < 95
        PlayerRef.SetExpressionOverride(3,i)
         i = i + 5
         if (i > 95)
            i = 95
         Endif
         Utility.Wait(0.1)
    endwhile
endfunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    int i = 95
    while i > 0
     PlayerRef.SetExpressionOverride(3,i)
     i = i - 5
        if (i < 0)
            i = 0
        Endif
     Utility.Wait(0.1)
    endwhile
    Utility.Wait(1)
    Condiexp_CurrentlyBusyImmediate.SetValue(0)
    Condiexp_CurrentlyBusy.SetValue(0)
    PlayerRef.ClearExpressionOverride()
EndEvent