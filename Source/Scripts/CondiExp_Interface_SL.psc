Scriptname CondiExp_Interface_SL Hidden
import CondiExp_log
import CondiExp_util

Bool Function IsPlayerCumsoakedOral(Quest sexlab, Actor targetActor) global 
	return (sexlab as SexLabFramework).CountCum(targetActor, false, True, false) > 0
EndFunction

Bool Function IsPlayerCumsoakedVagOrAnal(Quest sexlab, Actor targetActor) global 
	return (sexlab as SexLabFramework).CountCum(targetActor, True, false, True) > 0
EndFunction