Scriptname CondiExp_ArousedScript extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util
import CondiExp_Expression_Util
Import mfgconsolefunc

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_GlobalAroused Auto
GlobalVariable Property Condiexp_CurrentlyAroused Auto
GlobalVariable Property Condiexp_ModSuspended Auto
GlobalVariable Property Condiexp_Sounds Auto
GlobalVariable Property Condiexp_Verbose Auto

condiexp_MCM Property config auto

bool playing = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValueInt(1)
	;verbose(akTarget, "Aroused: OnEffectStart", Condiexp_Verbose.GetValueInt())
EndEvent

Function aroused()
    If PlayerRef.IsDead()
        return
    endif
	Int arousal = Condiexp_CurrentlyAroused.GetValueInt()
	PlayArousedExpression(PlayerRef, arousal, config)
	Utility.Wait(RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 4, 6))
EndFunction


Event OnEffectFinish(Actor akTarget, Actor akCaster)
	; keep script running
	config.currentExpression = "Aroused"
	Utility.Wait(1)
	;either 0 or aroused level > Condiexp_MinAroused
	aroused()
	resetMFGSmooth(PlayerRef)
	;verbose(akTarget, "Aroused: OnEffectFinish", Condiexp_Verbose.GetValueInt())
	Utility.Wait(2)
	Condiexp_CurrentlyBusy.SetValueInt(0)
EndEvent


