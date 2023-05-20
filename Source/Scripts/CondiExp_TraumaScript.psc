Scriptname CondiExp_TraumaScript extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util
import CondiExp_Expression_Util
Import mfgconsolefunc

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
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
sound property CondiExp_SobbingMale1 auto
sound property CondiExp_SobbingMale2 auto
sound property CondiExp_SobbingMale3 auto

condiexp_MCM Property config auto

Faction Property SexLabAnimatingFaction Auto ;empty - to delete
GlobalVariable Property Condiexp_Verbose Auto


bool playing = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValueInt(1)
	;verbose(PlayerRef, "Trauma: OnEffectStart", Condiexp_Verbose.GetValueInt())
	playing = true
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Utility.Wait(1)
	trauma()
	resetMFGSmooth(PlayerRef)
	;verbose(akTarget, "Trauma: OnEffectFinish", Condiexp_Verbose.GetValueInt())
	Utility.Wait(2)
	config.currentExpression = ""
	playing = false
	Condiexp_CurrentlyBusy.SetValueInt(0)
EndEvent

bool function isTraumaEnabled()
	bool enabled = !PlayerRef.IsDead() && Condiexp_GlobalTrauma.GetValueInt() == 1
	enabled = enabled && Condiexp_ModSuspended.GetValueInt() == 0  && Condiexp_CurrentlyBusyImmediate.GetValueInt() == 0
	enabled = enabled && !PlayerRef.IsRunning()
	enabled = enabled && playing
	return enabled
endfunction

Function trauma()
	If isTraumaEnabled()
        config.currentExpression = "Trauma"
		Int trauma = Condiexp_CurrentlyTrauma.GetValueInt() as Int
		;disease use case
		if trauma == 0
			trace(PlayerRef, "Trauma: disease ", Condiexp_Verbose.GetValueInt())
			trauma = 6
		endif
		PlayTraumaExpression(PlayerRef, trauma, config)
		BreatheAndSob(trauma)
		Utility.Wait( RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 4, 6))
    else
		log("CondiExp_Trauma: cancelled effect")
	endif
	
EndFunction

Function BreatheAndSob(int trauma)
	If PlayerRef.IsDead()
		return
	endif
	;;;;;;;;;;; SOUNDS ;;;;;;;;;;;;
	Int sobchance = RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 1, 5)
	 
	If Condiexp_Sounds.GetValueInt() > 0 && sobchance == 3
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

	Int randomSob = RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 1, 5)
	verbose(PlayerRef, "Trauma: sobbing: " + randomSob, Condiexp_Verbose.GetValueInt())
	int soundType = Condiexp_Sounds.GetValueInt()
	If soundType == 1 || soundType == 2 || soundType == 3
		if randomSob == 1
			CondiExp_SobbingMale1.play(PlayerRef)
		elseIf randomSob == 2
			CondiExp_SobbingMale2.play(PlayerRef)
		else
			CondiExp_SobbingMale3.play(PlayerRef)
		endif
   else 
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
	endif 


endfunction

