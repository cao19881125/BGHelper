

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


function BGPlayer:to_string()
    return string.format("name:%s dmage:%d taken_dmage:%d heal:%d get_heal:%d kill_num:%d death_num:%d",
            self.name,self.dmage,self.taken_dmage,self.heal,self.get_heal,self.kill_num,self.death_num)
end