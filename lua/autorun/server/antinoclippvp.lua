--[[================================================
				Anti Noclip PVP - Joske @ nigelarmy.com
				Modified & re-uploaded - Linkjay @ linkjay.com
				Originated 3/15/16
				Re-uploaded 2/2/17
				V2 - Zafiro#2602 - 1/2/19 12PM - 1/3/19 5AM
				Last modified: 1/3/19 
--]]
--================================================
local SH = "ncpvp_"
util.AddNetworkString("NCPVP-NetNotify")
util.AddNetworkString("NCPVP-NetBridge")
util.AddNetworkString("NCPVPGui-Open")

concommand.Add(SH .. "credits", function(ply)
    ply:SendLua("print( [[Joske(nigelarmy.com) - Original Script/Idea, Linkjay(linkjay1.com) - Reupload/Modifications, Zafiro(#2602) - V2 Redux]] )")
end)

local NClip = 8 -- user friendliness 
local antispam = 0
local ncpvp_mode_admins = GetConVar(SH .. "mode_admins")
local ncpvp_mode_sadmins = GetConVar(SH .. "mode_sadmins")
local ncpvp_mode = GetConVar(SH .. "mode")
local ncpvp_notify = GetConVar(SH .. "notify")
CreateConVar(SH .. "notify", 1, FCVAR_NONE, "Pass 0 to turn off messages, 1 to turn on")
CreateConVar(SH .. "mode", 1, FCVAR_NONE, "NCPVP Modes, 0 = Attacker can damage other players, 1 = Prevent Damage, 2 = Disable noclip upon attacking, 3 = Disable noclip and damage upon attacking, 4 = Slay attacker")
CreateConVar(SH .. "mode_admins", FCVAR_NONE, "Allows Admins to damage whilst nocliped, 1 = allow, 0 = disallow")
CreateConVar(SH .. "mode_sadmins", 1, FCVAR_NONE, "Allows SuperAdmins to damage whilst nocliped, 1 = allow, 0 = disallow")
hook.Add("EntityTakeDamage", "NCPVPScale", function(ent, dmginfo)
	local notify = ncpvp_notify:GetInt()
	local mode = ncpvp_mode:GetInt()
	local NetDMG = dmginfo:GetDamage()
	local allowadmins = ncpvp_mode_admins:GetInt()
	local allowsuperadmins = ncpvp_mode_sadmins:GetInt()
	local att = dmginfo:GetAttacker()

	local function NCSendMsg()
		antispam = 1

		timer.Simple(1, function()
			antispam = 0
		end)

		net.Start("NCPVP-NetNotify")
		net.WriteInt(NetDMG, 32)
		net.WriteEntity(ent)
		net.Send(dmginfo:GetAttacker())
    end
    if mode == 1 && att:IsPlayer() && att:IsValid() &&  !att:InVehicle() && att:GetMoveType() == NClip then
        if att:IsSuperAdmin() && allowsuperadmins == 0 || !att:IsSuperAdmin() && att:IsAdmin() && allowadmins == 0 then
            dmginfo:ScaleDamage(0)

            if ent:IsPlayer() && antispam == 0 && notify == 1 then
                NCSendMsg()
            end
        end

        if !att:IsAdmin() || !att:IsSuperAdmin() then
            if att:IsAdmin() then
            else
                dmginfo:ScaleDamage(0)

                if ent:IsPlayer() && antispam == 0 && notify == 1 then
                    NCSendMsg()
                end
            end
        end
    end

    if mode == 2 && att:IsPlayer() && ent:IsPlayer() && att:IsValid() && !att:InVehicle() && att:GetMoveType() == NClip then
        if att:IsSuperAdmin() && allowsuperadmins == 0 || !att:IsSuperAdmin() && att:IsAdmin() && allowadmins ~= 1 then
            att:SetMoveType(2)

            if ent:IsPlayer() && antispam == 0 && notify == 1 then
                NCSendMsg()
            end
        end

        if !att:IsAdmin() || !att:IsSuperAdmin() then
            if att:IsAdmin() then
            else
                att:SetMoveType(2)
            end
        end
    end

    if mode == 3 && att:IsPlayer() && ent:IsPlayer() && att:IsValid() &&  !att:InVehicle() && att:GetMoveType() == NClip then
        if att:IsSuperAdmin() && allowsuperadmins == 0 ||  !att:IsSuperAdmin() && att:IsAdmin() && allowadmins ~= 1 then
            dmginfo:ScaleDamage(0)
            att:SetMoveType(2)

            if ent:IsPlayer() && antispam == 0 && notify == 1 then
                NCSendMsg()
            end
        elseif  !att:IsAdmin() ||  !att:IsSuperAdmin() then
            if att:IsAdmin() then
            else
                dmginfo:ScaleDamage(0)
                att:SetMoveType(2)

                if ent:IsPlayer() && antispam == 0 && notify == 1 then
                    NCSendMsg()
                end
            end
        end
    end

    if mode == 4 && att:IsPlayer() && ent:IsPlayer() && att:IsValid() &&  !att:InVehicle() && att:GetMoveType() == NClip then
        if att:IsSuperAdmin() && allowsuperadmins == 0 ||  !att:IsSuperAdmin() && att:IsAdmin() && allowadmins ~= 1 then
            dmginfo:ScaleDamage(0) -- disables damage
            att:KillSilent()

            if notify == 1 then
                att:SendLua("chat.AddText( Color( 0, 255, 0), '[NCPVP] ', Color( 0, 255, 255 ), 'You were slayed for pvping while in noclip.')")
            end
        elseif  !att:IsAdmin() ||  !att:IsSuperAdmin() then
            if att:IsAdmin() then
            else
                dmginfo:ScaleDamage(0) -- disables damage
                att:KillSilent()

                if notify == 1 then
                    att:SendLua("chat.AddText( Color( 0, 255, 0), '[NCPVP] ', Color( 0, 255, 255 ), 'You were slayed for pvping while in noclip.')")
                end
            end
        end
    end
end)

concommand.Add(SH .. "menu", function(ply)
    if ply:IsValid() && ply:IsPlayer() && ply:IsSuperAdmin() then
        net.Start("NCPVPGui-Open")
        net.Send(ply)
    else
        ply:PrintMessage(2, "Access Denied.")
        print(ply:Nick() .. "(" .. ply:SteamID() .. " | " .. ply:IPAddress() .. ") tried to access the NCPVP GUI.")
    end
end)

net.Receive("NCPVP-NetBridge", function(len, ply)
    if ply:IsValid() && ply:IsSuperAdmin() then
        local NCN = net.ReadTable()

        for k, v in pairs(NCN.clientdata) do
            if k == "modecv" && v ~= nil then
                ncpvp_mode:SetInt(v)
                print("Set mode to", ncpvp_mode:GetInt())
            end

            if k == "notifycv" && v ~= nil then
                ncpvp_notify:SetInt(v)
                print("Set notify mode to ", ncpvp_notify:GetInt())
            end

            if k == "allowadminscv" && v ~= nil then
                ncpvp_mode_admins:SetInt(v)
                print("Set Admin mode to ", ncpvp_mode_admins:GetInt())
            end

            if k == "allowsadminscv" && v ~= nil then
                ncpvp_mode_sadmins:SetInt(v)
                print("Set SuperAdmin mode to ", ncpvp_mode_sadmins:GetInt())
            end
        end
    end
end)
