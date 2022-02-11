# Connect / Disconnect Announcer With Sounds (3.0.0)
https://forums.alliedmods.net/showthread.php?t=336293

![alt text](https://github.com/oqyh/Connect-Announcer-With-Sounds/blob/main/images/connect.png?raw=true)

![alt text](https://github.com/oqyh/Connect-Announcer-With-Sounds/blob/main/images/disconnect.png?raw=true)


## .:[ Colors ]:.
```
"{default}", "{darkred}", "{green}", "{lightgreen}", "{blue}", "{olive}", "{lime}", "{lightred}", "{purple}", "{grey}", "{yellow}", "{orange}", "{bluegrey}", "{lightblue}", "{darkblue}", "{grey2}", "{orchid}", "{lightred2}"
```


## .:[ ConVars ]:.
```
// Connect/Disconnect Announcer Version
cd_announcer_version "3.0.0"

// country name print type 1 = print shortname, 2 = print full name(Def 1)
cd_country_type "2"

// location of the log file relative to the sourcemod folder
cd_logfile "data/cd_logs.log"

// turns on and off logging of connects and disconnect to a log file 1= on  2 = on only log annoucers 0 = off (Def 1)
cd_loggin "1"

// 1 = by SteamId, 2 = by Ip, 3 = ip and SteamId, 4 = No ip and SteamId (Def 1)
cd_mode "1"

// 1 = by SteamId, 2 = by Ip, 3 = ip and SteamId, 4 = No ip and SteamId (Def 1)
cd_mode_log "1"

// turns on/off priting country names 0 = off, 1= on (Def 1)
cd_printcountry "1"

// Shows Admins on connect/disconnect, 0= don't show, 1 = show (Def 1)
cd_showadmins "1"

// 1 = show all(connects, and disconnects), 2 = show connects only, 3 = show disconnects only
cd_showall "1"

// Toggles connect sound 1 = on || 0 = off
cd_sound_connect "1"

// Toggles disconnect sound 1 = on || 0 = off
cd_sound_disconnect "1"

// Sound file location to be played on a connect under the sounds directory (Def =buttons/blip1.wav)
connect_sound_file "gold_kingz/joingame.mp3"

// Sound file location to be played on a disconnect under the sounds directory (Def =buttons/blip1.wav)
disconnect_sound_files "gold_kingz/leftgame.mp3"
```


## .:[ Change Log ]:.
```
-Fix Errors.
-Fix Download and Precach.
-Sourcemod 1.10+.
-Added Colors.
-Added 2 Sounds For Connect And For Disconnect.
```
