local AceGUI = LibStub("AceGUI-3.0")

BGMainWindow = {}

local LENGTH_SCAL = 8
local LABEL_SIZE = 12

function BGMainWindow:ChangeFontSize(f,size)
    local Font, Height, Flags = f.label:GetFont()
    f.label:SetFont(Font, size, Flags)
end
function BGMainWindow:insert_space(frame)
    local target_label = AceGUI:Create("Label")
    target_label:SetText("   ")
    self:ChangeFontSize(target_label,6)
    frame:AddChild(target_label)
end
function BGMainWindow:CreateMainWindow()

    local frame = AceGUI:Create("Frame3")
    frame:SetLayout("Flow")
    --frame:SetTitle("战场统计")
    --frame:SetStatusText("停止")
    frame:SetWidth(36*LENGTH_SCAL)
    frame:SetHeight(8*LENGTH_SCAL)


    -- status label
    local status_group = AceGUI:Create("SimpleGroup")
    status_group:SetLayout("List")
    status_group:SetWidth(8*LENGTH_SCAL)
    status_group:SetHeight(8*LENGTH_SCAL)
    frame:AddChild(status_group)

    local status_icon = AceGUI:Create("Label2")
    status_icon:SetText("战斗停止")
    status_icon:SetWidth(8*LENGTH_SCAL)
    status_icon:SetHeight(4*LENGTH_SCAL)
    self:ChangeFontSize(status_icon,LABEL_SIZE)
    status_group:AddChild(status_icon)
    self.status_icon = status_icon

    self:insert_space(status_group)

    local status_time_label = AceGUI:Create("Label2")
    status_time_label:SetText("00:00")
    status_time_label:SetWidth(8*LENGTH_SCAL)
    status_time_label:SetHeight(3*LENGTH_SCAL)
    self:ChangeFontSize(status_time_label,LABEL_SIZE)
    status_group:AddChild(status_time_label)
    self.status_time_label = status_time_label

    -- kill death

    local KD_group = AceGUI:Create("SimpleGroup")
    KD_group:SetLayout("List")
    KD_group:SetWidth(8*LENGTH_SCAL)
    KD_group:SetHeight(8*LENGTH_SCAL)
    frame:AddChild(KD_group)

    local KD_label = AceGUI:Create("Label2")
    KD_label:SetText("击杀/死亡")
    KD_label:SetWidth(8*LENGTH_SCAL)
    KD_label:SetHeight(4*LENGTH_SCAL)
    self:ChangeFontSize(KD_label,LABEL_SIZE)
    KD_group:AddChild(KD_label)

    self:insert_space(KD_group)

    local self_kd_label = AceGUI:Create("Label2")
    self_kd_label:SetText("0/0")
    self_kd_label:SetWidth(8*LENGTH_SCAL)
    self_kd_label:SetHeight(3*LENGTH_SCAL)
    self:ChangeFontSize(self_kd_label,LABEL_SIZE)
    KD_group:AddChild(self_kd_label)
    self.self_kd_label = self_kd_label

    -- dmage

    local dmage_group = AceGUI:Create("SimpleGroup")
    dmage_group:SetLayout("List")
    dmage_group:SetWidth(8*LENGTH_SCAL)
    dmage_group:SetHeight(8*LENGTH_SCAL)
    frame:AddChild(dmage_group)

    local dmage_label = AceGUI:Create("Label2")
    dmage_label:SetText("输出")
    dmage_label:SetWidth(8*LENGTH_SCAL)
    dmage_label:SetHeight(4*LENGTH_SCAL)
    self:ChangeFontSize(dmage_label,LABEL_SIZE)
    dmage_group:AddChild(dmage_label)

    self:insert_space(dmage_group)

    local dmage_data_label = AceGUI:Create("Label2")
    dmage_data_label:SetText("0")
    dmage_data_label:SetWidth(8*LENGTH_SCAL)
    dmage_data_label:SetHeight(3*LENGTH_SCAL)
    self:ChangeFontSize(dmage_data_label,LABEL_SIZE)
    dmage_group:AddChild(dmage_data_label)
    self.dmage_data_label = dmage_data_label
    -- heal

    local heal_group = AceGUI:Create("SimpleGroup")
    heal_group:SetLayout("List")
    heal_group:SetWidth(8*LENGTH_SCAL)
    heal_group:SetHeight(8*LENGTH_SCAL)
    frame:AddChild(heal_group)

    local heal_label = AceGUI:Create("Label2")
    heal_label:SetText("治疗")
    heal_label:SetWidth(8*LENGTH_SCAL)
    heal_label:SetHeight(4*LENGTH_SCAL)
    self:ChangeFontSize(heal_label,LABEL_SIZE)
    heal_group:AddChild(heal_label)

    self:insert_space(heal_group)

    local heal_data_label = AceGUI:Create("Label2")
    heal_data_label:SetText("0")
    heal_data_label:SetWidth(8*LENGTH_SCAL)
    heal_data_label:SetHeight(3*LENGTH_SCAL)
    self:ChangeFontSize(heal_data_label,LABEL_SIZE)
    heal_group:AddChild(heal_data_label)
    self.heal_data_label = heal_data_label

    -- taken_dmage

    --local taken_dmage_group = AceGUI:Create("SimpleGroup")
    --taken_dmage_group:SetLayout("List")
    --taken_dmage_group:SetWidth(8*LENGTH_SCAL)
    --taken_dmage_group:SetHeight(8*LENGTH_SCAL)
    --frame:AddChild(taken_dmage_group)
    --
    --local taken_dmage_label = AceGUI:Create("Label2")
    --taken_dmage_label:SetText("承伤")
    --taken_dmage_label:SetWidth(8*LENGTH_SCAL)
    --taken_dmage_label:SetHeight(3*LENGTH_SCAL)
    --self:ChangeFontSize(taken_dmage_label,LABEL_SIZE)
    --taken_dmage_group:AddChild(taken_dmage_label)
    --
    --self:insert_space(taken_dmage_group)
    --
    --local taken_dmage__data_label = AceGUI:Create("Label2")
    --taken_dmage__data_label:SetText("15040")
    --taken_dmage__data_label:SetWidth(8*LENGTH_SCAL)
    --taken_dmage__data_label:SetHeight(3*LENGTH_SCAL)
    --self:ChangeFontSize(taken_dmage__data_label,LABEL_SIZE)
    --taken_dmage_group:AddChild(taken_dmage__data_label)
    --self.taken_dmage__data_label = taken_dmage__data_label

    -- get_heal

    --local get_heal_group = AceGUI:Create("SimpleGroup")
    --get_heal_group:SetLayout("List")
    --get_heal_group:SetWidth(8*LENGTH_SCAL)
    --get_heal_group:SetHeight(8*LENGTH_SCAL)
    --frame:AddChild(get_heal_group)
    --
    --local get_heal_label = AceGUI:Create("Label2")
    --get_heal_label:SetText("被治疗")
    --get_heal_label:SetWidth(8*LENGTH_SCAL)
    --get_heal_label:SetHeight(3*LENGTH_SCAL)
    --self:ChangeFontSize(get_heal_label,LABEL_SIZE)
    --get_heal_group:AddChild(get_heal_label)
    --
    --self:insert_space(get_heal_group)
    --
    --local get_heal__data_label = AceGUI:Create("Label2")
    --get_heal__data_label:SetText("15040")
    --get_heal__data_label:SetWidth(8*LENGTH_SCAL)
    --get_heal__data_label:SetHeight(3*LENGTH_SCAL)
    --self:ChangeFontSize(get_heal__data_label,LABEL_SIZE)
    --get_heal_group:AddChild(get_heal__data_label)
    --self.get_heal__data_label = get_heal__data_label

    return frame
end

function BGMainWindow:UpdateMainWindow(data)
    self.status_time_label:SetText(string.format("%02d:%02d",data["time_long"]/60,data["time_long"]%60) )
    self.self_kd_label:SetText(data["kd"])
    self.dmage_data_label:SetText(data["dmage"])
    self.heal_data_label:SetText(data["heal"])
    self.taken_dmage__data_label:SetText(data["taken_dmage"])
    self.get_heal__data_label:SetText(data["get_heal"])
end

function BGMainWindow:UpdateBattleState(in_battle)
    if(in_battle)then
        self.status_icon:SetText("战斗中")
    else
        self.status_icon:SetText("战斗停止")
    end

end
