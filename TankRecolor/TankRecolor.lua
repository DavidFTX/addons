local C = {}
C.Druid   = {1, 0.10, 0.10}
C.Paladin = {1, 0.25, 0.50}
C.Warrior = {1, 0.25, 0.25}

-- Party max health
local TP = {}
TP.Druid = 7700
TP.Paladin = 6200
TP.Warrior = 7500

-- Raid max health
local TR = {}
TR.Druid = 7700
TR.Paladin = 7000
TR.Warrior = 7500

local function UpdateRaidFrameColor(frame)
    if not frame or not frame.unit or not frame.unitExists then return end
	
	local class = UnitClass(frame.unit)
	if not (class == "Druid" or class == "Paladin" or class == "Warrior") then return end

    local unitMaxHealth = UnitHealthMax(frame.unit)
	local triggerHealth = TP[class]
	
	if (IsInRaid()) then
		triggerHealth = TR[class]
	end

    if unitMaxHealth > triggerHealth then
		frame.healthBar:SetStatusBarColor(C[class][1], C[class][2], C[class][3])
	else
		frame.healthBar:SetStatusBarColor(RAID_CLASS_COLORS[string.upper(class)].r, RAID_CLASS_COLORS[string.upper(class)].g, RAID_CLASS_COLORS[string.upper(class)].b)
    end
end

local function UpdateAllRaidFrames()
	for i = 1, GetNumGroupMembers() do
		local unitFrame = _G["CompactRaidFrame" .. i]
		if unitFrame then
			UpdateRaidFrameColor(unitFrame)
		end
	end
end

local function OnEvent(self, event, ...)
    if event == "GROUP_ROSTER_UPDATE" or event == "UNIT_MAXHEALTH" or event == "PLAYER_LOGIN" then
        UpdateAllRaidFrames()
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("UNIT_MAXHEALTH")
frame:RegisterEvent("PLAYER_LOGIN") -- Register for PLAYER_LOGIN event
frame:SetScript("OnEvent", OnEvent)