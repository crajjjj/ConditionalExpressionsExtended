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
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
CondiExp_BaseExpression Property randomExpr Auto
bool playing = false
int resetCounter = 0
condiexp_MCM Property config auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	;verbose(akTarget, "Random: OnEffectStart", Condiexp_Verbose.GetValueInt())
	if akTarget == None
        return
    endif
	RegisterForSingleUpdate(1)
	playing = true
	config.currentExpression = "Random"
	trace(PlayerRef, "Random-OnEffectStart", Condiexp_Verbose.GetValueInt())
EndEvent

Event OnUpdate()
	trace(PlayerRef, "Random-OnUpdate", Condiexp_Verbose.GetValueInt())
	config.currentExpression = "Random"
	If isRandomEnabled()
   		PlayRandomExpression(PlayerRef, config, randomExpr)
		resetCounter += 1
		if resetCounter > 4
			resetMFGSmooth(PlayerRef)
			resetCounter = 0
		endif
		if playing && self != None
			RegisterForSingleUpdate( RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 2, 5))
		else
			log("CondiExp_Random: cancelled effect")
		endif
    else
		log("CondiExp_Random: cancelled effect")
		resetCounter = 0
	endif
	config.currentExpression = ""
EndEvent

bool function isRandomEnabled()
	bool enabled = PlayerRef && !PlayerRef.IsDead() && Condiexp_GlobalRandom.GetValueInt() == 1
	enabled = enabled && Condiexp_ModSuspended.GetValueInt() == 0 && Condiexp_CurrentlyBusy.GetValueInt() == 0 && Condiexp_CurrentlyBusyImmediate.GetValueInt() == 0
	enabled = enabled && !PlayerRef.GetAnimationVariableInt("i1stPerson") && !PlayerRef.IsRunning() && !isInDialogueMFG(PlayerRef)
	enabled = enabled && playing
	return enabled
endfunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	playing = false
	If (!isInDialogueMFG(PlayerRef))
		;dialog handled in util
		resetMFGSmooth(PlayerRef)
	EndIf
	resetCounter = 0
	trace_line("CondiExp_Random: OnEffectFinish. Suspended: " + Condiexp_ModSuspended.GetValueInt(), Condiexp_Verbose.GetValueInt())
	config.currentExpression = ""
EndEvent