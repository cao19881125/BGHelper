BGHelper = LibStub("AceAddon-3.0"):NewAddon("BGHelper","AceConsole-3.0","AceComm-3.0", "AceTimer-3.0")

local BGHelper = _G.BGHelper
local BattleManager = _G.BattleManager
local BGDb = _G.BGDataBase
local BGMainWindow = _G.BGMainWindow
local BGSoundPlayer = _G.BGSoundPlayer
local BattleEventType = _G.BattleEventType
local GetCurrentMapAreaID = _G.GetCurrentMapAreaID

local CreateFrame = CreateFrame

BGHelper.events = CreateFrame("Frame")

BGHelper.events:SetScript("OnEvent", function(self, event, ...)
	if not BGHelper[event] then
		return
	end

	BGHelper[event](BGHelper, ...)
end)


BattleZoneHelper = {}
BattleZoneHelper.MAPID_ALTERAC = 1459	--奥特兰克山谷
BattleZoneHelper.MAPNAME_ALTERAC = C_Map.GetMapInfo(BattleZoneHelper.MAPID_ALTERAC).name

BattleZoneHelper.MAPID_WARSONG = 1460	--战歌峡谷
BattleZoneHelper.MAPNAME_WARSONG = C_Map.GetMapInfo(BattleZoneHelper.MAPID_WARSONG).name

BattleZoneHelper.MAPID_ARATHI = 1461	--阿拉希盆地
BattleZoneHelper.MAPNAME_ARATHI = C_Map.GetMapInfo(BattleZoneHelper.MAPID_ARATHI).name

-- ( 1 for Alterac Valley, 2 for Warsong Gulch, 3 for Arathi Basin,
BattleZoneHelper.BGID_ALTERAC = 1
BattleZoneHelper.BGID_WARSONG = 2
BattleZoneHelper.BGID_ARATHI = 3

BattleZoneHelper.MAPNAME_TO_ID = {
	[BattleZoneHelper.MAPNAME_ALTERAC] = BattleZoneHelper.BGID_ALTERAC,
	[BattleZoneHelper.MAPNAME_WARSONG] = BattleZoneHelper.BGID_WARSONG,
	[BattleZoneHelper.MAPNAME_ARATHI] = BattleZoneHelper.BGID_ARATHI,
}

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
		},
		["sd"] = {
			order = 15,
			name = "sd",
			desc = "Sount test",
			type = 'execute',
			func = function()
				BGHelper:SoundTest()
			end,
			dialogHidden = true
		}
	}
}

function BGHelper:OnUpdate()
	if(not BattleManager.in_battle)then
		return
	end

	BGSoundPlayer:PlayNextSound()

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

local function PlayerFaction()
    local factionGroup = UnitFactionGroup("player");
    if ( factionGroup == "Alliance" ) then
        return FACTION_ALLIANCE
    else
        return FACTION_HORDE
    end
end

function BGHelper:OnInitialize()
	BGDb:Init()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("BGHelper Blizz", BGHelper.consoleOptions,{"BGHepler","BGH"})
	BGHelper.MainWindow = BGMainWindow:CreateMainWindow()
	BGHelper.MainWindow.frame["MoveFinished"] = BGHelper.OnMainWindowMoved
	local point,x,y = BGDataBase:GetPosition()
	BGHelper.MainWindow.frame:SetPoint(point,x,y)
	BGHelper.MainWindow:Show()
	BGHelper.events:SetScript("OnUpdate",BGHelper.OnUpdate)
end

function BGHelper:OnEnable()
	BGHelper.events:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	BGHelper.events:RegisterEvent("PLAYER_DEAD")
	BGHelper.events:RegisterEvent("PLAYER_REGEN_DISABLED")
	BGHelper.events:RegisterEvent("PLAYER_REGEN_ENABLED")
	BGHelper.events:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	BGHelper.events:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")


end

function BGHelper:OnDisable()

end

function BGHelper:InitData()

end

