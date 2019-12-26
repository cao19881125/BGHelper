

BGPlayer = {}

function BGPlayer:new(uid)
    local o = {
        uid = uid,
        name = "",
        dmage = 0,
        taken_dmage = 0,
        heal = 0,
        get_heal = 0,
        kill_num = 0,
        death_num = 0
    }

    setmetatable(o, self)
    self.__index = self
    return o
end


function BGPlayer:AddKill()
    if(not self.multi_kill_num) then self.multi_kill_num = 0 end
    if(not self.continue_kill_num) then self.continue_kill_num = 0 end

    self.kill_num = self.kill_num + 1
    self.multi_kill_num = self.multi_kill_num + 1

    if(self.last_kill_time)then
        if((GetTime()) - self.last_kill_time <= 12)then
            self.continue_kill_num = self.continue_kill_num + 1
        else
            self.continue_kill_num = 1
        end
    else
        self.continue_kill_num = 1
    end

    self.last_kill_time = GetTime()
end

function BGPlayer:AddDeath()
    self.death_num = self.death_num + 1
    self.multi_kill_num = 0
end

function BGPlayer:to_string()
    return string.format("name:%s dmage:%d taken_dmage:%d heal:%d get_heal:%d kill_num:%d death_num:%d",
            self.name,self.dmage,self.taken_dmage,self.heal,self.get_heal,self.kill_num,self.death_num)
end