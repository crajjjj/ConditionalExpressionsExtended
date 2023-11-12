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

Int Function getExposureLevel(Faction exposureFaction, Quest sla, Actor akTarget) Global
	Int exposure = akTarget.GetFactionRank(exposureFaction)
	If (exposure < 0)
		exposure = (sla as slaFrameworkScr).GetActorExposure(akTarget)
	EndIf
	if exposure < 0
		exposure = 0
	elseif exposure > 100
		exposure = 100
	endIf
	return exposure
EndFunction

Bool Function setArousaToValue(Actor act, Quest sla, Faction arousalFaction,Int arousalCap) global
	return false
endfunction

Bool Function setExposureToValue(Actor act, Quest sla, Faction exposureFaction, Int exposureCap) global
	if !sla || !act
		return false
	endif
	Int exposure = getExposureLevel(exposureFaction, sla, act)
	if exposure > (exposureCap + 5)
		(sla as slaFrameworkScr).SetActorExposure(act,exposureCap)
		return true
	endif
	return false
EndFunction