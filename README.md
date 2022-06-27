# [ANY] Connect / Disconnect Announcer With Sounds (3.0.1)
https://forums.alliedmods.net/showthread.php?t=336293

![alt text](https://github.com/oqyh/Connect-Announcer-With-Sounds/blob/main/images/connect.png?raw=true)

![alt text](https://github.com/oqyh/Connect-Announcer-With-Sounds/blob/main/images/disconnect.png?raw=true)


## .:[ Colors ]:.
```
"{default}", "{darkred}", "{green}", "{lightgreen}", "{blue}", "{olive}", "{lime}", "{lightred}", "{purple}", "{grey}", "{yellow}", "{orange}", "{bluegrey}", "{lightblue}", "{darkblue}", "{grey2}", "{orchid}", "{lightred2}"
```


## .:[ ConVars ]:.
```
///////////////////////////////////////////////////////////////////////////////////////////
// Remove Default Connect Messages || 1= Yes || 0= No
cnd_connect_messages "1"

// Remove Default Disconnect Messages || 1= Yes || 0= No
cnd_disconnect_messages "1"
///////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////
// 1 = show all(connects, and disconnects), 2 = show connects only, 3 = show disconnects only
cnd_showall "1"

// 1 = by SteamId, 2 = by Ip, 3 = ip and SteamId, 4 = No ip and SteamId (Def 1)
cnd_mode "1"

// country name print type || 1= print shortname || 2= print full name
cnd_country_type "1"

// priting country names || 1= Yes || 0= No
cnd_printcountry "1"

// Toggles connect sound || 1= Yes || 0= No
cnd_sound_connect "1"

// Sound location When Someone Connect To The Server
cnd_connect_sound_file "gold_kingz/joingame.mp3"

// Toggles disconnect sound || 1= Yes || 0= No
cnd_sound_disconnect "1"

// Sound location When Someone Disonnect To The Server
cnd_disconnect_sound_files "gold_kingz/leftgame.mp3"

// Shows Admins on connect/disconnect || 1= Show || 0= Dont Show
cnd_showadmins "1"
///////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////
// 1 = by SteamId, 2 = by Ip, 3 = ip and SteamId, 4 = No ip and SteamId (Def 1)
cnd_mode_log "1"

// logging of connects and disconnect to a log file || 0= Off || 1= On || 2= On only log annoucers
cnd_loggin "1"

// location of the log file relative to the sourcemod folder
cnd_logfile "data/cnd_logs.log"
///////////////////////////////////////////////////////////////////////////////////////////
```


## .:[ Change Log ]:.
```
(3.0.1)
- Fix Bugs
- Added Remove Default Connect Messages
- Added Remove Default Disonnect Messages

(3.0.0)
- Initial Release
-Fix Errors.
-Fix Download and Precach.
-Sourcemod 1.10+.
-Added Colors.
-Added 2 Sounds For Connect And For Disconnect.
```

## .:[ Donation ]:.

If this project help you reduce time to develop, you can give me a cup of coffee :)

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://paypal.me/oQYh)
