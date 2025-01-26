local version, build, date, tocversion = GetBuildInfo()
local AutoFFA = CreateFrame("Frame")
local timerEnd = 0
local is112 = string.find(version, "^1.12")

if (is112) then
	--[[
	The 1.12 API is stupid
		
	SetLootMethod triggers PARTY_MEMBERS_CHANGED which creates an infinite loop.
	This also makes it so you can't ever change the loot type manually.
	
	The seemingly logical workaround of using the PARTY_LOOT_METHOD_CHANGED event
	also fails because changing group members also triggers this event for some
	stupid reason.
	
	If someone really wants to extend this functionality in 1.12, you could just
	manage the loot type within the addon.
	
	]]
	--1.12
	AutoFFA:RegisterEvent("PARTY_MEMBERS_CHANGED")
	AutoFFA:SetScript("OnEvent", function()
		if (event == "PARTY_MEMBERS_CHANGED") then
			if (ignorePartyEvent == false) then
				timerEnd = GetTime() + 2;
				this:SetScript("OnUpdate", function()
					if (timerEnd < GetTime()) then
						-- SetLootMethod triggers PARTY_MEMBERS_CHANGED so check to prevent infinite loop
						if (GetLootMethod() ~= "freeforall") then
							SetLootMethod("freeforall")
						end
						this:SetScript("OnUpdate", nil)
					end
				end)
			end
		end
	end)
else
	--1.14
	AutoFFA:RegisterEvent("GROUP_FORMED")
	AutoFFA:SetScript("OnEvent", function(self, event, ...)
		if (event == "GROUP_FORMED") then
			if (UnitIsGroupLeader("player") == true) then
				SetLootMethod("freeforall")
			end
		end
	end)
end