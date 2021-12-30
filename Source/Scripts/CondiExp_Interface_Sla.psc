Scriptname CondiExp_Interface_Sla Hidden
import CondiExp_log
import CondiExp_util

Int Function getArousal0To100(Actor PlayerRef, Quest sla) global
	if !sla
		return 0
	endif
	Int arousal = (sla as slaFrameworkScr).GetActorArousal(PlayerRef)
	if arousal < 0
		arousal = 0
	elseif arousal > 100
		arousal = 100
	endIf
	return arousal
EndFunction