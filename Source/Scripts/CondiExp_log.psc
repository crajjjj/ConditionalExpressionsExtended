Scriptname CondiExp_log Hidden
{Simplified log writer file by Pickysaurus at Nexus Mods. }

Import Debug

Function log(String asMessage, Int aiPriority = 0) Global
	String asModName = "ConditionalExpressionsExtended"
	Utility.SetINIBool("bEnableTrace:Papyrus", true)
	if OpenUserLog(asModName)
		Debug.Trace(asModName + " Debugging Started.")
		Debug.TraceUser(asModName,"[---"+ asModName +" DEBUG LOG STARTED---]")
	endif
	String sPrefix
	if aiPriority == 2
		sPrefix = "(!ERROR!) "
	elseif aiPriority == 1
		sPrefix = "(!) "
	else
		sPrefix = "(i) "
	endif

	asMessage = sPrefix + asMessage
	
	Debug.TraceUser(asModName, asMessage, aiPriority)
EndFunction


Function verbose(Actor act, String msg, Int enabled = 0) Global 
	;log(msg,aiPriority)
	If (enabled == 1)
		if act
			msg = "[CondiExp] (Actor:"+ act.GetLeveledActorBase().GetName() +") " + msg
		else
			msg = "[CondiExp] (Actor: None) " + msg
		endif
		Debug.Notification(msg)
		log(msg)
	EndIf
EndFunction

Function trace(Actor act, String msg, Int enabled = 0) Global 
	;log(msg,aiPriority)
	If (enabled == 1)
		if act
			msg = "(Actor:"+ act.GetLeveledActorBase().GetName() +") " + msg
		else
			msg = "(Actor: None) " + msg
		endif
		log(msg)
	EndIf
EndFunction

Function trace_line(String msg, Int enabled = 0) Global 
	;log(msg,aiPriority)
	If (enabled == 1)
		log(msg)
	EndIf
EndFunction

Function logAndPrintConsole(String asMessage, Int aiPriority = 0) Global
	log(asMessage,aiPriority)
	PrintConsole(asMessage)
EndFunction

Function logAndNotification(String asMessage, Int aiPriority = 0) Global
	log(asMessage,aiPriority)
	Notification(asMessage)
EndFunction

Function Notification(String msg) Global
    Debug.Notification("[CondiExp] " + msg)
EndFunction

Function PrintConsole(String msg) Global
    ;MiscUtil.PrintConsole("[CondiExp] " + msg)
EndFunction
