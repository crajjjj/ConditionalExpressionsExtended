Scriptname CondiExp_Interface_Sla Hidden
import CondiExp_log
import CondiExp_util

Int Function getArousal0To100(Actor act, Quest sla, Faction arousalFaction) global
	if !sla || !act
		return 0
	endif
	int slaVersion = (sla as slaFrameworkScr).GetVersion()
	Int arousal = 0
	if slaVersion > 20200000
		arousal = (sla as slaFrameworkScr).GetActorArousal(act)
	else
		arousal = act.GetFactionRank(arousalFaction)
		If (arousal < 0)
			 arousal = (sla as slaFrameworkScr).GetActorArousal(act)
		EndIf
	endif
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

Bool Function capExposureAndArousal(Actor act, Quest sla, Faction exposureFaction, Faction arousalFaction, Int cap, Int decrease, String effectName) global
	if !sla || !act
		return false
	endif
	bool result = false
	int step = 60
	Int exposure = getExposureLevel(exposureFaction, sla, act)
	int arousal = getArousal0To100(act, sla, arousalFaction)

	if arousal >= (cap + 5)
		int handle = ModEvent.Create("slaSetArousalEffect")
            ModEvent.PushForm(handle, act)
            ModEvent.PushString(handle, effectName)
            ModEvent.PushFloat(handle, 0-decrease); start negative
            ModEvent.PushInt(handle, 2);
            ModEvent.PushFloat(handle, step * 24.0); 60 each hour
            ModEvent.PushFloat(handle, 0); remove when cap reached

		result = ModEvent.Send(handle)
	endif
	if exposure >= (cap + 5)
		(sla as slaFrameworkScr).SetActorExposure(act, exposure - decrease/2)
		result = true
	endif
	return result
EndFunction