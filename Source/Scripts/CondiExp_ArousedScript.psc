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

bool playing = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValue(1)
	playing = true
	trace("CondiExp_ArousedScript OnEffectStart")
	Int Seconds = Utility.RandomInt(2, 4)
	Utility.Wait(Seconds)
	;either 0 or aroused level > Condiexp_MinAroused
	Int arousal = Condiexp_CurrentlyAroused.GetValue() as Int
	PlayArousedExpression( PlayerRef, arousal, Condiexp_Verbose.GetValue() as Int)
	playing = false
	Utility.Wait(1)
EndEvent



Event OnEffectFinish(Actor akTarget, Actor akCaster)
	; keep script running
	int safeguard = 0
	While (playing && safeguard <= 30)
		Utility.Wait(1)
		safeguard = safeguard + 1
	EndWhile
	resetMFGSmooth(PlayerRef)
	Utility.Wait(3)
	verbose(akTarget, "Aroused: OnEffectFinish. Time: " + safeguard, Condiexp_Verbose.GetValue() as Int)
	Condiexp_CurrentlyBusy.SetValue(0)
EndEvent


