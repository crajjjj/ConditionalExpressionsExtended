Scriptname CondiExp_Interface_Appr2 Hidden
import CondiExp_log
import CondiExp_util

Int Function GetWearState0to10(Actor akTarget, Quest apropos2Quest) Global	
	if !apropos2Quest
		return 0
	endif
	
	ReferenceAlias aproposTwoAlias = GetAproposAlias(akTarget, apropos2Quest)
	if aproposTwoAlias != None
		Int damage = (aproposTwoAlias as Apropos2ActorAlias).AverageAbuseState
		If damage <= 10
			return damage
		Else
			return 10
		EndIf
	Else
		return 0
	Endif
EndFunction

ReferenceAlias Function GetAproposAlias(Actor akTarget, Quest apropos2Quest ) Global
	; Search Apropos2 actor aliases as the player alias is not set in stone
	ReferenceAlias AproposTwoAlias = None
	Int i = 0
	ReferenceAlias AliasSelect
	While i < apropos2Quest.GetNumAliases() 
		AliasSelect = apropos2Quest.GetNthAlias(i) as ReferenceAlias
		If AliasSelect.GetReference() as Actor == akTarget
			AproposTwoAlias = AliasSelect
		EndIf
		Return AproposTwoAlias
		i += 1
	EndWhile
	Return AproposTwoAlias
EndFunction