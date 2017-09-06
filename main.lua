-- ***********************************************************
-- This example shows the ussage for the plugin cnkFileManager
-- function shareFile to share a file with external apps
-- (C)2017 CNK Soft.
-- ***********************************************************
-- EXAMPLE 2 -- shareFile ussage.
--
-- Button 1 - using the pickFile() get an image file and save it to the Temporary Directory
-- Button 2 - using the pickFile() get any file (*/*) and save it to the Temporary Directory
-- Button 3 - using the shareFile() export that file as a forced "application/octet-stream"
-- Button 4 - using the shareFile() export that file as its own mimeType or by default "application/octet-stream".
--
-- Please, use the console to read the output. I have tried to explain each step.
-- After each action, the directory for Temporary and Documents will be shown using Lfs.
--
-- support: http://www.cnksoft.es/index.php/otro-software/9-plugin-cnkfilemanager-for-corona
--
-- Remember to include the following at the built.settings directory:
--
--     	plugins = {
--        	['plugin.cnkFileManager'] = {publisherId = 'es.cnksoft'},
--     	},
--
--
-- Also, remember to include the Android Permission as follow:
--
-- 		android =
-- 		{
--     		"android.permission.READ_EXTERNAL_STORAGE"
-- 		},
--
--



--plugin for manage uri
local library = require "plugin.cnkFileManager"


--additional plugins
local lfs = require( "lfs" )
local widget = require( "widget")





--GENERAL VARIABLES
local fileName = "" --variable that will hold the fileName for the file imported at Temporary.Directory



--GENERICS FUNCTIONS COMMON TO ALL CODE
--list Documents Directory
local function listDocDirectory()

	local _path = system.pathForFile( "", system.DocumentsDirectory )

	--print ("*** Files in Documents Directory ***")

	print ("\n--- Files in Documents Directory ---")
	for file in lfs.dir( _path ) do
	    -- "file" is the current file or directory name
	    --print( "Found file: " .. file )
	    print ( file )
	end
	print ("----------------------------------------------\n")

end


--list temporary directory
local function listTempDirectory()
	

	local _path = system.pathForFile( "", system.TemporaryDirectory )

	--print ("*** Files in Temporary Directory ***")

	print ("\n--- Files in Temporary Directory ---")
	for file in lfs.dir( _path ) do
	    -- "file" is the current file or directory name
	    --print( "Found file: " .. file )
	    print ( file )
	end
	print ("---------------------------------------------\n")

end


local function displayInfo(text)

	local _text = text or ""

	local myText = display.newText( text, display.contentCenterX, display.contentCenterY, native.systemFont, 16 )
	myText:setFillColor( 1, 0, 0, 1 )
	
	--dye after 3 seconds
	timer.performWithDelay( 3000, function()
		--destroy image
		if myText then
			myText:removeSelf()
			myText = nil
		end
	end)

end





--pickFile listener
local function listener1 (event)

	if event.done == "ok" then


		displayInfo ("File " .. event.destFileName .. " Saved !")

		print ("FILE READY TO BE SHARED --> ", event.destPath, event.destFileName)


		--list the directories
		listTempDirectory()
		listDocDirectory()

		--save the name of the file getted
		fileName = event.destFileName;

	else
		displayInfo ("ERROR. Read the Log.")
		print ("ERROR: ", event.error)
	end

end





--shareFile listener
local function listener2 (event)



	if event.action == "sent" then

		displayInfo ("File " .. fileName .. " Sent Ok !")

		print ("FILE SENT OK --> ", fileName)

	end

end




--positioning the buttons
local vS = display.contentHeight
local y1, y2, y3, y4 = (vS * .2), (vS * .4), (vS * .6), (vS * .8)
local x = display.contentWidth * .5




-- Create the widget
local button1 = widget.newButton(
    {
        x = x,
        y = y1,
        id = "button1",
        label = "Pick an image/*",
        onEvent = function (e)
        	if (e.phase == "ended") then
	        	print ("\nPick a File image/*, copy to TemporaryDirectory using pickFile(...)")

	        	local path = system.pathForFile( nil, system.TemporaryDirectory )
				local fileName = nil -- fileName we want the copy will be named (String)
				local headerText = nil -- personalized dialog (String)
				local mimeType = "image/*" -- mimetype to filter
				local onlyOpenable = true --avoid non openable files
				local onlyDocuments = nil --open only documents filter
				local dumyMode = false --simulate the copy
	        	library.pickFile(path, listener1, fileName, headerText, mimeType, onlyOpenable, onlyDocuments, dumyMode )
	        end
    	end,
    }
)

-- Create the widget
local button2 = widget.newButton(
    {
        x = x,
        y = y2,
        id = "button2",
        label = "Pick a File */*",
        onEvent = function (e)
        	if (e.phase == "ended") then
	        	print ("\nPick a File */*, and copy it to TemporaryDirectory using pickFile(...)")

	        	local path = system.pathForFile( nil, system.TemporaryDirectory )
				local fileName = nil -- fileName we want the copy will be named (String)
				local headerText = nil -- personalized dialog (String)
				local mimeType = "*/*" -- mimetype to filter
				local onlyOpenable = true --avoid non openable files
				local onlyDocuments = nil --open only documents filter
				local dumyMode = false --simulate the copy
	        	library.pickFile(path, listener1, fileName, headerText, mimeType, onlyOpenable, onlyDocuments, dumyMode )
	        end
    	end,
    }
)


