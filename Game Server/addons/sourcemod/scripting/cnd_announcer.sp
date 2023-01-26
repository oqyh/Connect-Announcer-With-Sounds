#include <sourcemod>
#include <sdktools>
#include <geoip>
#include <multicolors>

#pragma semicolon 1
#pragma newdecls required

ConVar ConnectMessage;
ConVar DisconnectMessage;
ConVar g_cvVipFlags;

Handle PrintMode		= INVALID_HANDLE;
Handle PrintModeLog		= INVALID_HANDLE;
Handle ShowAll 		= INVALID_HANDLE;
Handle Sound		= INVALID_HANDLE;
Handle e_vip_flag		= INVALID_HANDLE;
Handle Sound2		= INVALID_HANDLE;
Handle PrintCountry		= INVALID_HANDLE;
Handle ShowAdmins		= INVALID_HANDLE;
Handle CountryNameType	= INVALID_HANDLE;
Handle ConnectSound		= INVALID_HANDLE;
Handle DisconnectSound		= INVALID_HANDLE;
Handle Logging		= INVALID_HANDLE;
Handle LogFile		= INVALID_HANDLE;
Handle g_hFile			= INVALID_HANDLE;

int log = -1;

public Plugin myinfo = 
{
	name = "Connect And Disconnect Announcer",
	author = "Gold KingZ, Fredd",
	description = "Connect And Disconnect Announcer With Sounds",
	version = "3.0.2",
	url = "https://github.com/oqyh"
}

public void OnPluginStart()
{
	LoadTranslations( "cnd_announcer.phrases" );
	
	ConnectMessage = CreateConVar("cnd_connect_messages", "1", "Remove Default Connect Messages || 1= Yes || 0= No");
	DisconnectMessage = CreateConVar("cnd_disconnect_messages", "1", "Remove Default Disconnect Messages || 1= Yes || 0= No");
	
	PrintMode	=	CreateConVar( "cnd_mode", 	"1",	"Print chat mode || 1= by SteamId || 2= by Ip || 3= ip and SteamId || 4= No ip and SteamId only",0, true, 1.0, true, 4.0);
	ShowAll		= 	CreateConVar( "cnd_type",	"1",	"Connect/disconnect print type  || 1 = Show all(connects, and disconnects) || 2 = Show connects only || 3 = Show disconnects only",0, true, 1.0, true, 3.0);
	CountryNameType =	CreateConVar( "cnd_print_type","3",	"Print chat type || 1= shortcountry only || 2= longcountry only || 3= shortcountry with city || 4= longcountry with city",0, true, 1.0, true, 4.0);
	PrintCountry	=	CreateConVar( "cnd_print_country", "2",	"Print country names || 2= country with city || 1= country only || 0= No country",0, true, 0.0, true, 2.0);
	ShowAdmins	= 	CreateConVar( "cnd_showadmins", 	"1",	"Shows Admins on connect/disconnect || 1= Yes || 0= No (admins join with no sounds and no print)",0, true, 0.0, true, 1.0);

	Sound		=	CreateConVar( "cnd_sound_connect", 	"1",	"Toggles connect sound || 1= Yes || 0= No" ,0, true, 0.0, true, 1.0);
	ConnectSound	=	CreateConVar( "cnd_connect_sound_file",	"gold_kingz/joingame.mp3","Sound location When Someone Connect To The Server" );
	Sound2		=	CreateConVar( "cnd_sound_disconnect", 	"1",	"Toggles disconnect sound || 1= Yes || 0= No" ,0, true, 0.0, true, 1.0);
	DisconnectSound	=	CreateConVar( "cnd_disconnect_sound_files",	"gold_kingz/leftgame.mp3","Sound location When Someone Disonnect To The Server" );
	e_vip_flag		=	CreateConVar( "cnd_enable_only_flag", 	"0",	"Toggles connect and disconnect sound for custom flag only || 1= Yes || 0= No (everyone)" ,0, true, 0.0, true, 1.0);
	g_cvVipFlags = CreateConVar ( "cnd_sound_flag", "t", "If cnd_enable_only_flag 1 which flag is it");
	
	Logging		=	CreateConVar( "cnd_loggin",	"0",	"Logging of connects and disconnect to a log file || 0= Off || 1= On || 2= On only log annoucers",0, true, 0.0, true, 2.0);
	PrintModeLog	=	CreateConVar( "cnd_mode_log", 	"1",	"Log mode || 1= by SteamId || 2= by Ip || 3= ip and SteamId || 4= No ip and SteamId only",0, true, 1.0, true, 4.0);
	LogFile		=	CreateConVar( "cnd_logfile",	"data/cnd_logs.log", "Location of the log file relative to the sourcemod folder" );
	
	HookConVarChange(Logging, IsLogging);
	
	HookEvent("player_connect", Event_PlayerConnect, EventHookMode_Pre);
	HookEvent("player_disconnect", Event_PlayerDisconnect, EventHookMode_Pre);
	
	AutoExecConfig(true, "cnd_announcer");
}

