Scriptname CondiExp_Interface_SL Hidden
import CondiExp_log
import CondiExp_util 

Bool Function IsPlayerCumsoakedOral(Quest sexlab, Actor targetActor) global 
	If (sexlab && (sexlab as SexLabFramework).Enabled)
		return (sexlab as SexLabFramework).CountCum(targetActor, false, True, false) > 0
	else
		return false
	endif
EndFunction

Bool Function IsPlayerCumsoakedVagOrAnal(Quest sexlab, Actor targetActor) global 
	If (sexlab && (sexlab as SexLabFramework).Enabled)
		return (sexlab as SexLabFramework).CountCum(targetActor, True, false, True) > 0
	else
		return false
	EndIf
EndFunction