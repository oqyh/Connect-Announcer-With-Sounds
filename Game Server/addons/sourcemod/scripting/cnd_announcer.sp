#include <sourcemod>
#include <sdktools_sound>
#include <multicolors>
#include <sdktools>
#include <sdkhooks>
#include <clientprefs>

#include "geoip.inc"

#pragma semicolon 1

#define CD_VERSION "3.0.1"

ConVar ConnectMessage;
ConVar DisconnectMessage;
new Handle:PrintMode		= INVALID_HANDLE;
new Handle:PrintModeLog		= INVALID_HANDLE;
new Handle:ShowAll 		= INVALID_HANDLE;
new Handle:Sound		= INVALID_HANDLE;
new Handle:Sound2		= INVALID_HANDLE;
new Handle:PrintCountry		= INVALID_HANDLE;
new Handle:ShowAdmins		= INVALID_HANDLE;
new Handle:CountryNameType	= INVALID_HANDLE;
new Handle:ConnectSound		= INVALID_HANDLE;
new Handle:DisconnectSound		= INVALID_HANDLE;
new Handle:Logging		= INVALID_HANDLE;
new Handle:LogFile		= INVALID_HANDLE;
new Handle:g_hFile			= INVALID_HANDLE;
new log = -1;


public Plugin:myinfo = 
{
	name = "Connect And Disconnect Announcer",
	author = "Gold_KingZ, Fredd",
	description = "Connect And Disconnect Announcer With Sounds",
	version = CD_VERSION,
	url = "https://steamcommunity.com/id/oQYh"
}

public OnPluginStart()
{
	LoadTranslations( "cnd_announcer.phrases" );
	CreateConVar( "cnd_announcer_version", CD_VERSION, "Connect And Disconnect Announcer With Sounds");
	
	ConnectMessage = CreateConVar("cnd_connect_messages", "1", "Remove Default Connect Messages || 1= Yes || 0= No");
	DisconnectMessage = CreateConVar("cnd_disconnect_messages", "1", "Remove Default Disconnect Messages || 1= Yes || 0= No");
	PrintMode	=	CreateConVar( "cnd_mode", 	"1",	"1 = by SteamId, 2 = by Ip, 3 = ip and SteamId, 4 = No ip and SteamId (Def 1)",0, true, 1.0, true, 4.0);
	PrintModeLog	=	CreateConVar( "cnd_mode_log", 	"1",	"1 = by SteamId, 2 = by Ip, 3 = ip and SteamId, 4 = No ip and SteamId (Def 1)",0, true, 1.0, true, 4.0);
	ShowAll		= 	CreateConVar( "cnd_showall",	"1",	"1 = show all(connects, and disconnects), 2 = show connects only, 3 = show disconnects only",0, true, 1.0, true, 3.0);
	PrintCountry	=	CreateConVar( "cnd_printcountry", "1",	"priting country names || 1= Yes || 0= No",0, true, 0.0, true, 1.0);
	ShowAdmins	= 	CreateConVar( "cnd_showadmins", 	"1",	"Shows Admins on connect/disconnect || 1= Show || 0= Dont Show",0, true, 0.0, true, 1.0);
	CountryNameType =	CreateConVar( "cnd_country_type","1",	"country name print type || 1= print shortname || 2= print full name",0, true, 1.0, true, 2.0);
	Sound		=	CreateConVar( "cnd_sound_connect", 	"1",	"Toggles connect sound || 1= Yes || 0= No" ,0, true, 0.0, true, 1.0);
	ConnectSound	=	CreateConVar( "cnd_connect_sound_file",	"gold_kingz/joingame.mp3","Sound location When Someone Connect To The Server" );
	Sound2		=	CreateConVar( "cnd_sound_disconnect", 	"1",	"Toggles disconnect sound || 1= Yes || 0= No" ,0, true, 0.0, true, 1.0);
	DisconnectSound	=	CreateConVar( "cnd_disconnect_sound_files",	"gold_kingz/leftgame.mp3","Sound location When Someone Disonnect To The Server" );
	Logging		=	CreateConVar( "cnd_loggin",	"1",	"logging of connects and disconnect to a log file || 0= Off || 1= On || 2= On only log annoucers",0, true, 0.0, true, 2.0);
	LogFile		=	CreateConVar( "cnd_logfile",	"data/cnd_logs.log", "location of the log file relative to the sourcemod folder" );
	
	HookConVarChange(Logging, IsLogging);
	
	HookEvent("player_connect", Event_PlayerConnect, EventHookMode_Pre);
	HookEvent("player_disconnect", Event_PlayerDisconnect, EventHookMode_Pre);
	
	AutoExecConfig(true, "cnd_announcer");
}

public IsLogging(Handle:convar, const String:oldValue[], const String:newValue[])
{
	log = StringToInt(newValue);
	LogOnOff();
}

