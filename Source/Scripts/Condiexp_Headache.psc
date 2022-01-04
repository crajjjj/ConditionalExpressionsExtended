Scriptname Condiexp_Headache extends activemagiceffect  
GlobalVariable Property Condiexp_CurrentlyBusy Auto
Actor Property PlayerRef Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)

Condiexp_CurrentlyBusy.SetValue(1)
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
Condiexp_CurrentlyBusy.SetValue(0)
PlayerRef.ClearExpressionOverride()
EndEvent