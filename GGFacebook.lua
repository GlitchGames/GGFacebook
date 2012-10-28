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
    
    self.internalListener = function( event )
    	
    	if self.listener then
    		if self.listener( event ) then
    			return true
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

--- Destroys the Facebook object.
function GGFacebook:destroy()
	 self.appID = appID
    self.listener = listener
    self.permissions = permissions
end

return GGFacebook