Scriptname CondiExp_AngryScript extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_Expression_Util

Actor Property PlayerRef Auto
bool property OpenMouth Auto
keyword property vampire auto
condiexp_MCM Property config auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
;Condiexp_CurrentlyBusyImmediate is a CK guard for pain/fatigue/mana... expr
Event OnEffectStart(Actor akTarget, Actor akCaster)
    Condiexp_CurrentlyBusyImmediate.SetValue(1)
    Condiexp_CurrentlyBusy.SetValue(1)
EndEvent

Function Angry()
    while PlayerRef.IsinCombat() && OpenMouth == False && config.Go.Condiexp_ModSuspended.getValue() == 0
        config.currentExpression = "Angry"
        verbose(PlayerRef, "Angry", config.Condiexp_Verbose.GetValue() as Int)
        PlayerRef.SetExpressionOverride(15,70)
        MfgConsoleFunc.SetPhoneMe(PlayerRef, 4, 20)
        Utility.Wait(1)
    EndWhile
EndFunction

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
    if (OpenMouth == False  && abHitBlocked == False && akSource as weapon && (Utility.RandomInt(1,100) < 40))
		OpenMouth = True
        PlayerRef.SetExpressionOverride(15,100)
        If PlayerRef.HasKeyword(Vampire)
             VampireOuch(PlayerRef)
        else
             HumanOuch(PlayerRef)
             PlayerRef.SetExpressionOverride(15,75)
        endif
        Utility.Wait(2)
        OpenMouth = False
	endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    If PlayerRef.HasKeyword(Vampire)
        ; use vanilla
    else
        Angry()
    endif
    Utility.Wait(0.5)
    MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
    Condiexp_CurrentlyBusyImmediate.SetValue(0)
    Condiexp_CurrentlyBusy.SetValue(0)
EndEvent