public Action Event_PlayerConnect(Event event, const char[] name, bool dontBroadcast)
{
	if(ConnectMessage.BoolValue)
	{
		event.BroadcastDisabled = true;
	}
	
	return Plugin_Continue;
}

public Action Event_PlayerDisconnect(Event event, const char[] name, bool dontBroadcast)
{
	if(DisconnectMessage.BoolValue)
	{
		event.BroadcastDisabled = true;
	}
	
	return Plugin_Continue;
}

public LogOnOff()
{
	decl String:Time[21];
	FormatTime(Time, sizeof(Time), "%m/%d/%y - %I:%M:%S", -1) ;

	if (log > 0) {
		if(g_hFile != INVALID_HANDLE) return;

		decl String:iLogFileLoc[PLATFORM_MAX_PATH];

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

public OnConfigsExecuted()
{
	if(log == -1) {
		log = GetConVarInt(Logging);
		LogOnOff();
	}
}

public OnMapStart()
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

public OnPluginEnd()
{
	log = 0;
	LogOnOff();
}

public WriteLogConnect(String:Time[], String:gName[], String:gCountry[], String:gAuth[], String:gIp[])
{
	switch(GetConVarInt(PrintModeLog)) {
		case 1: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: WriteFileLine(g_hFile,"[%s] %s[%s] connected", Time, gName, gAuth);
				case 1: WriteFileLine(g_hFile,"[%s] %s(%s)[%s] connected", Time, gName, gCountry, gAuth);
			}	
		}
		case 2: {	
			switch(GetConVarInt(PrintCountry)) {
				case 0: WriteFileLine(g_hFile,"[%s] %s[%s] connected", Time, gName, gIp);
				case 1: WriteFileLine(g_hFile,"[%s] %s(%s)[%s] connected", Time, gName, gCountry, gIp);
			}	
		}
		case 3: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: WriteFileLine(g_hFile,"[%s] %s[%s][%s] connected", Time, gName, gAuth, gIp);
				case 1: WriteFileLine(g_hFile,"[%s] %s(%s)[%s][%s] connected", Time, gName, gCountry, gAuth, gIp);
			}
		}
		case 4: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: WriteFileLine(g_hFile,"[%s] %s connected", Time, gName);
				case 1: WriteFileLine(g_hFile,"[%s] %s(%s) connected", Time, gName, gCountry);
			}
		}
	}
        FlushFile(g_hFile);
}

public PrintLogConnect(String:Time[], String:gName[], String:gCountry[], String:gAuth[], String:gIp[])
{
	switch(GetConVarInt(PrintMode)) {
		case 1: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: CPrintToChatAll("%t", "Connected_Auth_1", gName, gAuth);
				case 1: CPrintToChatAll("%t", "Connected_Auth_2", gName, gCountry, gAuth);
			}	
		}
		case 2:	{	
			switch(GetConVarInt(PrintCountry)) {
				case 0: CPrintToChatAll("%t", "Connected_Ip_1", gName, gIp);
				case 1: CPrintToChatAll("%t", "Connected_Ip_2", gName, gCountry, gIp);
			}	
		}
		case 3: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: CPrintToChatAll("%t", "Connected_1", gName, gAuth, gIp);
				case 1: CPrintToChatAll("%t", "Connected_2", gName, gCountry, gAuth, gIp);
			}
		}
		case 4: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: CPrintToChatAll("%t", "Connected_Country_1", gName);
				case 1: CPrintToChatAll("%t", "Connected_Country_2", gName, gCountry);
			}
		}
	}
}

public OnClientPostAdminCheck(client)
{
	if(IsFakeClient(client)) return;
	if(GetConVarInt(ShowAll) == 3) return;
	
	decl String:Time[21],
	     String:iFiles[PLATFORM_MAX_PATH],
		 String:gCountry[46],
	     String:gName[MAX_NAME_LENGTH+1],
		 String:gIp[16],
		 String:gAuth[21];
	
	if(GetUserAdmin(client) != INVALID_ADMIN_ID && GetConVarInt(ShowAdmins) == 0) return;

	GetConVarString(ConnectSound, iFiles, sizeof(iFiles));	
	GetClientName(client, gName, MAX_NAME_LENGTH);
	GetClientIP(client, gIp, sizeof(gIp));
	GetClientAuthId(client, AuthId_Steam2, gAuth, sizeof(gAuth));
	
	switch(GetConVarInt(CountryNameType))
	{
		case 1: {
                        decl String:gCountryS[3];
			GeoipCode2(gIp, gCountryS);
			strcopy(gCountry,46,gCountryS);
		}
		case 2: {
			GeoipCountry(gIp, gCountry, sizeof(gCountry));
		}
	}
	
	if(strlen(gCountry) == 0) Format(gCountry,sizeof(gCountry),"%t","Network");
	
	FormatTime(Time, sizeof( Time ), "%m/%d/%y - %I:%M:%S", -1);

	if(GetConVarInt(Sound) == 1) EmitSoundToAll(iFiles);
			
	switch(log) {
		case 0: PrintLogConnect(Time, gName, gCountry, gAuth, gIp);
		case 1: {
			PrintLogConnect(Time, gName, gCountry, gAuth, gIp);
			WriteLogConnect(Time, gName, gCountry, gAuth, gIp);
			}
		case 2:	WriteLogConnect(Time, gName, gCountry, gAuth, gIp);
	}
}

