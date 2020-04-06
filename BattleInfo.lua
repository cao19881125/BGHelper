
BattleInfo = {}

BattleManager = {
    in_battle = false
}

function CreatEnumTable(tbl, index)
    local enumtbl = {}
    local enumindex = index or 0
    for i, v in ipairs(tbl) do
        enumtbl[v] = enumindex + i
    end
    return enumtbl
end

BattleEventTp = {
    "NORMAL_KILL",
    "FIRST_BLOOD",
    "MULTI_KILL",
    "CONTINUE_KILL"
}

BattleEventType = CreatEnumTable(BattleEventTp)

BattleEvent = {

}

function BattleEvent:new()
    local o = {
        type = nil,
        src = "",
        dst = "",
        value = 0
    }

    setmetatable(o, self)
    self.__index = self
    return o
end

function BattleInfo:new()
    return BattleInfo:reset_data()
end

function BattleInfo:reset_data()
    local o = {
        bgid = 0, -- 1:奥山 2:战歌 3:阿拉希
        start_time = "",
        end_time = "",
        time_long = 0,
        place = "",
        players = {},
        all_dmage = 0,
        all_taken_dmage = 0,
        all_heal = 0,
        all_get_heal = 0,
        all_kill = 0,
        all_death = 0,
        win = false
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function BattleInfo:start()
    self:reset_data()
    self.start_time = date("%y/%m/%d %H:%M")
    self.start_time_t = GetTime()
    self.place = GetZoneText()
end

function BattleInfo:stop()
    self.end_time = date("%y/%m/%d %H:%M")
    self.time_long = floor(GetTime() - self.start_time_t)
end

function BattleInfo:AddPlayer(uid,name)
    local player = BGPlayer:new(uid)
    player.name = name
    self.players[uid] = player
end

function BattleInfo:HasPlayer(uid)
    local p = self.players[uid]

    if(p)then
        return true
    else
        return false
    end
end

function BattleInfo:GetPlayer(uid)
    if(not self:HasPlayer(uid))then
        return nil
    end

    return self.players[uid]
end

function BattleInfo:AddDmageData(uid,value)
    local p = self.players[uid]
    if(p) then
        p.dmage = p.dmage + value
    end
    self.all_dmage = self.all_dmage + value
end

function BattleInfo:AddTakenDamagerData(uid,value)
    local p = self.players[uid]
    if(p) then
        p.taken_dmage = p.taken_dmage + value
    end
    self.all_taken_dmage = self.all_taken_dmage + value
end

function BattleInfo:AddHeal(uid,value)
    local p = self.players[uid]
    if(p) then
        p.heal = p.heal + value
    end
    self.all_heal = self.all_heal + value
end

function BattleInfo:AddGetHeal(uid,value)
    local p = self.players[uid]
    if(p) then
        p.get_heal = p.get_heal + value
    end
    self.all_get_heal = self.all_get_heal + value
end

function BattleInfo:AddKillNum(uid,dst_name)
    local p = self.players[uid]
    if(p) then
        p:AddKill()
    end
    self.all_kill = self.all_kill + 1
    if(self.all_kill == 1)then
        local btevent = BattleEvent:new()
        btevent.type = BattleEventType.FIRST_BLOOD
        btevent.src = p.name
        self.event_callback(btevent)
    end

    local normal_kill_event = BattleEvent:new()
    normal_kill_event.type = BattleEventType.NORMAL_KILL
    normal_kill_event.src = p.name
    normal_kill_event.dst = dst_name
    self.event_callback(normal_kill_event)


    if(p.continue_kill_num >= 2)then
        local btevent = BattleEvent:new()
        btevent.type = BattleEventType.CONTINUE_KILL
        btevent.src = p.name
        btevent.value = p.continue_kill_num
        self.event_callback(btevent)
    end

    if(p.multi_kill_num >= 3)then
        local btevent = BattleEvent:new()
        btevent.type = BattleEventType.MULTI_KILL
        btevent.src = p.name
        btevent.value = p.multi_kill_num
        self.event_callback(btevent)
    end

end


function BattleInfo:AddDeathNum(uid)
    local p = self.players[uid]
    if(p) then
        p:AddDeath()
    end
    self.all_death = self.all_death + 1
end

function BattleInfo:RegisterBattleEventCallBack(callback)
    self.event_callback = callback
end

function BattleInfo:ToString()

    local player_str = ""
    for key,value in pairs(self.players) do
        player_str = player_str .. value:to_string()
    end
    return string.format("start_time:%s end_time:%s time_long:%d place:%s all_dmage:%d all_taken_dmage:%d all_heal:%d all_get_heal:%s all_kill:%d all_death:%d player_info:%s",
            self.start_time,self.end_time,self.time_long,self.place,self.all_dmage,self.all_taken_dmage,self.all_heal,self.all_get_heal,self.all_kill,self.all_death,player_str)
end



function BattleManager:GetCurrentBattle()
    if(not self.battle)then
        return nil
    end
    return self.battle
end

function BattleManager:StartANewBattle(bgid)
    self.battle = BattleInfo:new()
    self.battle:start()
    self.bgid = bgid
    self.in_battle = true

end

function BattleManager:StopCurrentBattle(win)
    if(not self.battle)then
        return nil
    end
    self.battle.win = win
    self.battle:stop()
    self.in_battle = false
end