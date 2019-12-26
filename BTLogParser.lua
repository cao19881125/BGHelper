

BTLogParser = {}

function CreatEnumTable(tbl, index)
    local enumtbl = {}
    local enumindex = index or 0
    for i, v in ipairs(tbl) do
        enumtbl[v] = enumindex + i
    end
    return enumtbl
end

ParseResultType = {
    "NONE",
    "DAMAGE",
    "HEAL",
    "TAKEN_DAMAGE",
    "GET_HEAL",
    "HEAL_SELF",
    "KILL",
    "DEAD"
}

ParseResultType = CreatEnumTable(ParseResultType)

ParseResult = {
    player_id = 0,
    player_name = "",
    dest_name = "",
    type = ParseResultType.NONE,
    value = 0
}

function ParseResult:new(o,pid,pname,dest_name,type,value)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.player_id = pid
    self.player_name = pname
    self.dest_name = dest_name
    self.type = type or ParseResultType.NONE
    self.value = value or 0
    return o
end

function BTLogParser:HandlParseResult(result)
    local current_battle = BattleManager:GetCurrentBattle()
    if(not current_battle)then
        return
    end
    if(not current_battle:HasPlayer(result.player_id)) then
            current_battle:AddPlayer(result.player_id,result.player_name)
    end

    if(result.type == ParseResultType.DAMAGE) then
        current_battle:AddDmageData(result.player_id,result.value)
    elseif(result.type == ParseResultType.HEAL) then
        current_battle:AddHeal(result.player_id,result.value)
    elseif(result.type == ParseResultType.TAKEN_DAMAGE) then
        current_battle:AddTakenDamagerData(result.player_id,result.value)
    elseif(result.type == ParseResultType.GET_HEAL) then
        current_battle:AddGetHeal(result.player_id,result.value)
    elseif(result.type == ParseResultType.HEAL_SELF) then
        current_battle:AddHeal(result.player_id,result.value)
        current_battle:AddGetHeal(result.player_id,result.value)
    elseif(result.type == ParseResultType.KILL) then
        current_battle:AddKillNum(result.player_id,result.dest_name)
    elseif(result.type == ParseResultType.DEAD) then
        current_battle:AddDeathNum(result.player_id)
    end
end

function BGHelper:COMBAT_LOG_EVENT_UNFILTERED()
    if(not BattleManager.in_battle)then
        return
    end
	local result = BTLogParser:ParseLog(CombatLogGetCurrentEventInfo())
    if(not result)then return end

    for i = 1,#result do
        local pr = result[i]
        BTLogParser:HandlParseResult(pr)
    end

end

function BGHelper:PLAYER_DEAD()
    if(not BattleManager.in_battle)then
        return
    end
    local parse_result = ParseResult:new(nil)
    parse_result.type = ParseResultType.DEAD
    parse_result.value = 1

    self:HandlParseResult(parse_result)
end

function BTLogParser:ParseLog(timestamp, eventtype, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags, ...)
    local my_guid = UnitGUID("player")
    local my_name = UnitName("player")

    local my_action = true
    local petName = UnitName("pet");
    if(srcGUID == my_guid)then
        my_action = true
    elseif (dstGUID == my_guid) then
        my_action = false
    elseif (srcName == petName) then
        my_action = true
    elseif (dstName == petName)then
        my_action = false
    else
        return nil
    end

    --local msg = string.format("my_guid:%s srcGUID:%s srcName:%s dstGUID:%s dstName:%s",my_guid,srcGUID,srcName,dstGUID,dstName)
    --DEFAULT_CHAT_FRAME:AddMessage(msg)


    local result_data = {}

    local parse_result = ParseResult:new(nil,my_guid,my_name,dstName)

    local has_overkill = false
    if(eventtype == "SWING_DAMAGE")then
        if(my_action)then
            parse_result.type = ParseResultType.DAMAGE
        else
            parse_result.type = ParseResultType.TAKEN_DAMAGE
        end

        local value,overkill = self:SwingDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
        parse_result.value = value
        if(overkill ~= nil)then has_overkill = true end
    elseif(eventtype == "RANGE_DAMAGE" or eventtype == "SPELL_DAMAGE")then
        if(my_action)then
            parse_result.type = ParseResultType.DAMAGE
        else
            parse_result.type = ParseResultType.TAKEN_DAMAGE
        end
        local value,overkill = self:SpellDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
        parse_result.value = value
        if(overkill ~= nil)then has_overkill = true end
    elseif(eventtype == "SPELL_HEAL" or eventtype == "SPELL_PERIODIC_HEAL")then
        if(srcGUID == my_guid and dstGUID ~= my_guid)then
            parse_result.type = ParseResultType.HEAL
        elseif(srcGUID ~= my_guid and dstGUID == my_guid) then
            parse_result.type = ParseResultType.GET_HEAL
        elseif(srcGUID == my_guid and dstGUID == my_guid) then
            parse_result.type = ParseResultType.HEAL_SELF
        end
        local value,overheal = self:SpellHeal(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
        parse_result.value = value
    elseif(eventtype == "PARTY_KILL")then
        -- this event means the player self kill someone
        parse_result.type = ParseResultType.KILL
        parse_result.value = 1
    end

    table.insert(result_data,parse_result)

    if(srcName == petName and has_overkill) then
        local overkill_result = ParseResult:new(nil,my_guid,my_name)
        overkill_result.type = ParseResultType.KILL
        overkill_result.value = 1
        table.insert(result_data,overkill_result)
    end

    return result_data

end



function BTLogParser:SwingDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand)
    return amount,overkill
end

function BTLogParser:SpellDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand)

    return amount,overkill
end

function BTLogParser:SpellHeal(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellId, spellName, spellSchool, amount, overheal, absorbed, critical)
    return amount,overheal
end

function ParseResult:ToString(result)
    local result_str = ""
    if(result.type == ParseResultType.DAMAGE)then
        result_str = "DMAGE"
    elseif(result.type == ParseResultType.HEAL) then
        result_str = "HEAL"
    elseif(result.type == ParseResultType.HEAL) then
        result_str = "TAKEN_DAMAGE"
    elseif(result.type == ParseResultType.HEAL) then
        result_str = "KILL"
    elseif(result.type == ParseResultType.HEAL) then
        result_str = "DEAD"
    elseif(result.type == ParseResultType.HEAL) then
        result_str = "NONE"
    end

    result_str = string.format("%s %d",result_str,result.value)

    return result_str
end