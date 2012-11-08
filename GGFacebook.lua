-- Project: GGFacebook
--
-- Date: October 27, 2012
--
-- Version: 0.1
--
-- File name: GGFacebook.lua
--
-- Author: Graham Ranson of Glitch Games - www.glitchgames.co.uk
--
-- Update History:
--
-- 0.1 - Initial release
--
-- Comments: 
-- 
--		GGFacebook makes connecting and posting messages or images to Facebook very easy.
--		More functions will be added in the future. 
--
--		You must have a Facebook app set up with SSO enabled, see this tutorial -
--		http://www.coronalabs.com/blog/2012/01/04/implementing-facebook-single-sign-on/
--
-- Copyright (C) 2012 Graham Ranson, Glitch Games Ltd.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this 
-- software and associated documentation files (the "Software"), to deal in the Software 
-- without restriction, including without limitation the rights to use, copy, modify, merge, 
-- publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons 
-- to whom the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies or 
-- substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.
--
----------------------------------------------------------------------------------------------------

local GGFacebook = {}
local GGFacebook_mt = { __index = GGFacebook }

local facebook = require( "facebook" )

--- Initiates a new GGFacebook object.
-- @param appID The id of your app.
-- @param listener Function to be called on Facebook events. Optional, and GGFacebook has an internal one. If you have one and don't want the GGFacebook one to take action just return true in yours.
-- @param permissions A table of strings corresponding to Facebook permissions.
-- @return The new object.
function GGFacebook:new( appID, listener, permissions )
    
    local self = {}
    
    setmetatable( self, GGFacebook_mt )
    
    self.appID = appID
    self.listener = listener
    self.permissions = permissions
    self.accessToken = nil
    
    self.internalListener = function( event )
    	
    	self.accessToken = event.token
    	
    	if self.listener then
    		if self.listener( event ) then
    			return true
    		end
    	end
    	
    	if event.type == "session" then
        	if event.phase == "login" then
        		self.loggedIn = true
        	end
        end
        
    end
    
    return self
    
end

--- Login to Facebook.
function GGFacebook:login()
	facebook.login( self.appID, self.internalListener, self.permissions )
end

--- Logout from Facebook.
function GGFacebook:logout()
	facebook.logout()
end

--- Posts a status update to the users feed.
-- @param message The message to post.
-- @param link A link to include with the post, useful for promoting your app. Optional.
function GGFacebook:simplePost( message, link )
	self:post{ message = message or "", link = link }
end

--- Posts a status update to the users feed.
-- @param options A table containing the paramaters of the post. See this page for help: https://developers.facebook.com/docs/reference/api/post/
function GGFacebook:post( options )
	facebook.request( "me/feed", "POST", options )
end

--- Uploads an image.
-- @param message The message to include with the photo. Optional.
-- @param filename The filename of the image to upload.
-- @param baseDir The base directory of the image. Optional, defaults to system.DocumentsDirectory.
function GGFacebook:uploadImage( message, filename, baseDir )

	local attachment = 
	{
        message = message or "",
        source = 
        {
            baseDir = baseDir or system.DocumentsDirectory, 
            filename = filename,
            type = "image"
        }
	}

	facebook.request( "me/photos", "POST", attachment )

end

--- Shows a Facebook dialog page for allowing the user to do stuff. See this page for help: http://developers.facebook.com/docs/reference/dialogs/
-- @param action The dialog you want to show.
-- @param params Table of paramaters passed to the Facebook API.
function GGFacebook:showDialog( action, params )
	facebook.showDialog( action, params )
end

--- Send a request to a user.
-- @param message The message to include with the request.
-- @param to Either a single ID of a Facebook user to send to or a table or IDs. Optional, leave out to just bring up the multi-user select screen.
-- @param title Title for the dialog, optional and max of 50 characters.
function GGFacebook:sendRequest( message, to, title )
	
	local params = {}
	params.message = message or ""
	params.title = title
	
	if to then
		if type( to ) == "table" then
			params.to = ""
			for i = 1, #to, 1 do
				params.to = params.to .. to[ i ]
				if i < #to then
					params.to = params.to .. ","
				end
			end
		else
			params.to = to
		end
	end
	
	self:showDialog( "apprequests", params )
	
end

--- Send a link to a user.
-- @param to The user id or username of the person to send it to.
-- @param link The link to send.
-- @param picture The url to a picture to use for the link. Optional, by default one will be pulled from the link.
-- @param name The name of the link. Optional, by default one will be pulled from the link.
-- @param description The description of the link. Optional, by default one will be pulled from the link.
function GGFacebook:sendLink( to, link, picture, name, description, to )
	
	local params = {}
	
	params.to = to
	params.link = link
	params.picture = picture
	params.name = name
	params.description = description
	
	self:showDialog( "send", params )
	
end

--- Make a post on a wall.
-- @param link The link to post.
-- @param picture The url to a picture to use for the link. Optional, by default one will be pulled from the link.
-- @param name The name of the link. Optional, by default one will be pulled from the link.
-- @param caption The caption of the link. Optional, by default one will be pulled from the link.
-- @param description The description of the link. Optional, by default one will be pulled from the link.
-- @param to The user id or username of the person whose wall wall this will be posted on. Optional, default is the current user.
function GGFacebook:makePost( link, picture, name, caption, description, to )
	
	local params = {}
	
	params.to = to
	params.link = link
	params.picture = picture
	params.name = name
	params.caption = caption
	params.description = description
	
	self:showDialog( "feed", params )
	
end

--- Checks if the user is logged in, only works if you're listener function doesn't block the internal one.
-- @return True if logged in, false otherwise.
function GGFacebook:isLoggedIn()
	return self.loggedIn
end

--- Destroys the Facebook object.
function GGFacebook:destroy()
	 self.appID = appID
    self.listener = listener
    self.permissions = permissions
end

return GGFacebook