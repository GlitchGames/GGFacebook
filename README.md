GGFacebook
============

GGFacebook makes connecting and posting messages or images to Facebook very easy.
More functions will be added in the future. 

You must have a Facebook app set up with SSO enabled, see this tutorial -
http://www.coronalabs.com/blog/2012/01/04/implementing-facebook-single-sign-on/

Basic Usage
-------------------------

##### Require the code
```lua
local GGFacebook = require( "GGFacebook" )
```

##### Create your Facebook object passing in your apps id, optional listener and permissions
```lua
local facebook = GGFacebook:new( appID, listener, permissions )
```

##### Login
```lua
facebook:login()
```

##### Post to the users wall with a message and optional link
```lua
facebook:simplePost( "I just started playing Forever Lost by Glitch Games, it's really awesome!", "http://itunes.apple.com/us/app/forever-lost-episode-1-hd/id542364897?ls=1&mt=8" )
```

##### Check if the user has logged in. Only works if your listener function doesn't block the internal one
```lua
print( facebook:isLoggedIn() )
```

##### Post to the users wall with a table of options
```lua
local options = 
{
	message = "Check out this link!",
	link = "http://www.glitchgames.co.uk",
	name = "Glitch Games"
}
facebook:post( options )
```

##### Upload an image from the documents directory with a message
```lua
facebook:uploadImage( "Check out this image!", "image.png", system.DocumentsDirectory )
```

##### Show a Facebook UI dialog
```lua
facebook:showDialog( action, params )
```

##### Send a request to a specific user with a message and title
```lua
facebook:sendRequest( "Check out this game!", "GrahamRanson", "Dialog Title" )
```

##### Send a request to a group of users with a message and title
```lua
facebook:sendRequest( "Check out this game!", { "GrahamRanson", "SomeoneElse", "12345678" }, "Dialog Title" )
```

##### Send a request with a message and title but allow the user to select the recipients
```lua
facebook:sendRequest( "Check out this game!", nil, "Dialog Title" )
```

##### Bring up a dialog to post on a wall. Only the link is required.
```lua
facebook:makePost( "http://www.glitchgames.co.uk", "link to a picture", "name", "caption", "description" )
```

##### Bring up a dialog to post on the wall of a specific user. Only the link and username is required.
```lua
facebook:makePost( "http://www.glitchgames.co.uk", "link to a picture", "name", "caption", "description", "GlitchGames" )
```

##### Logout
```lua
facebook:logout()
```

##### Destroy the Facebook object
```lua
facebook:destroy()
facebook = nil
```

Update History
-------------------------

##### 0.1
Initial release