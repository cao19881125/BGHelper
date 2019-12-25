




BattleInfo = {}

function BattleInfo:new()
    return BattleInfo:reset_data()
end

function BattleInfo:reset_data()
    local o = {
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
        all_death = 0
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

function BattleInfo:AddKillNum(uid,value)
    local p = self.players[uid]
    if(p) then
        p.kill_num = p.kill_num + value
    end
    self.all_kill = self.all_kill + value
end


function BattleInfo:AddDeathNum(uid,value)
    local p = self.players[uid]
    if(p) then
        p.death_num = p.death_num + value
    end
    self.all_death = self.all_death + value
end

function BattleInfo:ToString()

    local player_str = ""
    for key,value in pairs(self.players) do
        player_str = player_str .. value:to_string()
    end
    return string.format("start_time:%s end_time:%s time_long:%d place:%s all_dmage:%d all_taken_dmage:%d all_heal:%d all_get_heal:%s all_kill:%d all_death:%d player_info:%s",
            self.start_time,self.end_time,self.time_long,self.place,self.all_dmage,self.all_taken_dmage,self.all_heal,self.all_get_heal,self.all_kill,self.all_death,player_str)
end

BattleManager = {
    in_battle = false
}


function BattleManager:GetCurrentBattle()
    if(not self.battle)then
        return nil
    end
    return self.battle
end

function BattleManager:StartANewBattle()
    self.battle = BattleInfo:new()
    self.battle:start()
    self.in_battle = true

end

function BattleManager:StopCurrentBattle()
    if(not self.battle)then
        return nil
    end
    self.battle:stop()
    self.in_battle = false
end