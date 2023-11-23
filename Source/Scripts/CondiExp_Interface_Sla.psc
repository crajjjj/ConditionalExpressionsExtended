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

Int Function getArousal0To100Direct(Actor act, Quest sla) global
	if !sla || !act
		return 0
	endif

	Int arousal = (sla as slaFrameworkScr).GetActorArousal(act)
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

Bool Function capExposureAndArousal(Actor act, Quest sla, Faction exposureFaction, Int cap, Int decrease, String effectName) global
	if !sla || !act
		return false
	endif
	bool result = false
	Int exposure = getExposureLevel(exposureFaction, sla, act)
	int arousal = getArousal0To100Direct(act, sla)

	if arousal >= (cap + 5)
		int handle = ModEvent.Create("slaSetArousalEffect")
            ModEvent.PushForm(handle, act)
            ModEvent.PushString(handle, effectName)
            ModEvent.PushFloat(handle, arousal - decrease)
            ModEvent.PushInt(handle, 2);
            ModEvent.PushFloat(handle, 100 * 24.0); 100 each hour
            ModEvent.PushFloat(handle, 0); remove when cap reached

		result = ModEvent.Send(handle)
	endif
	if exposure >= (cap + 5)
		(sla as slaFrameworkScr).SetActorExposure(act, exposure - decrease/2)
		result = true
	endif
	return result
EndFunction