BGHelper = LibStub("AceAddon-3.0"):NewAddon("BGHelper","AceConsole-3.0","AceComm-3.0", "AceTimer-3.0")

local BGHelper = _G.BGHelper
local BattleManager = _G.BattleManager
local BGDb = _G.BGDataBase
local BGMainWindow = _G.BGMainWindow

local CreateFrame = CreateFrame

BGHelper.events = CreateFrame("Frame")

BGHelper.events:SetScript("OnEvent", function(self, event, ...)
	if not BGHelper[event] then
		return
	end

	BGHelper[event](BGHelper, ...)
end)


BGHelper.consoleOptions = {
	name = "BGHelper",
	type = 'group',
	args = {
		["start"] = {
			order = 4,
			name = "Start",
			desc = "Start a new battle",
			type = 'execute',
			func = function()
				BGHelper:Start()
			end,
			dialogHidden = true
		},
		["stop"] = {
			order = 5,
			name = "Stop",
			desc = "Stop current battle",
			type = 'execute',
			func = function()
				BGHelper:Stop()
			end,
			dialogHidden = true
		},
		["show"] = {
			order = 12,
			name = "Show",
			desc = "Shows the main window",
			type = 'execute',
			func = function()
				BGHelper.MainWindow:Show()
			end,
			dialogHidden = true
		},
		["hide"] = {
			order = 13,
			name = "Hide",
			desc = "Hide the main window",
			type = 'execute',
			func = function()
				BGHelper.MainWindow:Hide()
			end,
			dialogHidden = true

		},
        ["pp"] = {
			order = 14,
			name = "pp",
			desc = "Shows the main window",
			type = 'execute',
			func = function()
				--local point, relativeTo, relativePoint, xOfs, yOfs = XpTimer.MainWindow.frame:GetPoint()
                --DEFAULT_CHAT_FRAME:AddMessage(point)  "BOTTOMRIGHT"
                --DEFAULT_CHAT_FRAME:AddMessage(relativeTo:GetName())
                --DEFAULT_CHAT_FRAME:AddMessage(relativePoint)
                --DEFAULT_CHAT_FRAME:AddMessage(xOfs)
                --DEFAULT_CHAT_FRAME:AddMessage(yOfs)
                --XpTimer.MainWindow.frame:SetPoint("BOTTOMRIGHT",-13,24)
			end,
			dialogHidden = true
		}
	}
}
function BGHelper:OnUpdate()
	if(not BattleManager.in_battle)then
		return
	end

	local current_time = GetTime()

    if((current_time - BGHelper.last_update_time) < 1 ) then
        return
    end

	BGHelper.last_update_time = current_time

	local current_battle = BattleManager:GetCurrentBattle()
	if(not current_battle)then
		return
	end

	local updata_data = {}
	local my_id = UnitGUID("player")

	if(current_battle:HasPlayer(my_id)) then
		local player_data = current_battle:GetPlayer(my_id)
		updata_data.kd = string.format("%d/%d",player_data.kill_num,player_data.death_num)
		updata_data.dmage = tostring(player_data.dmage)
		updata_data.heal = tostring(player_data.heal)
		updata_data.taken_dmage = tostring(player_data.taken_dmage)
		updata_data.get_heal = tostring(player_data.get_heal)
	end
	updata_data.time_long = floor(GetTime() - current_battle.start_time_t)
	BGMainWindow:UpdateMainWindow(updata_data)
end

function BGHelper:OnInitialize()
	BGDb:Init()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("BGHelper Blizz", BGHelper.consoleOptions,{"BGHepler","BGH"})
	BGHelper.MainWindow = BGMainWindow:CreateMainWindow()
	BGHelper.MainWindow:Show()
	BGHelper.events:SetScript("OnUpdate",BGHelper.OnUpdate)

end

function BGHelper:OnEnable()
	BGHelper.events:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	BGHelper.events:RegisterEvent("PLAYER_DEAD")
	BGHelper.events:RegisterEvent("PLAYER_REGEN_DISABLED")
	BGHelper.events:RegisterEvent("PLAYER_REGEN_ENABLED")
	BGHelper.events:RegisterEvent("ZONE_CHANGED_NEW_AREA")


end

function BGHelper:OnDisable()

end

function BGHelper:InitData()

end

function BGHelper:Start()
	BattleManager:StartANewBattle()
	self.last_update_time = GetTime()
end

function BGHelper:Stop()
	BattleManager:StopCurrentBattle()
	local current_battle = BattleManager:GetCurrentBattle()
	BGDb:SaveOneBattleInfo(current_battle)
	local result_str = current_battle:ToString()
	DEFAULT_CHAT_FRAME:AddMessage(result_str)
end

function BGHelper:PLAYER_REGEN_DISABLED()
	self:Start()
end

function BGHelper:PLAYER_REGEN_ENABLED()
	self:Stop()
end

function BGHelper:ZONE_CHANGED_NEW_AREA()
	SetMapToCurrentZone()
	local CurrentZoneId = GetCurrentMapAreaID()


	if(CurrentZoneId == 443)then
		-- Zone_WarsongGulch  战歌峡谷
		self:Start()
	elseif(CurrentZoneId == 401)then
		-- Zone_AlteracValley 奥山
		self:Start()
	else
		self:Stop()
	end
end