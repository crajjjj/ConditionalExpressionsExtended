Scriptname CondiExp_Interface_Sla Hidden
import CondiExp_log
import CondiExp_util

Int Function getArousal0To100(Actor PlayerRef, Quest sla, Faction arousalFaction) global
	if !sla
		return 0
	endif

	Int arousal = PlayerRef.GetFactionRank(arousalFaction)
	If (arousal < 0)
		arousal = (sla as slaFrameworkScr).GetActorArousal(PlayerRef)
	EndIf
	
	if arousal < 0
		arousal = 0
	elseif arousal > 100
		arousal = 100
	endIf
	return arousal
EndFunction