Scriptname CondiExp_WaterScript extends activemagiceffect  
Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
Condiexp_CurrentlyBusy.SetValue(1)
Squint()
EndEvent

Function Squint()


int i = 0

while i < 75
MfgConsoleFunc.SetModifier(PlayerRef,12,i)
MfgConsoleFunc.SetModifier(PlayerRef,13,i)
i = i + 8
if (i > 75)
i = 75
Endif
Utility.Wait(0.01)
endwhile

EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)

int i = 75

while i > 0
MfgConsoleFunc.SetModifier(PlayerRef,12,i)
MfgConsoleFunc.SetModifier(PlayerRef,13,i)
i = i - 15
if (i < 0)
i = 0
Endif
Utility.Wait(0.0001)
endwhile

MfgConsoleFunc.SetModifier(PlayerRef,12,0)
MfgConsoleFunc.SetModifier(PlayerRef,13,0) 
Condiexp_CurrentlyBusy.SetValue(0)

EndEvent