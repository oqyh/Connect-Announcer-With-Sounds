# [ANY] Connect / Disconnect Announcer With Sounds (3.0.2)
https://forums.alliedmods.net/showthread.php?t=336293

### Connect / Disconnect Announcer ( Sound on connect , Sound on disconnect , hide message connect , hide message disconnect , custom sound join leave , custom sound vip flag , support country city ip steamid )

![alt text](https://github.com/oqyh/Connect-Announcer-With-Sounds/blob/main/images/connect.png?raw=true)

![alt text](https://github.com/oqyh/Connect-Announcer-With-Sounds/blob/main/images/disconnect.png?raw=true)


## .:[ ConVars ]:.
```
//////////////////////>>  .;[ Connect/Disconnect Announcer ];.

// Print chat mode || 1= by SteamId || 2= by Ip || 3= ip and SteamId || 4= No ip and SteamId only
cnd_mode "1"

// Connect/disconnect print type  || 1 = Show all(connects, and disconnects) || 2 = Show connects only || 3 = Show disconnects only
cnd_type "1"

// Print chat type || 1= shortcountry only || 2= longcountry only || 3= shortcountry with city || 4= longcountry with city
cnd_print_type "3"

// Print country names || 2= country with city || 1= country only || 0= No country
cnd_print_country "2"

// Shows Admins on connect/disconnect || 1= Yes || 0= No (admins join with no sounds and no print)
cnd_showadmins "1"



//////////////////////>>  .;[ Sounds ];.

// Toggles connect sound || 1= Yes || 0= No
cnd_sound_connect "1"

// Sound location When Someone Connect To The Server
cnd_connect_sound_file "gold_kingz/joingame.mp3"

// Toggles disconnect sound || 1= Yes || 0= No
cnd_sound_disconnect "1"

// Sound location When Someone Disonnect To The Server
cnd_disconnect_sound_files "gold_kingz/leftgame.mp3"

// Toggles connect and disconnect sound for custom flag only || 1= Yes || 0= No (everyone)
cnd_enable_only_flag "0"

// If cnd_enable_only_flag 1 which flag is it
cnd_sound_flag "t"



//////////////////////>>  .;[ Logs ];.

// Logging of connects and disconnect to a log file || 0= Off || 1= On || 2= On only log annoucers
cnd_loggin "0"

// Log mode || 1= by SteamId || 2= by Ip || 3= ip and SteamId || 4= No ip and SteamId only
cnd_mode_log "1"

// Location of the log file relative to the sourcemod folder
cnd_logfile "data/cnd_logs.log"



//////////////////////>>  .;[ Misc ];.

// Remove Default Connect Messages || 1= Yes || 0= No
cnd_connect_messages "1"

// Remove Default Disconnect Messages || 1= Yes || 0= No
cnd_disconnect_messages "1"
```


## .:[ Custom Sound ]:.
```
follow these steps to avoid bug custom sound

1- first take mp3 file and converter the file to 128kbps here is example site [[url]https://online-audio-converter.com][/url]

2- after convert check Bit rate by Rightclick on Mp3 > Properties  > Details 
[IMG]https://github.com/oqyh/Connect-Announcer-With-Sounds/blob/main/images/images.png?raw=true[/IMG]

3- upload mp3 to game server and fastdl
```


## .:[ Change Log ]:.
```
(3.0.2)
- Fix Bugs
- New Syntax
- Added city support
- Added custom sound for custom flag vip
- fix cnd_sound_connect and cnd_sound_disconnect if disable will not download sounds

(3.0.1)
- Fix Bugs
- Added Remove Default Connect Messages
- Added Remove Default Disonnect Messages

(3.0.0)
- Initial Release
- Fix Errors.
- Fix Download and Precach.
- Sourcemod 1.10+.
- Added Colors.
- Added 2 Sounds For Connect And For Disconnect.
```

## .:[ Donation ]:.

If this project help you reduce time to develop, you can give me a cup of coffee :)

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://paypal.me/oQYh)
