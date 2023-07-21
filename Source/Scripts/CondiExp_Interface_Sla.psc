Scriptname CondiExp_Interface_Sla Hidden
import CondiExp_log
import CondiExp_util

Int Function getArousal0To100(Actor act, Quest sla, Faction arousalFaction) global
	if !sla || !act
		return 0
	endif

	Int arousal = act.GetFactionRank(arousalFaction)
	If (arousal < 0)
		arousal = (sla as slaFrameworkScr).GetActorArousal(act)
	EndIf
	
	if arousal < 0
		arousal = 0
	elseif arousal > 100
		arousal = 100
	endIf
	return arousal
EndFunction

Bool Function setArousaToValue(Actor act, Quest sla, Faction arousalFaction,Int arousalCap) global
	if !sla || !act
		return false
	endif
	Int arousal = act.GetFactionRank(arousalFaction)
	If (arousal < 0)
		arousal = (sla as slaFrameworkScr).GetActorArousal(act)
	EndIf
	if arousal > (arousalCap + 5)
		(sla as slaFrameworkScr).SetActorExposure(act,arousalCap)
		return true
	endif
	return false
EndFunction