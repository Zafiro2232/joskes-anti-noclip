--[[================================================

				Anti Noclip PVP
				Made By Joske
				Modified and re-uploaded by Linkjay
				@ NigelArmy.com or linkjay1.com
				Made on the 15th of March 2016
				Re-uploaded 2/2/17
				Last modified: 2/2/17 - 1:18 AM PST
--]]--================================================



CreateConVar( "jcmds_noclip_pvpmode", 1, FCVAR_NONE, "The mode, 0 = nocliper can damager other players, 1 = no damage, 2 = disable noclip upon attack, 3 = disable noclip and damage, 4 = slays the noclip pvper" )
CreateConVar( "jcmds_noclip_allowadmins", 1, FCVAR_NONE, "Allows Admins to damage whilst nocliped, 1 = allow, 0 = disallow" )
CreateConVar( "jcmds_noclip_allowsuperadmins", 1, FCVAR_NONE, "Allows SuperAdmins to damage whilst nocliped, 1 = allow, 0 = disallow" )

hook.Add("EntityTakeDamage", "linkantinoclipdmg", function(ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	local mode = GetConVarNumber( "jcmds_noclip_pvpmode" )
	local allowadmins = GetConVarNumber( "jcmds_noclip_allowadmins" )
	local allowsuperadmins = GetConVarNumber( "jcmds_noclip_allowsuperadmins" )

	if allowsuperadmins == 0 then
		allowadmins = 0
	end

	--PrintMessage(1, attacker:GetVehicle():GetClass())

	if mode == 1 then
		if attacker:GetMoveType()==MOVETYPE_NOCLIP and attacker:IsValid() and attacker:IsSuperAdmin() and allowsuperadmins == 1 then -- If ply is superadmin and allow superadmins = 1 then do nothing
			--Nothing here
		elseif attacker:GetMoveType()==MOVETYPE_NOCLIP and attacker:IsValid() and attacker:IsAdmin() and allowadmins == 1 then -- If ply is admin and allow admins = 1 then do nothing
			--Nothing here
		elseif attacker:GetMoveType()==MOVETYPE_NOCLIP then -- If attacker is nocliping, disable attackers damage
			dmginfo:ScaleDamage(0) -- disables damage
		end
	elseif mode == 2 then
		if attacker:GetMoveType()==MOVETYPE_NOCLIP and attacker:IsValid() and attacker:IsSuperAdmin() and allowsuperadmins == 1 then -- If ply is superadmin and allow superadmins = 1 then do nothing
			--Nothing here
		elseif attacker:GetMoveType()==MOVETYPE_NOCLIP and attacker:IsValid() and attacker:IsAdmin() and allowadmins == 1 then -- If ply is admin and allow admins = 1 then do nothing
			--Nothing here
		elseif	attacker:GetMoveType()==MOVETYPE_NOCLIP then -- If attacker is nocliping, turn off attackers noclip but allow the damage
			attacker:SetMoveType(MOVETYPE_WALK) --  turns off noclip
		end
	elseif mode == 3 then
		if attacker:GetMoveType()==MOVETYPE_NOCLIP and attacker:IsValid() and attacker:IsSuperAdmin() and allowsuperadmins == 1 then -- If ply is superadmin and allow superadmins = 1 then do nothing
			--Nothing here
		elseif attacker:GetMoveType()==MOVETYPE_NOCLIP and attacker:IsValid() and attacker:IsAdmin() and allowadmins == 1 then -- If ply is admin and allow admins = 1 then do nothing
			--Nothing here
		elseif attacker:GetMoveType()==MOVETYPE_NOCLIP then -- If attacker is nocliping, turn off attackers noclip and disallow damage whilst nocliped
			attacker:SetMoveType(MOVETYPE_WALK) -- turns off noclip
			dmginfo:ScaleDamage(0) -- disables damage
		end
	elseif mode == 4 then
		if attacker:GetMoveType()==MOVETYPE_NOCLIP and attacker:IsValid() and attacker:IsSuperAdmin() and allowsuperadmins == 1 then -- If ply is superadmin and allow superadmins = 1 then do nothing
			--Nothing here
		elseif attacker:GetMoveType()==MOVETYPE_NOCLIP and attacker:IsValid() and attacker:IsAdmin() and allowadmins == 1 then -- If ply is admin and allow admins = 1 then do nothing
			--Nothing here
		elseif attacker:GetMoveType()==MOVETYPE_NOCLIP then 
			dmginfo:ScaleDamage(0) -- disables damage
			timer.Simple( 0.1, function() attacker:KillSilent() -- Slays player
				attacker:SendLua( "chat.AddText( Color( 0, 255, 0), '[JCMDS] ', Color( 0, 255, 255 ), 'You were slayed for pvping whilst in noclip')" ) -- notifies player
			end)
		end
	end
end)

hook.Add("PlayerEnteredVehicle", "linkantinoclipseatfix", function(ply, vehicle, role)
	ply:SetMoveType(MOVETYPE_WALK)
end)


-- Credits Command
concommand.Add( "jcmds_noclip_credits", function( ply )
	ply:SendLua( "chat.AddText( Color( 0, 255, 0), '[JCMDS] ', Color( 0, 255, 255 ), [[Joske's Anti Noclip PVP Made By]])") 
	ply:SendLua( "chat.AddText( Color( 0, 255, 0), '[JCMDS] ', Color( 0, 255, 255 ), 'Joske @ nigelarmy.com on the 15th of March, 2016')") 	
	ply:SendLua( "chat.AddText( Color( 0, 255, 0), '[JCMDS] ', Color( 0, 255, 255 ), 'Modified and re-uploaded by')") 	
	ply:SendLua( "chat.AddText( Color( 0, 255, 0), '[JCMDS] ', Color( 0, 255, 255 ), 'Linkjay @ linkjay1.com on 2/2/17')") 	
	ply:SendLua( "print( [[Joske's Anti Noclip PVP Made By \n Joske @ nigelarmy.com \n on the 15th of March, 2016 \n Modified and re-uploaded by \n Linkjay @ linkjay1.com on 2/2/17]] )")
end)