public void IsLogging(Handle convar, const char[] oldValue, const char[] newValue)
{
	log = StringToInt(newValue);
	LogOnOff();
}

public Action Event_PlayerConnect(Event event, const char[] name, bool dontBroadcast)
{
	if(ConnectMessage.BoolValue)
	{
		dontBroadcast = true;
		event.BroadcastDisabled = true;
	}
	return Plugin_Continue;
}

public Action Event_PlayerDisconnect(Event event, const char[] name, bool dontBroadcast)
{
	if(DisconnectMessage.BoolValue)
	{
		dontBroadcast = true;
		event.BroadcastDisabled = true;
	}
	return Plugin_Continue;
}

public void LogOnOff()
{
	char Time[21];
	FormatTime(Time, sizeof(Time), "%m/%d/%y - %I:%M:%S", -1) ;

	if (log > 0) {
		if(g_hFile != INVALID_HANDLE) return;

		char iLogFileLoc[PLATFORM_MAX_PATH];

		GetConVarString( LogFile, iLogFileLoc, sizeof( iLogFileLoc ) );
		BuildPath( Path_SM, iLogFileLoc, sizeof( iLogFileLoc ), iLogFileLoc);
		g_hFile = OpenFile( iLogFileLoc, "a" );
		
		if(g_hFile == INVALID_HANDLE) {
			LogMessage("%t %s","File Not Created",iLogFileLoc );
			log = 0;
			SetConVarInt(Logging,0,false,false);
		}
		else {
			LogMessage("%t","Start Log");
			WriteFileLine(g_hFile,"[%s] %t", Time, "Start Log");
			FlushFile(g_hFile);
		}
	} else {
		if(g_hFile != INVALID_HANDLE) {
			LogMessage("%t", "End Log");
			WriteFileLine(g_hFile,"[%s] %t", Time, "End Log");
			FlushFile(g_hFile);
			CloseHandle(g_hFile);
			g_hFile = INVALID_HANDLE;
		}
	}
}

public void OnConfigsExecuted()
{
	if(log == -1) {
		log = GetConVarInt(Logging);
		LogOnOff();
	}
	
	if(GetConVarInt(Sound2) == 1)
	{
		char iFile[PLATFORM_MAX_PATH];
		GetConVarString(DisconnectSound, iFile, sizeof(iFile));
		if(!StrEqual(iFile, ""))
		{
			char download2[PLATFORM_MAX_PATH];
			Format(download2, sizeof(download2), "sound/%s", iFile);
			AddFileToDownloadsTable(download2);
			PrecacheSound(iFile);
		}
	}
	
	if(GetConVarInt(Sound) == 1)
	{
		char iFiles[PLATFORM_MAX_PATH];
		GetConVarString(ConnectSound, iFiles, sizeof(iFiles));
		if(!StrEqual(iFiles, ""))
		{
			char download[PLATFORM_MAX_PATH];
			Format(download, sizeof(download), "sound/%s", iFiles);
			AddFileToDownloadsTable(download);
			PrecacheSound(iFiles);
		}
	}
}

public void OnPluginEnd()
{
	log = 0;
	LogOnOff();
}

