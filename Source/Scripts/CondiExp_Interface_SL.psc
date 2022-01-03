Scriptname CondiExp_Interface_SL Hidden
import CondiExp_log
import CondiExp_util

Bool Function IsPlayerCumsoaked(Quest sexlab, Actor targetActor) global 
		return (sexlab as SexLabFramework).CountCum(targetActor, True, True, True) > 0
EndFunction