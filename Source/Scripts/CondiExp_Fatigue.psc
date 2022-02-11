Scriptname CondiExp_Fatigue extends activemagiceffect  
import CondiExp_util
import CondiExp_Expression_Util

GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_Sounds Auto
Actor Property PlayerRef Auto
sound property CondiExp_BreathingMale auto
sound property CondiExp_BreathingMaleORC auto
sound property CondiExp_BreathingMaleKhajiit auto
sound property CondiExp_BreathingFemale auto
sound property CondiExp_BreathingfemaleORC auto
sound property CondiExp_BreathingfemaleKhajiit auto
bool property Breathing Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
Condiexp_CurrentlyBusy.SetValue(1)
If Breathing == False
Breathe()
Breathing = True
Endif
EndEvent


Function Breathe()
If PlayerRef.IsDead()
;nothing happens
else


;;;;;;;;;;; SOUNDS ;;;;;;;;;;;;
If Condiexp_Sounds.GetValue() == 1
int Breathe = CondiExp_BreathingMaleKhajiit.play(PlayerRef)     

elseif Condiexp_Sounds.GetValue() == 2
int Breathe = CondiExp_BreathingMaleOrc.play(PlayerRef)   

elseif Condiexp_Sounds.GetValue() == 3
int Breathe = CondiExp_BreathingMale.play(PlayerRef)     

elseif Condiexp_Sounds.GetValue() == 4
int Breathe = CondiExp_BreathingfemaleKhajiit.play(PlayerRef)     

elseif Condiexp_Sounds.GetValue() == 5
int Breathe = CondiExp_BreathingfemaleORC.play(PlayerRef)     

elseif Condiexp_Sounds.GetValue() == 6
int Breathe = CondiExp_BreathingfeMale.play(PlayerRef)     
endif 
;;;;;;;;;

Inhale(33,73, PlayerRef)
Exhale(73,33, PlayerRef)

If PlayerRef.GetActorValuePercentage("Stamina") < 0.5 && PlayerRef.GetActorValuePercentage("Health") > 0.5
Breathe()
else
Exhale(33,0,PlayerRef)
Utility.Wait(1)
Endif
Endif
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
Utility.Wait(1)
Condiexp_CurrentlyBusy.SetValue(0)
Breathing = False

EndEvent