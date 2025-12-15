set outputPath to (POSIX path of (path to desktop)) & "devonthink4_smart_rules.json"

set jsonText to "["
set firstRule to true

tell application id "DNtp"
	repeat with r in smart rules
		
		if not firstRule then
			set jsonText to jsonText & ","
		end if
		set firstRule to false
		
		set ruleName to my jsonEscape(name of r)
		set ruleUUID to uuid of r
		set ruleEnabled to enabled of r
		
		-- CONDITIONS
		set conditionJSON to "["
		set firstCond to true
		try
			repeat with c in conditions of r
				if not firstCond then
					set conditionJSON to conditionJSON & ","
				end if
				set firstCond to false
				set conditionJSON to conditionJSON & "\"" & my jsonEscape(description of c) & "\""
			end repeat
		end try
		set conditionJSON to conditionJSON & "]"
		
		-- ACTIONS
		set actionJSON to "["
		set firstAction to true
		try
			repeat with a in actions of r
				if not firstAction then
					set actionJSON to actionJSON & ","
				end if
				set firstAction to false
				set actionJSON to actionJSON & "\"" & my jsonEscape(description of a) & "\""
			end repeat
		end try
		set actionJSON to actionJSON & "]"
		
		set jsonText to jsonText & "{"
		set jsonText to jsonText & "\"name\":\"" & ruleName & "\","
		set jsonText to jsonText & "\"uuid\":\"" & ruleUUID & "\","
		set jsonText to jsonText & "\"enabled\":" & ruleEnabled & ","
		set jsonText to jsonText & "\"conditions\":" & conditionJSON & ","
		set jsonText to jsonText & "\"actions\":" & actionJSON
		set jsonText to jsonText & "}"
		
	end repeat
end tell

set jsonText to jsonText & "]"

-- Write file
do shell script "printf %s " & quoted form of jsonText & " > " & quoted form of outputPath

display dialog "DEVONthink Smart Rules exported to:" & return & outputPath