public PrintLogDisconnect(String:Time[], String:gName[], String:gCountry[], String:gAuth[], String:gIp[])
{
	switch(GetConVarInt(PrintMode)) {
		case 1: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: CPrintToChatAll("%t", "Disconnected_Auth_1", gName, gAuth);
				case 1: CPrintToChatAll("%t", "Disconnected_Auth_2", gName, gCountry, gAuth);
			}	
		}
		case 2:	{	
			switch(GetConVarInt(PrintCountry)) {
				case 0: CPrintToChatAll("%t", "Disconnected_Ip_1", gName, gIp);
				case 1: CPrintToChatAll("%t", "Disconnected_Ip_2", gName, gCountry, gIp);
			}	
		}
		case 3: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: CPrintToChatAll("%t", "Disconnected_1", gName, gAuth, gIp);
				case 1: CPrintToChatAll("%t", "Disconnected_2", gName, gCountry, gAuth, gIp);
			}
		}
		case 4: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: CPrintToChatAll("%t", "Disconnected_Country_1", gName);
				case 1: CPrintToChatAll("%t", "Disconnected_Country_2", gName, gCountry);
			}
		}
	}
}

public WriteLogDisconnect(String:Time[], String:gName[], String:gCountry[], String:gAuth[], String:gIp[])
{
	switch(GetConVarInt(PrintModeLog)) {
		case 1: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: WriteFileLine(g_hFile,"[%s] %s[%s] disconnected", Time, gName, gAuth);
				case 1: WriteFileLine(g_hFile,"[%s] %s(%s)[%s] disconnected", Time, gName, gCountry, gAuth);
			}	
		}
		case 2:	{	
			switch(GetConVarInt(PrintCountry)) {
				case 0: WriteFileLine(g_hFile,"[%s] %s[%s] disconnected", Time, gName, gIp);
				case 1: WriteFileLine(g_hFile,"[%s] %s(%s)[%s] disconnected", Time, gName, gCountry, gIp);
			}	
		}
		case 3: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: WriteFileLine(g_hFile,"[%s] %s[%s][%s] disconnected", Time, gName, gAuth, gIp);
				case 1: WriteFileLine(g_hFile,"[%s] %s(%s)[%s][%s] disconnected", Time, gName, gCountry, gAuth, gIp);
			}
		}
		case 4: {
			switch(GetConVarInt(PrintCountry)) {
				case 0: WriteFileLine(g_hFile,"[%s] %s disconnected", Time, gName);
				case 1: WriteFileLine(g_hFile,"[%s] %s(%s) disconnected", Time, gName, gCountry);
			}
		}
	}
	FlushFile(g_hFile);
}

public OnClientDisconnect(client)
{
	if(IsFakeClient(client)) return;
	if(GetConVarInt(ShowAll) == 2) return;
	
	decl String:Time[21],
	     String:iFile[PLATFORM_MAX_PATH],
             String:gCountry[46],
	     String:gName[MAX_NAME_LENGTH+1],
	     String:gIp[16],
	     String:gAuth[21];
	
	if(GetUserAdmin(client) != INVALID_ADMIN_ID && GetConVarInt(ShowAdmins) == 0) return;

	GetConVarString(DisconnectSound, iFile, sizeof(iFile));	
	GetClientName(client, gName, MAX_NAME_LENGTH);
	GetClientIP(client, gIp, sizeof(gIp));
	GetClientAuthId(client, AuthId_Steam2, gAuth, sizeof(gAuth));
	
	switch(GetConVarInt(CountryNameType))
	{
		case 1: {
                        decl String:gCountryS[3];
			GeoipCode2(gIp, gCountryS);
			strcopy(gCountry,46,gCountryS);
		}
		case 2: {
			GeoipCountry(gIp, gCountry, sizeof(gCountry));
		}
	}
	
	if(strlen(gCountry) == 0) Format(gCountry,sizeof(gCountry),"%t","Network");

	FormatTime(Time, sizeof( Time ), "%m/%d/%y - %I:%M:%S", -1);

	if(GetConVarInt(Sound2) == 1) EmitSoundToAll(iFile);

	switch(log) {
		case 0: PrintLogDisconnect(Time, gName, gCountry, gAuth, gIp);
		case 1: {
			PrintLogDisconnect(Time, gName, gCountry, gAuth, gIp);
			WriteLogDisconnect(Time, gName, gCountry, gAuth, gIp);
			}
		case 2: WriteLogDisconnect(Time, gName, gCountry, gAuth, gIp);
	}
}