function BGHelper:OnMainWindowMoved()
	local point, relativeTo, relativePoint, xOfs, yOfs = BGHelper.MainWindow.frame:GetPoint()
	BGDataBase:SavePosition(point,xOfs,yOfs)
end

function BGHelper:SoundTest()
	local current_battle = BattleManager:GetCurrentBattle()
	local my_guid = UnitGUID("player")
	current_battle:AddKillNum(my_guid,"testname")
end

function BGHelper:BattleEventCallback(event)
	if(event.type == BattleEventType.FIRST_BLOOD)then
		BGSoundPlayer:AddSoundToQueue(BattleEventType.FIRST_BLOOD,0)
	elseif(event.type == BattleEventType.MULTI_KILL or event.type == BattleEventType.CONTINUE_KILL)	then
		BGSoundPlayer:AddSoundToQueue(event.type,event.value)
	end
end

function BGHelper:Start(bgid)
	BattleManager:StartANewBattle(bgid)
	local current_battle = BattleManager:GetCurrentBattle()
	local my_guid = UnitGUID("player")
    local my_name = UnitName("player")
	current_battle:AddPlayer(my_guid,my_name)
	current_battle:RegisterBattleEventCallBack(function(event) return BGHelper:BattleEventCallback(event) end)
	self.last_update_time = GetTime()
	BGMainWindow:UpdateBattleState(true)
end

function BGHelper:Stop(win)
	BattleManager:StopCurrentBattle(win)
	local current_battle = BattleManager:GetCurrentBattle()
	BGDb:SaveOneBattleInfo(current_battle)
	local result_str = current_battle:ToString()
	DEFAULT_CHAT_FRAME:AddMessage(result_str)
	BGMainWindow:UpdateBattleState(false)
end

function BGHelper:PLAYER_REGEN_DISABLED()
	--self:Start(3)
end

function BGHelper:PLAYER_REGEN_ENABLED()
	--self:Stop(true)
end



function BGHelper:UPDATE_BATTLEFIELD_STATUS()
    DEFAULT_CHAT_FRAME:AddMessage("UPDATE_BATTLEFIELD_STATUS")
    local battlefieldWinner = GetBattlefieldWinner()
	DEFAULT_CHAT_FRAME:AddMessage("UPDATE_BATTLEFIELD_STATUS 2")
    if (battlefieldWinner) then
		DEFAULT_CHAT_FRAME:AddMessage("UPDATE_BATTLEFIELD_STATUS 3")
		local win = battlefieldWinner == PlayerFaction()
		DEFAULT_CHAT_FRAME:AddMessage("UPDATE_BATTLEFIELD_STATUS 4")
		self:Stop(win)
		DEFAULT_CHAT_FRAME:AddMessage("UPDATE_BATTLEFIELD_STATUS 5")
		return
    end

	if (BattleManager.in_battle) then
		return
	end

    for i=1, MAX_BATTLEFIELD_QUEUES do
        local status, mapName, instanceID = GetBattlefieldStatus(i);

        local str = "GetBattlefieldStatus:"..i .." " .. status .. " " .. mapName .. " " .. instanceID
		DEFAULT_CHAT_FRAME:AddMessage(str)

		if status == "active" then
			self:Start(BattleZoneHelper.MAPNAME_TO_ID[mapName])
			return
        end
    end


end

function BGHelper:ZONE_CHANGED_NEW_AREA()


	local CurrentZone = GetRealZoneText()
	if(CurrentZone == BattleZoneHelper.MAPNAME_WARSONG)then
		-- 443 Zone_WarsongGulch  战歌峡谷
	elseif(CurrentZone == BattleZoneHelper.MAPNAME_ALTERAC)then
		-- 401 Zone_AlteracValley 奥山
	elseif(CurrentZone == BattleZoneHelper.MAPNAME_ARATHI)then
		-- 461 Zone_ArathiBasin 阿拉希盆地
	else
		if (BattleManager.in_battle) then
			self:Stop(false)
		end

	end
end