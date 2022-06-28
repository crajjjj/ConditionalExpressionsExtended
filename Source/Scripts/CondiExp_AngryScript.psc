Scriptname CondiExp_AngryScript extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util
import CondiExp_Expression_Util

Actor Property PlayerRef Auto
bool property OpenMouth Auto
keyword property vampire auto
condiexp_MCM Property config auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
GlobalVariable Property Condiexp_ModSuspended Auto
GlobalVariable Property Condiexp_Verbose Auto
GlobalVariable Property Condiexp_PO3ExtenderInstalled Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
  If PlayerRef.HasKeyword(Vampire)
   ; use vanilla
  else
    Angry()
  endif
 
EndEvent

Function Angry()
    config.currentExpression = "Angry"
    RegisterForSingleUpdate(1)
EndFunction

Event OnUpdate()
    if OpenMouth == False && PlayerRef.IsinCombat() && Condiexp_ModSuspended.getValue() == 0
      verbose(PlayerRef, "Angry", Condiexp_Verbose.GetValue() as Int)
      PlayerRef.SetExpressionOverride(15,70)
      MfgConsoleFunc.SetPhoneMe(PlayerRef, 4, 20)
      RegisterForSingleUpdate(1)
    EndIf
EndEvent

auto State NotReacting
  Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
    GoToState("Reacting")
    if abHitBlocked == False && akSource as weapon && OpenMouth == False && RandomNumber( Condiexp_PO3ExtenderInstalled.GetValueInt() == 1, 1, 100) < 40
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
    GoToState("NotReacting")
  EndEvent

EndState

State Reacting
  Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
    ; Do nothing
  EndEvent
EndState



Event OnEffectFinish(Actor akTarget, Actor akCaster)
  Utility.Wait(0.5)
  MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
EndEvent