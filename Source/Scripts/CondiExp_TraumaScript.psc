Scriptname CondiExp_TraumaScript extends ActiveMagicEffect  
import CondiExp_log
import CondiExp_util
import CondiExp_Expression_Util

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
GlobalVariable Property Condiexp_CurrentlyTrauma Auto
GlobalVariable Property Condiexp_ModSuspended Auto
GlobalVariable Property Condiexp_GlobalTrauma Auto

GlobalVariable Property Condiexp_Sounds Auto
sound property CondiExp_BreathingFemale auto
sound property CondiExp_BreathingMale auto
sound property CondiExp_BreathingMaleORC auto
sound property CondiExp_BreathingMaleKhajiit auto
sound property CondiExp_BreathingfemaleORC auto
sound property CondiExp_BreathingfemaleKhajiit auto
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
CondiExp_BaseExpression Property traumaExpr Auto

bool playing = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValueInt(1)
	;verbose(PlayerRef, "Trauma: OnEffectStart", Condiexp_Verbose.GetValueInt())
	playing = true
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Utility.Wait(1)
	trauma()
	;verbose(akTarget, "Trauma: OnEffectFinish", Condiexp_Verbose.GetValueInt())
	Utility.Wait(2)
	config.currentExpression = ""
	playing = false
	Condiexp_CurrentlyBusy.SetValueInt(0)
EndEvent

bool function isTraumaEnabled()
	bool enabled = !PlayerRef.IsDead() && Condiexp_GlobalTrauma.GetValueInt() == 1
	enabled = enabled && Condiexp_ModSuspended.GetValueInt() == 0  && Condiexp_CurrentlyBusyImmediate.GetValueInt() == 0
	enabled = enabled && !PlayerRef.IsRunning() && !isInDialogueMFG(PlayerRef)
	enabled = enabled && playing 
	return enabled
endfunction

Function trauma()
	If isTraumaEnabled()
        config.currentExpression = traumaExpr.Name
		Int trauma = Condiexp_CurrentlyTrauma.GetValueInt() as Int
		;disease use case
		if trauma == 0
			trace(PlayerRef, "Trauma: disease ", Condiexp_Verbose.GetValueInt())
			trauma = 6
		endif
		PlayTraumaExpression(PlayerRef, trauma, traumaExpr)
		BreatheAndSob(trauma)
		Utility.Wait( RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 4, 6))
		resetMFGSmooth(PlayerRef)
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
EndFunction

Function playBreathOrRandomSob(int trauma)
	int safeguard = 0
	bool triggerSound = false
	verbose(PlayerRef, "Trauma: breathing start" , Condiexp_Verbose.GetValueInt())
	Inhale(0,20, PlayerRef)
	Int safeguardMax = RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 3, 5)
	Int sobPoint = RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 0, safeguardMax)
	While (isTraumaEnabled()  && safeguard <= safeguardMax)
		if safeguard == sobPoint && trauma >= 4
			triggerSound = true
			; sob when high trauma
			Sob(PlayerRef, Condiexp_Sounds, triggerSound, trauma)
			Utility.Wait(1)
		else
			; breathe when not very high trauma
			Breathe(PlayerRef, Condiexp_Sounds)
		endIf
		triggerSound = false
		Utility.Wait(2)
		safeguard = safeguard + 1
	EndWhile
	verbose(PlayerRef, "Trauma: breathing finish after cycle:" + safeguard , Condiexp_Verbose.GetValueInt())
	Utility.Wait(1)
endfunction

Function Breathe(Actor akTarget, GlobalVariable sounds)
    Inhale(33,60, akTarget)
    ;;;;;;;;;;; SOUNDS ;;;;;;;;;;;;
    If sounds.GetValue() == 1
        int Breathe = CondiExp_BreathingMaleKhajiit.play(akTarget)     

    elseif sounds.GetValue() == 2
        int Breathe = CondiExp_BreathingMaleOrc.play(akTarget)   

    elseif sounds.GetValue() == 3
        int Breathe = CondiExp_BreathingMale.play(akTarget)     

    elseif sounds.GetValue() == 4
        int Breathe = CondiExp_BreathingfemaleKhajiit.play(akTarget)     

    elseif sounds.GetValue() == 5
        int Breathe = CondiExp_BreathingfemaleORC.play(akTarget)     

    elseif sounds.GetValue() == 6
        int Breathe = CondiExp_BreathingfeMale.play(akTarget)     
    endif 
    ;;;;;;;;;
    Exhale(60,20, akTarget)
EndFunction

bool Function Sob(Actor akTarget, GlobalVariable sounds, bool triggerSound, int trauma)
    Inhale(33,73, akTarget)
    ;;;;;;;;;;; SOUNDS ;;;;;;;;;;;;
	if triggerSound
		Int randomSob = RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 1, 5)
		int soundType = Condiexp_Sounds.GetValueInt()
		int aiPlaybackInstance
		If soundType == 1 || soundType == 2 || soundType == 3
			verbose(PlayerRef, "Trauma: sobbing male: " + randomSob, Condiexp_Verbose.GetValueInt())
			if randomSob == 1
				aiPlaybackInstance = CondiExp_SobbingMale1.play(PlayerRef)
			elseIf randomSob == 2
				aiPlaybackInstance = CondiExp_SobbingMale2.play(PlayerRef)
			else
				aiPlaybackInstance= CondiExp_SobbingMale3.play(PlayerRef)
			endif
		endif
		If soundType == 4 || soundType == 5 || soundType == 6 
			verbose(PlayerRef, "Trauma: sobbing female: " + randomSob, Condiexp_Verbose.GetValueInt())
			if randomSob == 1
				aiPlaybackInstance = CondiExp_SobbingFemale1.play(PlayerRef)
			elseIf randomSob == 2
				aiPlaybackInstance = CondiExp_SobbingFemale2.play(PlayerRef)
			elseIf randomSob == 3
				aiPlaybackInstance = CondiExp_SobbingFemale3.play(PlayerRef)
			elseIf randomSob == 4
				aiPlaybackInstance = CondiExp_SobbingFemale4.play(PlayerRef)
			else
				aiPlaybackInstance = CondiExp_SobbingFemale5.play(PlayerRef)
			endif
		endif
		if aiPlaybackInstance
			Sound.SetInstanceVolume(aiPlaybackInstance, (trauma as Float)/10)
		endif
	endif
    ;;;;;;;;;
    Exhale(73,20, akTarget)
EndFunction

