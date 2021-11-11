Scriptname CondiExp_PainScript extends ActiveMagicEffect  
Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
Condiexp_CurrentlyBusy.SetValue(1)
PlayerRef.ClearExpressionOverride()
MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
Utility.Wait(0.9)

Int Order = Utility.RandomInt(1, 4)
If Order == 1
Pain1()
elseif Order == 2
Pain2()
elseif Order == 3
Pain3()
elseif Order == 4
Pain4()
Endif
EndEvent

Function Pain1()
PlayerRef.SetExpressionOverride(9,60)
MfgConsoleFunc.SetModifier(PlayerRef,2,52)
MfgConsoleFunc.SetModifier(PlayerRef,3,52)
MfgConsoleFunc.SetPhoneMe(PlayerRef,5,30)
EndFunction

Function Pain2()
MfgConsoleFunc.SetModifier(PlayerRef,4,115)
MfgConsoleFunc.SetModifier(PlayerRef,5,115)
MfgConsoleFunc.SetPhoneMe(PlayerRef,4,30)
PlayerRef.SetExpressionOverride(3,50)
EndFunction

Function Pain3()
MfgConsoleFunc.SetModifier(PlayerRef,4,115)
MfgConsoleFunc.SetModifier(PlayerRef,5,115)
MfgConsoleFunc.SetModifier(PlayerRef,0,70)
MfgConsoleFunc.SetPhoneMe(PlayerRef,4,30)
EndFunction

Function Pain4()
MfgConsoleFunc.SetModifier(PlayerRef,4,115)
MfgConsoleFunc.SetModifier(PlayerRef,5,115)
MfgConsoleFunc.SetModifier(PlayerRef,1,70)
MfgConsoleFunc.SetPhoneMe(PlayerRef,4,30)
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
Condiexp_CurrentlyBusy.SetValue(0)
PlayerRef.ClearExpressionOverride()
MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
EndEvent