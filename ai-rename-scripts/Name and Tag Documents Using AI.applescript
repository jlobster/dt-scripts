on scriptOutput(theRecord, theInput)
	tell application id "DNtp"
		try
			tell theRecord
				set name to paragraph 1 of theInput
				set tags to paragraph 2 of theInput
				if tags is not {} then set tags to (tags & "AI Processed")
				set comment to paragraph 3 of theInput
			end tell
		on error msg
			display alert msg
			log message "Couldn't be processed" record theRecord
			return
		end try
	end tell
end scriptOutput