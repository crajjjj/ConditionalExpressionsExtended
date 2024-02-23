Scriptname CondiExp_Eating_Script extends ActiveMagicEffect  


GlobalVariable Property CondiExp_PlayerJustAte Auto
GlobalVariable Property Condiexp_GlobalEating Auto
Actor Property PlayerRef Auto
bool property Imeatinghere auto
condiexp_MCM Property config auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
config.currentExpression = "Eating"
If Condiexp_GlobalEating.GetValueInt() == 1
Utility.Wait(3.8)
elseif Condiexp_GlobalEating.GetValueInt() == 2
Utility.Wait(0.8)
endif

If ImEatinghere == True
else
ImEatingHere = True
TeethIn()
YumYum()
YumYum()
YumYum()
YumYum()
TeethOut()
CondiExp_PlayerJustAte.SetValueInt(0)
ImEatingHere = False
endif
config.currentExpression = ""
EndEvent

Function YumYum()

int i = 0

while i < 44
CondiExp_util.SetPhoneMe(PlayerRef, 0,i)
i = i + 8
if (i > 55)
i = 44
Endif
Utility.Wait(0.01)
endwhile

while i > 0
CondiExp_util.SetPhoneMe(PlayerRef, 0,i)
i = i - 8
if (i < 0)
i = 0
Endif
Utility.Wait(0.01)
endwhile
endfunction


Function TeethIn()

int i = 0

while i < 25
CondiExp_util.SetPhoneMe(PlayerRef, 12,i)
i = i + 5
if (i >25)
i = 25
Endif
Utility.Wait(0.01)
endwhile
endfunction


Function TeethOut()
int i = 25
while i > 0
CondiExp_util.SetPhoneMe(PlayerRef, 12,i)
i = i - 5
if (i < 0)
i = 0
Endif
Utility.Wait(0.01)
endwhile
CondiExp_util.SetPhoneMe(PlayerRef, 12,0)
CondiExp_util.SetPhoneMe(PlayerRef, 0,0)
endfunction