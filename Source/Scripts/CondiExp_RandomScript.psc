Scriptname CondiExp_RandomScript extends ActiveMagicEffect  
import CondiExp_util
import CondiExp_log
import CondiExp_Expression_Util

Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyCold Auto
GlobalVariable Property Condiexp_ColdGlobal Auto
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property CondiExp_PlayerIsHigh Auto
GlobalVariable Property CondiExp_PlayerIsDrunk Auto
GlobalVariable Property Condiexp_GlobalRandomFrequency Auto
GlobalVariable Property Condiexp_CurrentlyTrauma Auto
GlobalVariable Property Condiexp_CurrentlyDirty Auto
GlobalVariable Property Condiexp_ModSuspended Auto
GlobalVariable Property Condiexp_GlobalRandom Auto
GlobalVariable Property Condiexp_Verbose Auto
bool playing = false
Event OnEffectStart(Actor akTarget, Actor akCaster)
	verbose("CondiExp_RandomScript OnEffectStart", Condiexp_Verbose.GetValue() as Int)
	ShowExpression()
	doRegister() 
	playing = true
EndEvent

Function doRegister() 
	If  Condiexp_GlobalRandom.GetValue() == 0 || Condiexp_ModSuspended.GetValue() == 1 || Condiexp_CurrentlyBusy.GetValue() == 1
		playing = false
		return
	endif

	If !PlayerRef.IsRunning() && !PlayerRef.GetAnimationVariableInt("i1stPerson")
		Int Seconds = Utility.RandomInt(2, 5)
		RegisterForSingleUpdate(Seconds)
	else
		playing = false
	endif
endfunction

Function ShowExpression() 
	Utility.Wait(1)
	RandomEmotion(PlayerRef)
EndFunction

Event OnUpdate()
	If !PlayerRef.GetAnimationVariableInt("i1stPerson")
		If Condiexp_CurrentlyBusy.GetValue() == 0
				ShowExpression()
				doRegister()
			Else
				playing = false
		EndIf
	endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	trace("CondiExp_RandomScript OnEffectFinish")
	int safeguard = 0
	While (playing && safeguard <= 60)
		Utility.Wait(1)
		safeguard = safeguard + 1
	EndWhile
	resetMFG(PlayerRef)
	verbose("CondiExp_RandomScript OnEffectFinish. Time: " + safeguard, Condiexp_Verbose.GetValue() as Int )
	Utility.Wait(3)
EndEvent