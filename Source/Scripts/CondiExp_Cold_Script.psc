Scriptname CondiExp_Cold_Script extends ActiveMagicEffect 
import CondiExp_log
import CondiExp_util
Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyCold Auto 
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_CurrentlyBusyImmediate Auto
GlobalVariable Property Condiexp_ColdMethod Auto
GlobalVariable Property Condiexp_ModSuspended Auto
GlobalVariable Property Condiexp_GlobalCold Auto
condiexp_MCM Property config auto
GlobalVariable Property Condiexp_Verbose Auto

int coldExpression = 0 
 
Event OnEffectStart(Actor akTarget, Actor akCaster)
    Condiexp_CurrentlyBusy.SetValueInt(1)
    trace_line("CondiExp_Cold: OnEffectStart", Condiexp_Verbose.GetValueInt())
	config.currentExpression="Cold"
EndEvent

Function ShowExpression()
	verbose(PlayerRef, "Cold", Condiexp_Verbose.GetValueInt())
	CondiExp_util.SmoothSetExpression(PlayerRef,1, 90)
    float  elapsed   = 0.0               ; how long the loop has been running
    float  maxTime   = 15.0              ; hard cap (seconds) — tweak as you like

	while isCold() && (elapsed < maxTime)
		Utility.Wait(0.2)
		elapsed += 0.2                   ; keep track of time spent
		 ; cold intro
		if (coldExpression <= 65)
			if (coldExpression < 0)
				coldExpression = 0
			endif
			CondiExp_util.SetModifierFast(PlayerRef, 12, coldExpression)
			CondiExp_util.SetModifierFast(PlayerRef, 13, coldExpression)
			CondiExp_util.SetModifierFast(PlayerRef, 4, coldExpression)
			coldExpression += 5
		else ; this is Tremble
			CondiExp_util.SetPhonemeFast(PlayerRef, 0,0)
			Utility.Wait(0.05)
			CondiExp_util.SetPhonemeFast(PlayerRef, 0,3)
			Utility.Wait(0.05)
			CondiExp_util.SetPhonemeFast(PlayerRef, 0,15)
			Utility.Wait(0.05)
			CondiExp_util.SetPhonemeFast(PlayerRef, 0,3)
			Utility.Wait(0.05)
			CondiExp_util.SetPhonemeFast(PlayerRef, 0,3)
			Utility.Wait(0.05)
			CondiExp_util.SetPhonemeFast(PlayerRef, 0,15)
			Utility.Wait(0.05)
			CondiExp_util.SetPhonemeFast(PlayerRef, 0,3)
			Utility.Wait(0.05)
			CondiExp_util.SetPhonemeFast(PlayerRef, 0,3)
			Utility.Wait(0.05)
			CondiExp_util.SetPhonemeFast(PlayerRef, 0,15)
			Utility.Wait(0.05)
			CondiExp_util.SetPhonemeFast(PlayerRef, 0,3)
			elapsed += 0.5                   ; keep track of time spent
		endif
	endwhile
endFunction

bool Function isCold()
	bool bIsCold = Condiexp_CurrentlyCold.GetValueInt() == 1

	bool isSuspended =  Condiexp_ModSuspended.GetValueInt() == 1
	bool isDisabled = Condiexp_GlobalCold.GetValueInt() == 0
	bool isImmediateEffect = Condiexp_CurrentlyBusyImmediate.GetValueInt() != 0 
	bool lowStamina = PlayerRef.GetActorValuePercentage("Stamina") < 0.5
	bool lowHealth = PlayerRef.GetActorValuePercentage("Health") < 0.5
	
	bool isSwimming = PlayerRef.IsSwimming()

	If isSuspended || isDisabled || lowStamina || lowHealth || isSwimming || isImmediateEffect || !bIsCold || isInDialogueMFG(PlayerRef)
		log("CondiExp_Cold: cancelled effect")
		return false
	else
		return true
	endif
endfunction

bool Function isHardStop()
	bool isImmediateEffect = Condiexp_CurrentlyBusyImmediate.GetValueInt() != 0 
    bool isSuspended = Condiexp_ModSuspended.GetValueInt() != 0
    
	If isImmediateEffect || isInDialogueMFG(PlayerRef) || isSuspended
		log("CondiExp_Cold: hard stop")
		return true
	endif

    return false
endfunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    trace_line("CondiExp_Cold: OnEffectFinish - starting", Condiexp_Verbose.GetValueInt())
    Int Seconds = RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 1, 3)
	Utility.Wait(Seconds)
    ShowExpression()
	; now we start/continue the outro sequence if not hard stop
    if isHardStop()
        resetMFGSmooth(PlayerRef)
    else
        trace_line("Cold: cold outro", Condiexp_Verbose.GetValueInt())
	    while (coldExpression >= 0)
	    	if (coldExpression > 65)
	    		coldExpression = 65
	    	endif
	    	CondiExp_util.SetModifierFast(PlayerRef, 12, coldExpression)
	    	CondiExp_util.SetModifierFast(PlayerRef, 13, coldExpression)
	    	CondiExp_util.SetModifierFast(PlayerRef, 4, coldExpression)
	    	coldExpression  -= 5
	    	Utility.Wait(0.5) ; !!!
	    endwhile
	    resetMFGSmooth(PlayerRef)
    endif

	trace_line("Cold: OnEffectFinish done", Condiexp_Verbose.GetValueInt())
	config.currentExpression=""
	Condiexp_CurrentlyBusy.SetValueInt(0)
EndEvent
