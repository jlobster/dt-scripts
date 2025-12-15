set errorFiles to {}
set predefinedTagsToRemove to {"SameDay"} -- This is similar to the retVal in the JS code

try
	tell application id "DNtp"
		set thisSelection to the selection
		if thisSelection is {} then error "Please select some contents."
		
		repeat with thisRecord in thisSelection
			if (type of thisRecord is PDF document) then
				set thisFile to path of thisRecord
				set successFlag to false
				
				-- Attempt to get the CreateDate
				try
					set pdfCDateString to (do shell script "/opt/homebrew/bin/exiftool -s3 -CreateDate -d '%A, %B %e, %Y at %I:%M:%S %p' " & (quoted form of thisFile)) as string
					set pdfCDate to my make_date(pdfCDateString)
					set (creation date of thisRecord) to pdfCDate
					set successFlag to true
				on error
					set filename to do shell script "basename " & quoted form of thisFile
					set errorFiles to errorFiles & {filename & " (CreateDate)"}
				end try
				
				-- Attempt to get the ModifyDate
				try
					set pdfMDateString to (do shell script "/opt/homebrew/bin/exiftool -s3 -ModifyDate -d '%A, %B %e, %Y at %I:%M:%S %p' " & (quoted form of thisFile)) as string
					set pdfMDate to my make_date(pdfMDateString)
					set (modification date of thisRecord) to pdfMDate
					set successFlag to true
				on error
					set filename to do shell script "basename " & quoted form of thisFile
					set errorFiles to errorFiles & {filename & " (ModifyDate)"}
				end try
				
				-- If either the creation or modification date was set successfully, remove the predefined tags
				if successFlag then
					set currentTags to tags of thisRecord
					set newTags to {}
					repeat with aTag in currentTags
						if aTag is not in predefinedTagsToRemove then
							set newTags to newTags & {aTag}
						end if
					end repeat
					set tags of thisRecord to newTags
				end if
			end if
		end repeat
	end tell
	
	if (count of errorFiles) > 0 then
		set errorString to "Done! Errors encountered for the following PDFs:" & linefeed
		repeat with errFile in errorFiles
			set errorString to errorString & "- " & errFile & linefeed
		end repeat
		display dialog errorString buttons {"OK"} default button 1
	else
		display dialog "Done! PDF dates were updated with no errors." buttons {"OK"} default button 1
	end if
	
on error error_message number error_number
	if the error_number is not -128 then
		try
			display alert "DEVONthink" message error_message as warning
		on error number error_number
			if error_number is -1708 then display dialog error_message buttons {"OK"} default button 1
		end try
	end if
	
end try

on make_date(date_string)
	set converted_date to date (date_string)
	return converted_date
end make_date
