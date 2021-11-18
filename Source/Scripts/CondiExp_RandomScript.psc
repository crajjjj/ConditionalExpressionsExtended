Scriptname CondiExp_RandomScript extends ActiveMagicEffect  
import CondiExp_util
import CondiExp_log
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

Event OnEffectStart(Actor akTarget, Actor akCaster)
	trace("CondiExp_RandomScript OnEffectStart")
	ShowExpression()
	doRegister() 
EndEvent

Function doRegister() 
	If  Condiexp_GlobalRandom.GetValue() == 0 || Condiexp_ModSuspended.GetValue() == 1 || Condiexp_CurrentlyBusy.GetValue() == 1
		return
	endif

	If !PlayerRef.IsRunning() && !PlayerRef.GetAnimationVariableInt("i1stPerson")
		Int Seconds = Utility.RandomInt(2, 5)
		RegisterForSingleUpdate(Seconds)
	endif
endfunction

Function ShowExpression() 
	Utility.Wait(1)
	RandomEmotion(PlayerRef)
	Utility.Wait(1)
EndFunction

Event OnUpdate()
	If !PlayerRef.GetAnimationVariableInt("i1stPerson")
		If Condiexp_CurrentlyBusy.GetValue() == 0
			ShowExpression() 
			doRegister() 
		EndIf
	endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	trace("CondiExp_RandomScript OnEffectFinish")
	Utility.Wait(1)
	resetMFG(PlayerRef)
EndEvent