public void WriteLogConnect(const char[] Time, const char[] gName, const char[] gCountry, const char[] gCity, const char[] gAuth, const char[] gIp)
{
	switch(GetConVarInt(PrintModeLog)) {
		case 1: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: WriteFileLine(g_hFile,"[%s] %s[%s] connected", Time, gName, gAuth);
				case 1: WriteFileLine(g_hFile,"[%s] %s(%s)[%s] connected", Time, gName, gCountry, gAuth);
				case 2: {
					if(GetConVarInt(CountryNameType) ==3 || GetConVarInt(CountryNameType) ==4)
					{
						WriteFileLine(g_hFile,"[%s] %s(%s, %s)[%s] connected", Time, gName, gCountry, gCity, gAuth);
					}else
					{
						WriteFileLine(g_hFile,"[%s] %s(%s)[%s] connected", Time, gName, gCountry, gAuth);
					}
				}
			}	
		}
		case 2: {	
			switch(GetConVarInt(PrintCountry)) {
				case 0: WriteFileLine(g_hFile,"[%s] %s[%s] connected", Time, gName, gIp);
				case 1: WriteFileLine(g_hFile,"[%s] %s(%s)[%s] connected", Time, gName, gCountry, gIp);
				case 2: {
					if(GetConVarInt(CountryNameType) ==3 || GetConVarInt(CountryNameType) ==4)
					{
						WriteFileLine(g_hFile,"[%s] %s(%s, %s)[%s] connected", Time, gName, gCountry, gCity, gIp);
					}else
					{
						WriteFileLine(g_hFile,"[%s] %s(%s)[%s] connected", Time, gName, gCountry, gIp);
					}
				}
			}	
		}
		case 3: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: WriteFileLine(g_hFile,"[%s] %s[%s][%s] connected", Time, gName, gAuth, gIp);
				case 1: WriteFileLine(g_hFile,"[%s] %s(%s)[%s][%s] connected", Time, gName, gCountry, gAuth, gIp);
				case 2: {
					if(GetConVarInt(CountryNameType) ==3 || GetConVarInt(CountryNameType) ==4)
					{
						WriteFileLine(g_hFile,"[%s] %s(%s, %s)[%s][%s] connected", Time, gName, gCountry, gCity, gAuth, gIp);
					}else
					{
						WriteFileLine(g_hFile,"[%s] %s(%s)[%s][%s] connected", Time, gName, gCountry, gAuth, gIp);
					}
				}
			}
		}
		case 4: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: WriteFileLine(g_hFile,"[%s] %s connected", Time, gName);
				case 1: WriteFileLine(g_hFile,"[%s] %s(%s) connected", Time, gName, gCountry);
				case 2: {
					if(GetConVarInt(CountryNameType) ==3 || GetConVarInt(CountryNameType) ==4)
					{
						WriteFileLine(g_hFile,"[%s] %s(%s, %s) connected", Time, gName, gCountry, gCity);
					}else
					{
						WriteFileLine(g_hFile,"[%s] %s(%s) connected", Time, gName, gCountry);
					}
				}
			}
		}
	}
	FlushFile(g_hFile);
}

public void PrintLogConnect(const char[] Time, const char[] gName, const char[] gCountry, const char[] gCity, const char[] gAuth, const char[] gIp)
{
	switch(GetConVarInt(PrintMode)) {
		case 1: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: CPrintToChatAll("%t", "Connected_Auth_1", gName, gAuth);
				case 1: CPrintToChatAll("%t", "Connected_Auth_2", gName, gCountry, gAuth);
				case 2: {
					if(GetConVarInt(CountryNameType) ==3 || GetConVarInt(CountryNameType) ==4)
					{
						CPrintToChatAll("%t", "Connected_Auth_3", gName, gCountry, gCity, gAuth);
					}else
					{
						CPrintToChatAll("%t", "Connected_Auth_2", gName, gCountry, gAuth);
					}
				}
			}	
		}
		case 2:	{	
			switch(GetConVarInt(PrintCountry)) {
				case 0: CPrintToChatAll("%t", "Connected_Ip_1", gName, gIp);
				case 1: CPrintToChatAll("%t", "Connected_Ip_2", gName, gCountry, gIp);
				case 2: {
					if(GetConVarInt(CountryNameType) ==3 || GetConVarInt(CountryNameType) ==4)
					{
						CPrintToChatAll("%t", "Connected_Ip_3", gName, gCountry, gCity, gIp);
					}else
					{
						CPrintToChatAll("%t", "Connected_Ip_2", gName, gCountry, gIp);
					}
				}
			}	
		}
		case 3: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: CPrintToChatAll("%t", "Connected_1", gName, gAuth, gIp);
				case 1: CPrintToChatAll("%t", "Connected_2", gName, gCountry, gAuth, gIp);
				case 2: {
					if(GetConVarInt(CountryNameType) ==3 || GetConVarInt(CountryNameType) ==4)
					{
						CPrintToChatAll("%t", "Connected_3", gName, gCountry, gCity, gAuth, gIp);
					}else
					{
						CPrintToChatAll("%t", "Connected_2", gName, gCountry, gAuth, gIp);
					}
				}
			}
		}
		case 4: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: CPrintToChatAll("%t", "Connected_Country_1", gName);
				case 1: CPrintToChatAll("%t", "Connected_Country_2", gName, gCountry);
				case 2: {
					if(GetConVarInt(CountryNameType) ==3 || GetConVarInt(CountryNameType) ==4)
					{
						CPrintToChatAll("%t", "Connected_Country_3", gName, gCountry, gCity);
					}else
					{
						CPrintToChatAll("%t", "Connected_Country_2", gName, gCountry);
					}
				}
			}
		}
	}
}

