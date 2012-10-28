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

##### Post to the users wall with a table of options
```lua
local options = 
{
	message = "Check out this link!",
	link = "http://www.glitchgames.co.uk",
	name = "Glitch Games"
}
GGFacebook:post( options )
```

##### Upload an image from the documents directory with a message
```lua
facebook:uploadImage( "Check out this image!", "image.png", system.DocumentsDirectory )
```

##### Show a Facebook UI dialog
```lua
facebook:showDialog( action, params )
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