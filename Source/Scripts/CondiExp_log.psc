Scriptname CondiExp_log Hidden
{Simplified log writer file by Pickysaurus at Nexus Mods. }

Import Debug

Function log(String asMessage, Int aiPriority = 0) Global
	String asModName = "ConditionalExpressionsExtended"
	Utility.SetINIBool("bEnableTrace:Papyrus", true)
	if OpenUserLog(asModName)
		Trace(asModName + " Debugging Started.")
		TraceUser(asModName,"[---"+ asModName +" DEBUG LOG STARTED---]")
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
	
	TraceUser(asModName, asMessage, aiPriority)
EndFunction

Function trace(String msg, Int aiPriority = 0) Global 
	;log(msg,aiPriority)
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
    MiscUtil.PrintConsole("[CondiExp] " + msg)
EndFunction