public void OnClientPostAdminCheck(int client)
{
	if(IsFakeClient(client)) return;
	if(GetConVarInt(ShowAll) == 3) return;
	
	char Time[21],
	    iFiles[PLATFORM_MAX_PATH],
		gCountry[46],
		gCity[46],
	    gName[MAX_NAME_LENGTH+1],
		gIp[16],
		gAuth[21];
	
	if(GetUserAdmin(client) != INVALID_ADMIN_ID && GetConVarInt(ShowAdmins) == 0) return;

	GetConVarString(ConnectSound, iFiles, sizeof(iFiles));	
	GetClientName(client, gName, MAX_NAME_LENGTH);
	GetClientIP(client, gIp, sizeof(gIp));
	GetClientAuthId(client, AuthId_Steam2, gAuth, sizeof(gAuth));
	
	switch(GetConVarInt(CountryNameType))
	{
		case 1: {
			char gCountryS[3];
			GeoipCode2(gIp, gCountryS);
			strcopy(gCountry,46,gCountryS);
		}
		case 2: {
			GeoipCountry(gIp, gCountry, sizeof(gCountry));
		}
		case 3: {
			char gCountryS[3];
			GeoipCode2(gIp, gCountryS);
			GeoipCity(gIp, gCity, sizeof(gCity));
			strcopy(gCountry,46,gCountryS);
		}
		case 4: {
			GeoipCountry(gIp, gCountry, sizeof(gCountry));
			GeoipCity(gIp, gCity, sizeof(gCity));
		}
	}
	
	if(strlen(gCountry) == 0) Format(gCountry,sizeof(gCountry),"%t","UnknowCountry");
	
	if(strlen(gCity) == 0) Format(gCity,sizeof(gCity),"%t","UnknowCity");
	
	FormatTime(Time, sizeof( Time ), "%m/%d/%y - %I:%M:%S", -1);

	if(GetConVarInt(Sound) == 1)
	{
		if(GetConVarInt(e_vip_flag) == 1)
		{
			if(IsUserCustom(client))
			{
				EmitSoundToAll(iFiles);
			}
		}else
		{
			EmitSoundToAll(iFiles);
		}
	}
	
	switch(log) {
		case 0: PrintLogConnect(Time, gName, gCountry, gCity, gAuth, gIp);
		case 1: {
			PrintLogConnect(Time, gName, gCountry, gCity, gAuth, gIp);
			WriteLogConnect(Time, gName, gCountry, gCity, gAuth, gIp);
			}
		case 2:	WriteLogConnect(Time, gName, gCountry, gCity, gAuth, gIp);
	}
}

