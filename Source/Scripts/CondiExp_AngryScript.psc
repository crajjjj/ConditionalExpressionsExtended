Scriptname CondiExp_AngryScript extends ActiveMagicEffect  
Actor Property PlayerRef Auto
bool property OpenMouth Auto
keyword property vampire auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
If PlayerRef.HasKeyword(Vampire)
; use vanilla
else
Angry()
endif
EndEvent

Function Angry()
while PlayerRef.IsinCombat() && OpenMouth == False
PlayerRef.SetExpressionOverride(15,70)
MfgConsoleFunc.SetPhoneMe(PlayerRef, 4, 20)
Utility.Wait(1)
EndWhile
EndFunction

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)

int hit_chance
hit_chance=Utility.RandomInt(1,100)

if hit_chance < 40 && abHitBlocked == False && akSource as weapon && OpenMouth == False
OpenMouth = True

PlayerRef.SetExpressionOverride(15,100)

If PlayerRef.HasKeyword(Vampire)
VampireOuch()
else
HumanOuch()
PlayerRef.SetExpressionOverride(15,75)
endif
Utility.Wait(2)
OpenMouth = False
endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
Utility.Wait(0.5)
MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
EndEvent


Function HumanOuch()

int i = 0

while i < 100
MfgConsoleFunc.SetPhoneMe(PlayerRef, 10,i)
i = i + 12
if (i > 100)
i = 100
Endif
Utility.Wait(0.0001)
endwhile

Utility.Wait(0.2)

while i > 0
MfgConsoleFunc.SetPhoneMe(PlayerRef, 10,i)
i = i - 15
if (i < 0)
i = 0
Endif
Utility.Wait(0.0001)
endwhile
EndFunction


Function VampireOuch()

int i = 0

while i < 60
MfgConsoleFunc.SetPhoneMe(PlayerRef, 10,i)
MfgConsoleFunc.SetPhoneMe(PlayerRef, 9,i)
MfgConsoleFunc.SetPhoneMe(PlayerRef, 5,i)
i = i + 12
if (i > 60)
i = 60
Endif
Utility.Wait(0.0001)
endwhile

Utility.Wait(4)

while i > 0
MfgConsoleFunc.SetPhoneMe(PlayerRef, 10,i)
MfgConsoleFunc.SetPhoneMe(PlayerRef, 9,i)
MfgConsoleFunc.SetPhoneMe(PlayerRef, 5,i)
i = i - 15
if (i < 0)
i = 0
Endif
Utility.Wait(0.0001)
endwhile
EndFunction