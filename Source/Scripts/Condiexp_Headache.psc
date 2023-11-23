Scriptname Condiexp_Headache extends activemagiceffect  
import CondiExp_log
import CondiExp_util

GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
GlobalVariable Property Condiexp_Verbose Auto

Actor Property PlayerRef Auto
condiexp_MCM Property config auto

;Condiexp_CurrentlyBusyImmediate is a CK guard for pain/fatigue/mana expr
Event OnEffectStart(Actor akTarget, Actor akCaster)
    Condiexp_CurrentlyBusyImmediate.SetValueInt(1)
    Condiexp_CurrentlyBusy.SetValueInt(1)
    SendSLAModEvent(20, 60, "not feeling very aroused because of headache", PlayerRef, "CondiExpHeadache")
EndEvent


Function Headache()
    verbose(PlayerRef, "Headache", Condiexp_Verbose.GetValueInt())
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
    config.currentExpression = "Headache"
    Headache()
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
    PlayerRef.ClearExpressionOverride()
    config.currentExpression = ""
    Condiexp_CurrentlyBusyImmediate.SetValueInt(0)
    Condiexp_CurrentlyBusy.SetValueInt(0)
EndEvent