public void OnClientDisconnect(int client)
{
	if(IsFakeClient(client)) return;
	if(GetConVarInt(ShowAll) == 2) return;
	
	char Time[21],
	    iFile[PLATFORM_MAX_PATH],
        gCountry[46],
		gCity[46],
	    gName[MAX_NAME_LENGTH+1],
	    gIp[16],
	    gAuth[21];
		
	if(GetUserAdmin(client) != INVALID_ADMIN_ID && GetConVarInt(ShowAdmins) == 0) return;

	GetConVarString(DisconnectSound, iFile, sizeof(iFile));	
	GetClientName(client, gName, MAX_NAME_LENGTH);
	GetClientIP(client, gIp, sizeof(gIp));
	GetClientAuthId(client, AuthId_Steam2, gAuth, sizeof(gAuth));
	
	switch(GetConVarInt(CountryNameType))
	{
		case 1: {
			char gCountryS[3];
			GeoipCode2(gIp, gCountryS);
			strcopy(gCountry,46,gCountryS);
		}
		case 2: {
			GeoipCountry(gIp, gCountry, sizeof(gCountry));
		}
		case 3: {
			char gCountryS[3];
			GeoipCode2(gIp, gCountryS);
			GeoipCity(gIp, gCity, sizeof(gCity));
			strcopy(gCountry,46,gCountryS);
		}
		case 4: {
			GeoipCountry(gIp, gCountry, sizeof(gCountry));
			GeoipCity(gIp, gCity, sizeof(gCity));
		}
	}
	
	if(strlen(gCountry) == 0) Format(gCountry,sizeof(gCountry),"%t","UnknowCountry");
	
	if(strlen(gCity) == 0) Format(gCity,sizeof(gCity),"%t","UnknowCity");
	
	FormatTime(Time, sizeof( Time ), "%m/%d/%y - %I:%M:%S", -1);

	if(GetConVarInt(Sound2) == 1)
	{
		if(GetConVarInt(e_vip_flag) == 1)
		{
			if(IsUserCustom(client))
			{
				EmitSoundToAll(iFile);
			}
		}else
		{
			EmitSoundToAll(iFile);
		}
	}
	
	switch(log) {
		case 0: PrintLogDisconnect(Time, gName, gCountry, gCity, gAuth, gIp);
		case 1: {
			PrintLogDisconnect(Time, gName, gCountry, gCity, gAuth, gIp);
			WriteLogDisconnect(Time, gName, gCountry, gCity, gAuth, gIp);
			}
		case 2: WriteLogDisconnect(Time, gName, gCountry, gCity, gAuth, gIp);
	}
}

public void PrintLogDisconnect(const char[] Time, const char[] gName, const char[] gCountry, const char[] gCity, const char[] gAuth, const char[] gIp)
{
	switch(GetConVarInt(PrintMode)) {
		case 1: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: CPrintToChatAll("%t", "Disconnected_Auth_1", gName, gAuth);
				case 1: CPrintToChatAll("%t", "Disconnected_Auth_2", gName, gCountry, gAuth);
				case 2: {
					if(GetConVarInt(CountryNameType) ==3 || GetConVarInt(CountryNameType) ==4)
					{
						CPrintToChatAll("%t", "Disconnected_Auth_3", gName, gCountry, gCity, gAuth);
					}else
					{
						CPrintToChatAll("%t", "Disconnected_Auth_2", gName, gCountry, gAuth);
					}
				}
			}	
		}
		case 2:	{	
			switch(GetConVarInt(PrintCountry)) {
				case 0: CPrintToChatAll("%t", "Disconnected_Ip_1", gName, gIp);
				case 1: CPrintToChatAll("%t", "Disconnected_Ip_2", gName, gCountry, gIp);
				case 2: {
					if(GetConVarInt(CountryNameType) ==3 || GetConVarInt(CountryNameType) ==4)
					{
						CPrintToChatAll("%t", "Disconnected_Ip_3", gName, gCountry, gCity, gIp);
					}else
					{
						CPrintToChatAll("%t", "Disconnected_Ip_2", gName, gCountry, gIp);
					}
				}
			}	
		}
		case 3: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: CPrintToChatAll("%t", "Disconnected_1", gName, gAuth, gIp);
				case 1: CPrintToChatAll("%t", "Disconnected_2", gName, gCountry, gAuth, gIp);
				case 2: {
					if(GetConVarInt(CountryNameType) ==3 || GetConVarInt(CountryNameType) ==4)
					{
						CPrintToChatAll("%t", "Disconnected_3", gName, gCountry, gCity, gAuth, gIp);
					}else
					{
						CPrintToChatAll("%t", "Disconnected_2", gName, gCountry, gAuth, gIp);
					}
				}
			}
		}
		case 4: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: CPrintToChatAll("%t", "Disconnected_Country_1", gName);
				case 1: CPrintToChatAll("%t", "Disconnected_Country_2", gName, gCountry);
				case 2: {
					if(GetConVarInt(CountryNameType) ==3 || GetConVarInt(CountryNameType) ==4)
					{
						CPrintToChatAll("%t", "Disconnected_Country_3", gName, gCountry, gCity);
					}else
					{
						CPrintToChatAll("%t", "Disconnected_Country_2", gName, gCountry);
					}
				}
			}
		}
	}
}

