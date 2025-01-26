local AutoFFA = CreateFrame("Frame")

function AutoFFA:OnEvent(event, ...)
	if event == "GROUP_FORMED" then
		if (UnitIsGroupLeader("player") == true) then
			SetLootMethod("freeforall")
		end
	end
end

AutoFFA:RegisterEvent("GROUP_FORMED")
AutoFFA:SetScript("OnEvent", AutoFFA.OnEvent)