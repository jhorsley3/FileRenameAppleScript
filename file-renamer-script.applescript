-- Prompt for a name
set resultRecord to display dialog "Enter a name for the files:" default answer "" buttons {"Cancel", "OK"} default button "OK"
set fileNamePrefix to text returned of resultRecord
set buttonClicked to button returned of resultRecord

-- Check if user clicked Cancel
if buttonClicked is "Cancel" then
	return
end if

-- Prompt for a word to look for in file names
set resultRecord2 to display dialog "Enter a word to look for in file names:" default answer "" buttons {"Cancel", "OK"} default button "OK"
set searchWord to text returned of resultRecord2
set buttonClicked2 to button returned of resultRecord2

-- Check if user clicked Cancel
if buttonClicked2 is "Cancel" then
	return
end if

-- Select the folder containing the files to rename
set theFolder to choose folder with prompt "Select the folder containing the files to rename:"

-- Get the POSIX path of the folder
set folderPath to POSIX path of theFolder

-- Get the number of files in the folder
set fileCount to (do shell script "ls " & quoted form of folderPath & " | wc -l")

-- Rename all files in the folder with numbering starting with 01
set i to 1
tell application "Finder"
	set filesToRename to every file of theFolder whose name contains searchWord
	
	repeat with aFile in filesToRename
		-- Get the file extension (e.g., .txt, .jpg, etc.)
		set fileExtension to name extension of aFile
		
		-- Rename the file with the given prefix and numbered suffix
		set newFileName to fileNamePrefix & "_" & (text -2 thru -1 of ("00" & i)) & "." & fileExtension
		
		-- Handle potential errors (e.g., permission issues)
		try
			set name of aFile to newFileName
		on error errMsg
			display dialog "Error renaming file: " & errMsg buttons {"OK"} default button "OK"
		end try
		
		-- Increment the file count
		set i to i + 1
	end repeat
end tell

-- Notify the user that the task is complete
display dialog "Files renamed successfully!" buttons {"OK"} default button "OK"
