Scriptname CondiExp_Fatigue extends activemagiceffect  
import CondiExp_util
import CondiExp_log
import CondiExp_Expression_Util

GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto

GlobalVariable Property Condiexp_Sounds Auto
Actor Property PlayerRef Auto
sound property CondiExp_BreathingMale auto
sound property CondiExp_BreathingMaleORC auto
sound property CondiExp_BreathingMaleKhajiit auto
sound property CondiExp_BreathingFemale auto
sound property CondiExp_BreathingfemaleORC auto
sound property CondiExp_BreathingfemaleKhajiit auto
bool property Breathing Auto
condiexp_MCM Property config auto
GlobalVariable Property Condiexp_Verbose Auto


;Condiexp_CurrentlyBusyImmediate is a CK guard for pain/fatigue/mana... expr
Event OnEffectStart(Actor akTarget, Actor akCaster)
    int lock = Condiexp_CurrentlyBusyImmediate.GetValueInt() as int
    Condiexp_CurrentlyBusyImmediate.SetValueInt(lock + 1)
    Condiexp_CurrentlyBusy.SetValueInt(1)
    resetMFGSmooth(akTarget)
    trace(PlayerRef, "Fatigue: OnEffectStart.Lock:" + lock, Condiexp_Verbose.GetValueInt())
EndEvent

bool function isFatigueActive()
    bool active = config.Condiexp_GlobalStamina.GetValue() == 1
    active = active && PlayerRef.GetActorValuePercentage("Stamina") < 0.5 && PlayerRef.GetActorValuePercentage("Health") > 0.5
    active = active && !PlayerRef.IsDead() && !PlayerRef.isSwimming() 
	return  active && Condiexp_CurrentlyBusyImmediate.GetValue() == 1
endfunction

Function Breathe()
    If PlayerRef.IsDead()
        return
    endif

    Inhale(33,73, PlayerRef)
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
    Exhale(73,33, PlayerRef)

EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    config.currentExpression = "Fatigue"
    int safeguard = 0
    While (isFatigueActive()  && safeguard <= 10)
        Breathe()
        Utility.Wait(1)
        safeguard = safeguard + 1
    EndWhile
    Exhale(33, 0, PlayerRef)
    config.currentExpression = ""
    Condiexp_CurrentlyBusyImmediate.SetValueInt(0)
    Condiexp_CurrentlyBusy.SetValueInt(0)
    trace(PlayerRef, "Fatigue: OnEffectFinish. Times:" + safeguard, Condiexp_Verbose.GetValueInt())
EndEvent