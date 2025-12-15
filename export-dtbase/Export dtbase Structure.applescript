-- Exports the directory structure of the database to txt
-- Created by Joshua Liebster in December, 2025

-- Define the handler outside the tell block
on processGroup(theGroup, indentLevel)
	tell application id "DNtp"
		if not (exists current database) then
			error "No database is open."
		end if
		
		set groupName to name of theGroup
		
		-- Skip these folders entirely
		if groupName is "Trash" or groupName is "Tags" or groupName is "ImageArchive" then
			return ""
		end if
		
		set indent to ""
		repeat indentLevel times
			set indent to indent & "  "
		end repeat
		
		set groupType to type of theGroup
		set recordCount to count children of theGroup
		
		-- Check if this group is actually a group tag (with error handling for DT4)
		set groupTagType to missing value
		try
			set groupTagType to tag type of theGroup
		end try
		
		set groupIndicator to "="
		if groupTagType is group tag then
			set groupIndicator to "T"
		end if
		
		set output to indent & groupIndicator & " " & groupName & " (" & recordCount & " items)" & linefeed
		
		-- Get sample document names (first 5)
		set childRecords to children of theGroup
		repeat with i from 1 to count childRecords
			if i > 5 then exit repeat
			
			set childRecord to item i of childRecords
			if type of childRecord is not group then
				set docName to name of childRecord
				
				-- Get tags and distinguish between ordinary and group tags
				set docTags to tags of childRecord
				set ordinaryTags to {}
				set groupTags to {}
				
				repeat with aTag in docTags
					try
						set tagT to tag type of aTag
						if tagT is ordinary tag then
							set end of ordinaryTags to name of aTag
						else if tagT is group tag then
							set end of groupTags to name of aTag
						end if
					end try
				end repeat
				
				set tagString to ""
				if (count ordinaryTags) > 0 then
					set tagString to tagString & " [tags: " & my joinList(ordinaryTags, ", ") & "]"
				end if
				if (count groupTags) > 0 then
					set tagString to tagString & " [group-tags: " & my joinList(groupTags, ", ") & "]"
				end if
				
				-- Check if this is a replicant by counting parents
				set allParents to (parents of childRecord whose location does not contain "/Tags/")
				set parentCount to count allParents
				
				if parentCount > 1 then
					-- This is a replicant - show all parent locations
					set output to output & indent & "  " & quote & docName & tagString & "' -> REPLICANT (" & parentCount & " instances)" & linefeed
					repeat with parentGroup in allParents
						try
							set parentLoc to location of parentGroup
							set parentName to name of parentGroup
							set parentTagType to missing value
							try
								set parentTagType to tag type of parentGroup
							end try
							set parentMarker to ""
							if parentTagType is group tag then
								set parentMarker to " T"
							end if
							if parentLoc is not missing value and parentLoc is not "" then
								set output to output & indent & "    !" & " " & parentLoc & parentName & parentMarker & linefeed
							end if
						end try
					end repeat
				else
					-- Regular document
					set output to output & indent & "  " & quote & docName & tagString & linefeed
				end if
			end if
		end repeat
		
		-- Process subgroups recursively
		repeat with subGroup in children of theGroup
			if type of subGroup is group then
				set subGroupName to name of subGroup
				-- Skip ImageArchive subgroups too
				if subGroupName is not "ImageArchive" then
					set output to output & my processGroup(subGroup, indentLevel + 1)
				end if
			end if
		end repeat
		
		return output
	end tell
end processGroup

-- Helper to join list items with delimiter
on joinList(theList, delimiter)
	set oldDelimiters to AppleScript's text item delimiters
	set AppleScript's text item delimiters to delimiter
	set theString to theList as text
	set AppleScript's text item delimiters to oldDelimiters
	return theString
end joinList

-- Main script
tell application id "DNtp"
	set theDatabase to current database
	set dbName to name of theDatabase
	set dbPath to path of theDatabase
	
	set outputText to "DEVONthink Structure Export: " & dbName & linefeed
	set outputText to outputText & "Exported: " & (current date) & linefeed & linefeed
	
	-- Legend
	set outputText to outputText & "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" & linefeed
	set outputText to outputText & "LEGEND" & linefeed
	set outputText to outputText & "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" & linefeed
	set outputText to outputText & "= Folder Name (X items)           = Regular group/folder" & linefeed
	set outputText to outputText & "T Folder Name (X items)           = Group tag (acts as both group and tag)" & linefeed
	set outputText to outputText & "  " & quote & " Document Name                 = Regular document" & linefeed
	set outputText to outputText & "  " & quote & " Document [tags: x, y]         = Document with ordinary tags (metadata)" & linefeed
	set outputText to outputText & "  " & quote & " Document [group-tags: x]   = Document with group tags (replicated into tagged groups)" & linefeed
	set outputText to outputText & "  " & quote & " Document ' -> REPLICANT       = Same document in multiple locations" & linefeed
	set outputText to outputText & "    ! /path/to/location             = Parent group location" & linefeed
	set outputText to outputText & "    ! /path/to/location T           = Parent is a group tag" & linefeed
	set outputText to outputText & linefeed
	set outputText to outputText & "Excluded: Trash, Tags structure, ImageArchive folders" & linefeed
	set outputText to outputText & "Note: First 5 items per folder shown as samples" & linefeed
	set outputText to outputText & "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" & linefeed & linefeed
	
	-- Get root groups
	set rootGroups to children of root of theDatabase
	repeat with aGroup in rootGroups
		if type of aGroup is group then
			set groupName to name of aGroup
			-- Skip Trash and Tags at root level
			if groupName is not "Trash" and groupName is not "Tags" then
				set outputText to outputText & my processGroup(aGroup, 0)
			end if
		end if
	end repeat
	
	-- Write to file in same folder as database using native AppleScript
	try
		-- Get the folder containing the database
		set dbFolder to (do shell script "dirname " & quoted form of dbPath)
		
		-- Create the output filename and full path
		set outputFileName to dbName & "-structure.txt"
		set outputFilePath to dbFolder & "/" & outputFileName
		
		-- Convert to file reference and write
		set fileRef to open for access (POSIX file outputFilePath) with write permission
		try
			set eof fileRef to 0
			write outputText to fileRef as Çclass utf8È
			close access fileRef
		on error
			close access fileRef
			error
		end try
		
		display notification "Structure exported to " & outputFileName with title "DEVONthink Export"
		display dialog "Exported to: " & outputFilePath buttons {"OK"} default button 1
		
	on error errMsg number errNum
		display dialog "Error writing file: " & errMsg & " (Error " & errNum & ")" buttons {"OK"} default button 1 with icon stop
	end try
end tell