-- Create the widget
local button3 = widget.newButton(
    {
        x = x,
        y = y3,
        id = "button3",
        label = "Share the File as binary",
        onEvent = function (e)
        	if (e.phase == "ended") then


        		if fileName ~= "" then

		        	print ("\nSharing the File always application/octet-stream using shareFile()...")

				    library.shareFile (
				    {
				        message = "Attached the File!",
				        listener = listener2,

				        --defaultMimeType = "application/octet-stream", --"image/jpg", --"text/plain",
				        forceMimeType = "application/octet-stream",

				        defaultChooser = false, --use the custom dialog with personal header
				        header = "Exportar con:",

				        file = 
				        {
				            { filename= fileName, baseDir=system.TemporaryDirectory },
				            --{ filename="file1.cnksr", baseDir=system.TemporaryDirectory },

				        },

				        url = 
				        {
				            "http://www.coronalabs.com",
				            "http://docs.coronalabs.com"
				        }
				    })

				else

					print ("There is no File ready! Use first the buttons 1 or 2 to get the file!")
					displayInfo ("Use buttons 1 or 2 first.")

				end

	        end
    	end,
    }
)

-- Create the widget
local button4 = widget.newButton(
    {
        x = x,
        y = y4,
        id = "button4",
        label = "Share withs its mimetype",
        onEvent = function (e)
        	if (e.phase == "ended") then

         		if fileName ~= "" then

		        	print ("\nSharing the File as its own mimeType or by default the application/octet-stream using shareFile()...")

				    library.shareFile (
				    {
				        message = "Attached the File!",
				        listener = listener2,

				        defaultMimeType = "application/octet-stream", --"image/jpg", --"text/plain",
				        --forceMimeType = "image/jpg",

				        defaultChooser = false, --use the custom dialog with personal header
				        header = "Exportar con:",

				        file = 
				        {
				            { filename= fileName, baseDir=system.TemporaryDirectory },
				            --{ filename="file1.cnksr", baseDir=system.TemporaryDirectory },

				        },

				        url = 
				        {
				            "http://www.coronalabs.com",
				            "http://docs.coronalabs.com"
				        }
				    })

				else

					print ("There is no File ready! Use first the buttons 1 or 2 to get the file!")
					displayInfo ("Use buttons 1 or 2 first.")

				end

	        end
    	end,
    }
)


-- END EXAMPLE --


