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
	;verbose(akTarget, "Cold: OnEffectstart", Condiexp_Verbose.GetValueInt())
	Int Seconds =  RandomNumber(config.Condiexp_PO3ExtenderInstalled.getValue() == 1, 1, 3)
	Utility.Wait(Seconds)
	ShowExpression()
EndEvent

Function ShowExpression()
	config.currentExpression="Cold"
	verbose(PlayerRef, "Cold", Condiexp_Verbose.GetValueInt())
	CondiExp_util.SmoothSetExpression(PlayerRef,1,50)
	while isCold()
		Utility.Wait(0.2)
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
			Utility.Wait(0.01)
			CondiExp_util.SetPhonemeFast(PlayerRef, 0,6)
			Utility.Wait(0.01)
			CondiExp_util.SetPhonemeFast(PlayerRef, 0,12)
			Utility.Wait(0.01)
			CondiExp_util.SetPhonemeFast(PlayerRef, 0,6)
			Utility.Wait(0.01)
			CondiExp_util.SetPhonemeFast(PlayerRef, 0,6)
			Utility.Wait(0.01)
			CondiExp_util.SetPhonemeFast(PlayerRef, 0,12)
			Utility.Wait(0.01)
			CondiExp_util.SetPhonemeFast(PlayerRef, 0,6)
			Utility.Wait(0.01)
			CondiExp_util.SetPhonemeFast(PlayerRef, 0,6)
			Utility.Wait(0.01)
			CondiExp_util.SetPhonemeFast(PlayerRef, 0,12)
			Utility.Wait(0.01)
			CondiExp_util.SetPhonemeFast(PlayerRef, 0,6)
		endif
	endwhile
	
	;cold outro
	while (coldExpression >= 0)
		if (coldExpression > 65)
			coldExpression = 65
		endif
		CondiExp_util.SetModifierFast(PlayerRef, 12, coldExpression)
		CondiExp_util.SetModifierFast(PlayerRef, 13, coldExpression)
		CondiExp_util.SetModifierFast(PlayerRef, 4, coldExpression)
		coldExpression  -= 5
	endwhile
	; if the outro is done we clean up and stop
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

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	;OnEffectFinish is called, this script instance will only remain existing so long this function hasn't ended
	;a function might be still going so we first wait for it

	; now we start/continue the outro sequence
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
	Utility.Wait(1)
	trace(PlayerRef, "Cold: OnEffectFinish", Condiexp_Verbose.GetValueInt())
	If Condiexp_ModSuspended.GetValueInt()
		;do nothing
	elseIf Condiexp_CurrentlyBusyImmediate.GetValueInt() == 0
		resetMFGSmooth(PlayerRef)
	endif
	config.currentExpression=""
	Condiexp_CurrentlyBusy.SetValueInt(0)
EndEvent
