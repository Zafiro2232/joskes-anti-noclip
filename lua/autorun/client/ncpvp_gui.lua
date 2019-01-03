local function NCPVPGui()
    local NCBG = vgui.Create("DFrame")
    NCBG:SetPos(ScrW() / 2 - 250, ScrH() / 2 - 100)
    NCBG:SetSize(500, 200)
    NCBG:SetTitle("")
    NCBG:SetDraggable(false)
    NCBG:ShowCloseButton(false)
    NCBG:MakePopup()

    NCBG.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(58, 68, 78))
    end

    local MDBG = vgui.Create("DFrame", NCBG)
    MDBG:SetPos(15, 50)
    MDBG:SetSize(300, 30)
    MDBG:SetTitle("")
    MDBG:ShowCloseButton(false)
    MDBG:SetDraggable(false)

    MDBG.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(78, 88, 98))
    end

    local MDT = vgui.Create("DFrame", NCBG)
    MDT:SetPos(15, 75 + 15)
    MDT:SetSize(300, 100)
    MDT:ShowCloseButton(false)
    MDT:SetDraggable(false)
    MDT:SetTitle("")

    MDT.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(78, 88, 98))
    end

    local MDTL = vgui.Create("DLabel", NCBG)
    MDTL:SetPos(20, 75 + 15)
    MDTL:SetSize(300, 15)
    MDTL:SetText("Damage isn't allowed to be inflicted in noclip.")
    local ModeSli = vgui.Create("DNumSlider", NCBG)
    ModeSli:SetPos(30, 15)
    ModeSli:SetSize(300, 100)
    ModeSli:SetText("Mode")
    ModeSli:SetMin(0)
    ModeSli:SetMax(4)
    ModeSli:SetValue(1)
    ModeSli:SetDecimals(0)

    ModeSli.Think = function(self)
        if self:IsEditing() then
            local SLV = math.Round(self:GetValue())
            SLVV = SLV

            if SLV == 0 then
                MDTL:SetText("Damage is allowed to be inflicted in noclip.")
            elseif SLV == 1 then
                MDTL:SetText("Damage isn't allowed to be inflicted in noclip.")
            elseif SLV == 2 then
                MDTL:SetText("Attacker will be forced to walk after inflicting damage.")
            elseif SLV == 3 then
                MDTL:SetText("Attacker will be forced to walk and damage will be mitigated.")
            elseif SLV == 4 then
                MDTL:SetText("Attacker will be slain and damage will be mitigated.")
            end
        end
    end

    local HDR = vgui.Create("DLabel", NCBG)
    HDR:SetPos(0, 0)
    HDR:SetSize(470, 30)
    HDR:SetText("                                                                       Noclip PVP Menu")
    HDR:SetTextColor(Color(255, 255, 255))

    HDR.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(78, 88, 98))
    end

    local NTFYC = vgui.Create("DCheckBoxLabel", NCBG)
    NTFYC:SetPos(330, 75)
    NTFYC:SetText("Send messages to players.")
    NTFYC:SetValue(1)
    local AAC = vgui.Create("DCheckBoxLabel", NCBG)
    AAC:SetPos(330, 100)
    AAC:SetText("Allow admins to bypass.")
    AAC:SetValue(1)
    local ASAC = vgui.Create("DCheckBoxLabel", NCBG)
    ASAC:SetPos(330, 50)
    ASAC:SetText("Allow superadmins to bypass.")
    ASAC:SetValue(1)
    local XIT = vgui.Create("DButton", NCBG)
    XIT:SetPos(500 - 30, 0)
    XIT:SetSize(30, 30)
    XIT:SetText("✘")
    XIT:SetTextColor(Color(255, 255, 255))

    XIT.DoClick = function()
        NCBG:AlphaTo(0, 1, 0)

        if ASAC:GetChecked() then
            ASACV = 1
        else
            ASACV = 0
        end

        if AAC:GetChecked() then
            AACV = 1
        else
            AACV = 0
        end

        if NTFYC:GetChecked() then
            NTFYCV = 1
        else
            NTFYCV = 0
        end

        timer.Simple(1, function()
            NCBG:Remove()
            net.Start("NCPVP-NetBridge")

            NetTable = {
                ["clientdata"] = {
                    ["modecv"] = SLVV,
                    ["allowadminscv"] = AACV,
                    ["allowsadminscv"] = ASACV,
                    ["notifycv"] = NTFYCV
                }
            }

            net.WriteTable(NetTable)
            net.SendToServer()
        end)
    end

    XIT.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(78, 88, 98))
    end
end

net.Receive("NCPVPGui-Open", function(len, ply)
    NCPVPGui()
end)

net.Receive("NCPVP-NetNotify", function(len,ply)
    local damage = net.ReadInt(32)
	local target = net.ReadEntity()
	local tcolor = team.GetColor(target:Team())
	if target:IsPlayer() then
		chat.AddText( Color(58,68,78),"NCPVP | ",Color( 78, 88, 98), tostring(damage), " damage was mitigated from ", Color(tcolor.r,tcolor.g,tcolor.b,tcolor.a) , target:Nick(), Color(78,88,98),  ", leave noclip to do damage."  )
	end
end)