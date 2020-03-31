
local acedb = LibStub("AceDB-3.0")

BGDataBase = {
    db = nil
}

local Default_Profile = {
    profile = {
        MainWindow = {
            Position = {
				point = "CENTER",
                x = 0,
                y = 0
			}
        },
        History = {

        }
    }
}

function BGDataBase:Init()
    self.db = acedb:New("BGHelperDB",Default_Profile)
end

function BGDataBase:SaveOneBattleInfo(battle_info)
    table.insert(self.db.profile.History,1,battle_info)
end

function BGDataBase:GetHistoryData()
    return self.db.profile.History
end

function BGDataBase:SavePosition(point,xOfs,yOfs)
    self.db.profile.MainWindow.Position.point = point
    self.db.profile.MainWindow.Position.x = xOfs
    self.db.profile.MainWindow.Position.y = yOfs
end

function BGDataBase:GetPosition()
    return self.db.profile.MainWindow.Position.point,self.db.profile.MainWindow.Position.x,self.db.profile.MainWindow.Position.y
end