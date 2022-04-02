Scriptname CondiExp_TraumaScript extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util
import CondiExp_Expression_Util
Import mfgconsolefunc

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyTrauma Auto
GlobalVariable Property Condiexp_ModSuspended Auto
GlobalVariable Property Condiexp_GlobalTrauma Auto

GlobalVariable Property Condiexp_Sounds Auto
sound property CondiExp_BreathingFemale auto
sound property CondiExp_SobbingFemale1 auto
sound property CondiExp_SobbingFemale2 auto
sound property CondiExp_SobbingFemale3 auto
sound property CondiExp_SobbingFemale4 auto
sound property CondiExp_SobbingFemale5 auto

condiexp_MCM Property config auto
;todelete
Faction Property SexLabAnimatingFaction Auto
GlobalVariable Property Condiexp_Verbose Auto


bool playing = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValue(1)
	playing = true
	trace("CondiExp_TraumaScript OnEffectStart")
	Int Seconds = Utility.RandomInt(2, 4)
	Utility.Wait(Seconds)
	Int trauma = Condiexp_CurrentlyTrauma.GetValue() as Int
	config.currentExpression = "Trauma"
	PlayTraumaExpression(PlayerRef, trauma, config)
	BreatheAndSob(trauma)
	Utility.Wait(1)
	playing = false
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	; keep script running
	int safeguard = 0
	While (playing && safeguard <= 30)
		Utility.Wait(1)
		safeguard = safeguard + 1
	EndWhile
	resetMFGSmooth(PlayerRef)
	verbose(akTarget, "Trauma: OnEffectFinish. Time: " + safeguard, Condiexp_Verbose.GetValue() as Int)
	Utility.Wait(3)
	Condiexp_CurrentlyBusy.SetValue(0)
EndEvent

Function BreatheAndSob(int trauma)
	If PlayerRef.IsDead()
		return
	endif
	;;;;;;;;;;; SOUNDS ;;;;;;;;;;;;
	Int sobchance = Utility.RandomInt(1, 5)
	 
	If Condiexp_Sounds.GetValue() > 0 && sobchance == 3
		playBreathOrRandomSob(trauma)  
	endif
	;;;;;;;;;

	Utility.Wait(1)
EndFunction

Function playBreathOrRandomSob(int trauma)
	
	if trauma <= 3
		CondiExp_BreathingFemale.play(PlayerRef) 
		return
	endIf

	Int randomSob = Utility.RandomInt(1, 5)
	verbose(PlayerRef, "Trauma: sobbing: " + randomSob, Condiexp_Verbose.GetValue() as Int)
	if randomSob == 1
		CondiExp_SobbingFemale1.play(PlayerRef)
	elseIf randomSob == 2
		CondiExp_SobbingFemale2.play(PlayerRef)
	elseIf randomSob == 3
		CondiExp_SobbingFemale3.play(PlayerRef)
	elseIf randomSob == 4
		CondiExp_SobbingFemale4.play(PlayerRef)
	else 
		CondiExp_SobbingFemale5.play(PlayerRef)
	endif
endfunction