public void WriteLogDisconnect(const char[] Time, const char[] gName, const char[] gCountry, const char[] gCity, const char[] gAuth, const char[] gIp)
{
	switch(GetConVarInt(PrintModeLog)) {
		case 1: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: WriteFileLine(g_hFile,"[%s] %s[%s] disconnected", Time, gName, gAuth);
				case 1: WriteFileLine(g_hFile,"[%s] %s(%s)[%s] disconnected", Time, gName, gCountry, gAuth);
				case 2: {
					if(GetConVarInt(CountryNameType) ==3 || GetConVarInt(CountryNameType) ==4)
					{
						WriteFileLine(g_hFile,"[%s] %s(%s, %s)[%s] disconnected", Time, gName, gCountry, gCity, gAuth);
					}else
					{
						WriteFileLine(g_hFile,"[%s] %s(%s)[%s] disconnected", Time, gName, gCountry, gAuth);
					}
				}
			}	
		}
		case 2:	{	
			switch(GetConVarInt(PrintCountry)) {
				case 0: WriteFileLine(g_hFile,"[%s] %s[%s] disconnected", Time, gName, gIp);
				case 1: WriteFileLine(g_hFile,"[%s] %s(%s)[%s] disconnected", Time, gName, gCountry, gIp);
				case 2: {
					if(GetConVarInt(CountryNameType) ==3 || GetConVarInt(CountryNameType) ==4)
					{
						WriteFileLine(g_hFile,"[%s] %s(%s, %s)[%s] disconnected", Time, gName, gCountry, gCity, gIp);
					}else
					{
						WriteFileLine(g_hFile,"[%s] %s(%s)[%s] disconnected", Time, gName, gCountry, gIp);
					}
				}
			}	
		}
		case 3: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: WriteFileLine(g_hFile,"[%s] %s[%s][%s] disconnected", Time, gName, gAuth, gIp);
				case 1: WriteFileLine(g_hFile,"[%s] %s(%s)[%s][%s] disconnected", Time, gName, gCountry, gAuth, gIp);
				case 2: {
					if(GetConVarInt(CountryNameType) ==3 || GetConVarInt(CountryNameType) ==4)
					{
						WriteFileLine(g_hFile,"[%s] %s(%s, %s)[%s][%s] disconnected", Time, gName, gCountry, gCity, gAuth, gIp);
					}else
					{
						WriteFileLine(g_hFile,"[%s] %s(%s)[%s][%s] disconnected", Time, gName, gCountry, gAuth, gIp);
					}
				}
			}
		}
		case 4: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: WriteFileLine(g_hFile,"[%s] %s disconnected", Time, gName);
				case 1: WriteFileLine(g_hFile,"[%s] %s(%s) disconnected", Time, gName, gCountry);
				case 2: {
					if(GetConVarInt(CountryNameType) ==3 || GetConVarInt(CountryNameType) ==4)
					{
						WriteFileLine(g_hFile,"[%s] %s(%s, %s) disconnected", Time, gName, gCountry, gCity);
					}else
					{
						WriteFileLine(g_hFile,"[%s] %s(%s) disconnected", Time, gName, gCountry);
					}
				}
			}
		}
	}
	FlushFile(g_hFile);
}

bool IsUserCustom ( int client ) {
	
	char szFlags [ 32 ];
	GetConVarString ( g_cvVipFlags, szFlags, sizeof ( szFlags ) );

	AdminId admin = GetUserAdmin ( client );
	if ( admin != INVALID_ADMIN_ID ) {

		int count, found, flags = ReadFlagString ( szFlags );
		for ( int i = 0; i <= 20; i++ ) {

			if ( flags & ( 1<<i ) ) {

				count++;

				if (GetAdminFlag(admin, view_as<AdminFlag>(i))) 
					found++;

			}
		}

		if ( count == found )
			return true;

	}
	return false;
}