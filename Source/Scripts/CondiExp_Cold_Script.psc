Scriptname CondiExp_Cold_Script extends ActiveMagicEffect 
import CondiExp_log
import CondiExp_util
Actor Property PlayerRef Auto
GlobalVariable Property Condiexp_CurrentlyCold Auto 
GlobalVariable Property Condiexp_CurrentlyBusy Auto
GlobalVariable Property Condiexp_ColdMethod Auto
GlobalVariable Property Condiexp_ModSuspended Auto
GlobalVariable Property Condiexp_GlobalCold Auto

int coldExpression = 0 
 
Event OnEffectStart(Actor akTarget, Actor akCaster)
	Condiexp_CurrentlyBusy.SetValue(1)
	trace("CondiExp_Cold_Script OnEffectStart")
	RegisterForSingleUpdate(0.01)
EndEvent

event OnUpdate()
	if (Condiexp_CurrentlyCold.GetValue() == 1 && Condiexp_ModSuspended.GetValue() == 0 && Condiexp_GlobalCold.GetValue() == 1)
		PlayerRef.SetExpressionOverride(1,50)
		
		 ; cold intro
		if (coldExpression <= 65) 
			if (coldExpression < 0)
				coldExpression = 0
			endif
			PlayerRef.SetExpressionOverride(1,50)
			MfgConsoleFunc.SetModifier(PlayerRef, 12, coldExpression)
			MfgConsoleFunc.SetModifier(PlayerRef, 13, coldExpression)
			MfgConsoleFunc.SetModifier(PlayerRef, 4, coldExpression)
			coldExpression += 5
			
			RegisterForSingleUpdate(0.5)
		else ; this is Tremble
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,0)
			Utility.Wait(0.01)
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,6)
			Utility.Wait(0.01)
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,12)
			Utility.Wait(0.01)
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,6)
			Utility.Wait(0.01)
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,6)
			Utility.Wait(0.01)
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,12)
			Utility.Wait(0.01)
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,6)
			Utility.Wait(0.01)
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,6)
			Utility.Wait(0.01)
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,12)
			Utility.Wait(0.01)
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,6)
			doRegister()
		endif
	else
		;cold outro
		if (coldExpression >= 0)
			if (coldExpression > 65)
				coldExpression = 65
			endif
			MfgConsoleFunc.SetModifier(PlayerRef, 12, coldExpression)
			MfgConsoleFunc.SetModifier(PlayerRef, 13, coldExpression)
			MfgConsoleFunc.SetModifier(PlayerRef, 4, coldExpression)
			coldExpression  -= 5
			doRegister()
		else ; if the outro is done we clean up and stop calling update
			MfgConsoleFunc.SetPhoneMe(PlayerRef, 0,0)
			PlayerRef.ClearExpressionOverride()
			Condiexp_CurrentlyBusy.SetValue(0)
		endif
	endif
endevent

Function doRegister() 
	bool isSuspended =  Condiexp_ModSuspended.GetValue() == 1
	bool isDisabled = Condiexp_GlobalCold.GetValue() == 0
	bool stamina = PlayerRef.GetActorValuePercentage("Stamina") < 0.5 
	bool health = PlayerRef.GetActorValuePercentage("Health") > 0.5
	bool isSwimming = PlayerRef.IsSwimming()

	If  isSuspended || isDisabled || stamina || health || isSwimming 
		return
	endif

	RegisterForSingleUpdate(0.5)
endfunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)			
	trace("CondiExp_Cold_Script OnEffectFinish")
;OnEffectFinish is called, this script instance will only remain existing so long this function hasn't ended
;an OnUpdate might be still going so we first wait for it

	; now we start/continue the outro sequence
	while (coldExpression >= 0)
		if (coldExpression > 65)
			coldExpression = 65
		endif
		MfgConsoleFunc.SetModifier(PlayerRef, 12, coldExpression)
		MfgConsoleFunc.SetModifier(PlayerRef, 13, coldExpression)
		MfgConsoleFunc.SetModifier(PlayerRef, 4, coldExpression)
		coldExpression  -= 5
		Utility.Wait(0.5) ; !!!
	endwhile
	
	resetMFG(PlayerRef)
	Condiexp_CurrentlyBusy.SetValue(0)
EndEvent
