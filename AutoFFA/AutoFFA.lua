local version, build, date, tocversion = GetBuildInfo()
local AutoFFA = CreateFrame("Frame")
local is112 = string.find(version, "^1.12")

if (is112) then

	local timerEnd = 0
	local isNewParty = true
	
	AutoFFA:RegisterEvent("PARTY_MEMBERS_CHANGED")
	AutoFFA:SetScript("OnEvent", function()
		if (event == "PARTY_MEMBERS_CHANGED") then
		
			local numParty = GetNumPartyMembers()
			local numRaid = GetNumRaidMembers()
			
			-- Record if we leave group.
			if (numParty == 0 and numRaid == 0) then
				isNewParty = true;
			end
			
			if (isNewParty and (numParty > 0 or numRaid > 0)) then
				isNewParty = false;
				
				-- It takes a few seconds for the group to form after trigger.
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