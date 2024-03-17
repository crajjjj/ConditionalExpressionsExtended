Scriptname CondiExp_Eating_Script extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util
import CondiExp_Expression_Util

GlobalVariable Property CondiExp_PlayerJustAte Auto
GlobalVariable Property Condiexp_GlobalEating Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
Actor Property PlayerRef Auto
bool property Imeatinghere auto ;deprecated
condiexp_MCM Property config auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Condiexp_CurrentlyBusy.SetValueInt(1)
    Condiexp_CurrentlyBusyImmediate.SetValueInt(1)
    config.currentExpression = "Eating"
    verbose(PlayerRef, "Eating", config.Condiexp_Verbose.GetValueInt())
    If Condiexp_GlobalEating.GetValueInt() == 1
        Utility.Wait(3.8)
            elseif Condiexp_GlobalEating.GetValueInt() == 2
             Utility.Wait(0.8)
        endif
    TeethIn()
    YumYum()
    YumYum()
    YumYum()
    YumYum()
    TeethOut()
    Utility.Wait(1)
    CondiExp_PlayerJustAte.SetValueInt(0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    trace(PlayerRef, "Eating: OnEffectFinish ", config.Condiexp_Verbose.GetValueInt())
    config.currentExpression = ""
    resetMFGSmooth(PlayerRef)
    Condiexp_CurrentlyBusy.SetValueInt(0)
    Condiexp_CurrentlyBusyImmediate.SetValueInt(0)
EndEvent

Function YumYum()
int i = 0
while i < 44
    CondiExp_util.SetPhonemeFast(PlayerRef, 0, i)
    i = i + 8
    if (i > 55)
        i = 44
    Endif
    Utility.Wait(0.01)
endwhile

while i > 0
    CondiExp_util.SetPhonemeFast(PlayerRef, 0, i)
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
    CondiExp_util.SetPhonemeFast(PlayerRef, 12, i)
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
    CondiExp_util.SetPhonemeFast(PlayerRef, 12, i)
    i = i - 5
    if (i < 0)
    i = 0
    Endif
    Utility.Wait(0.01)
endwhile
CondiExp_util.SetPhonemeFast(PlayerRef, 12,0)
CondiExp_util.SetPhonemeFast(PlayerRef, 0,0)
endfunction