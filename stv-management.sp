/*
    STV Management - SourceTV Management Plugin for SourceMod
    Copyright (C) 2024  Shigbeard <shigbeard@triumphtf2.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

#include <sourcemod>
#include <sdktools>
#include <sourcetvmanager>

public Plugin myinfo =
{
    name = "STV Management",
    author = "Shigbeard",
    description = "Provides SourceTV Management tools for server administrators.",
    version = "1.3",
    url = "https://triumphtf2.com/"
};

// Define vars
ConVar g_bLockDown;

public void OnPluginStart()
{
    g_bLockDown = CreateConVar("sm_stv_lockdown", "0", "Locks down the server to prevent future SourceTV clients from connecting, even with the correct password", FCVAR_NOTIFY, true, 0.0, true, 1.0);
    RegServerCmd("tv_kick", Cmd_KickSTVClient, "Kicks a SourceTV client from the server.", 0);
    RegServerCmd("tv_spectators", Cmd_ListSpectators, "Lists all SourceTV spectators, with correct index for tv_kick", 0);
    RegServerCmd("sm_stv_license", Cmd_License, "Displays the license information for this plugin.", 0);
}

public bool SourceTV_OnSpectatorPreConnect(const char[] name, char password[255], const char[] ip, char rejectReason[255])
{
    bool isLockedDown = GetConVarBool(g_bLockDown);
    if (isLockedDown)
    {
        strcopy(rejectReason, 255, "STV Spectating has been disabled at this time.");
        return false;
    }

    return true;
}

public Action Cmd_KickSTVClient(int args)
{
    if (args < 1)
    {
        ReplyToCommand(0,"Usage: tv_kick <userid> <reason>");
        return Plugin_Handled;
    }
    // if no 2nd argument, set reason to empty string
    char reason[255];
    if (args < 2)
    {
        strcopy(reason, 255, "[STV] Kicked by admin.");
    }
    else
    {
        GetCmdArg(2, reason, sizeof(reason));
    }

    char sIndex[16];
    GetCmdArg(1, sIndex, sizeof(sIndex));
    StripQuotes(sIndex);
    StripQuotes(reason);

    int iTarget = StringToInt(sIndex);
    if (iTarget < 1 || iTarget > SourceTV_GetSpectatorCount())
    {
        ReplyToCommand(0, "Invalid client index: %d", iTarget);
        return Plugin_Handled;
    }
    if (!SourceTV_IsClientConnected(iTarget))
    {
        ReplyToCommand(0, "Client %d is not connected.", iTarget);
        return Plugin_Handled;
    }
    SourceTV_KickClient(iTarget, reason);
    ReplyToCommand(0, "Kicked SourceTV client %d with reason: %s", iTarget, reason);
    return Plugin_Handled;
}

public Action Cmd_ListSpectators(int args)
{
    ReplyToCommand(0, "SourceTV Spectators count: %d/%d", SourceTV_GetSpectatorCount(), SourceTV_GetClientCount());
    char sName[64], sIP[16], sPassword[256];
    for (int i = 1; i<=SourceTV_GetSpectatorCount(); i++)
    {
        if (!SourceTV_IsClientConnected(i))
        {
            continue;
        }
        SourceTV_GetClientName(i, sName, sizeof(sName));
        SourceTV_GetClientIP(i, sIP, sizeof(sIP));
        SourceTV_GetClientPassword(i, sPassword, sizeof(sPassword));
        ReplyToCommand(0, "Client: %d%s Name: %s, IP: %s, Password: %s", i, (SourceTV_IsClientProxy(i)?" (RELAY)":""), sName, sIP, sPassword);
    }
    return Plugin_Handled;
}

public Action Cmd_License(int args)
{
    // Do not change this message, it is required by the GNU GPL v3.0
    ReplyToCommand(0, "STV Management is licensed under the GNU General Public License v3.0. You can view the license here: https://www.gnu.org/licenses/gpl-3.0.html");
    return Plugin_Handled;
}
