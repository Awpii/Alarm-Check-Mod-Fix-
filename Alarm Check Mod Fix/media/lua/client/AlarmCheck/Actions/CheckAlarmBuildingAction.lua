require "TimedActions/ISBaseTimedAction"

CheckAlarmBuildingAction = ISBaseTimedAction:derive("CheckAlarmBuildingAction")

function CheckAlarmBuildingAction:isValid()
	return true
end

function CheckAlarmBuildingAction:update()
	local uispeed = UIManager.getSpeedControls():getCurrentGameSpeed()
    if uispeed ~= 1 then
        UIManager.getSpeedControls():SetCurrentGameSpeed(1)
    end
end

function CheckAlarmBuildingAction:start()
    local pos = self.obj:getFacingPosition(self.character:getPlayerMoveDir())
    if not self.obj:getNorth() then
        self.character:facePosition(pos:getX(), pos:getY()+1)
    else
        self.character:facePosition(pos:getX()+1, pos:getY())
    end

    self:setActionAnim("Loot")
end

function CheckAlarmBuildingAction:stop()
	ISBaseTimedAction.stop(self)
end

function CheckAlarmBuildingAction:perform()
    if self.obj:getModData()["AlarmCheck_cantCheckAlarm"] == nil then
        self.obj:getModData()["AlarmCheck_cantCheckAlarm"] = (ZombRand(100) < 5)
    end

    if self.obj:getModData()["AlarmCheck_cantCheckAlarm"] then
        self.character:Say(getText("UI_cant_check_alarm"))
    else
        if (self.sq1:getBuilding() and self.sq1:getBuilding():getDef():isAlarmed()) or (self.sq2:getBuilding() and self.sq2:getBuilding():getDef():isAlarmed()) then
            self.character:Say(getText("UI_is_alarm"))
        else
            self.character:Say(getText("UI_is_no_alarm"))
        end
    end    

    ISBaseTimedAction.perform(self)
end

function CheckAlarmBuildingAction:new(character, sq1, sq2, obj)
	local o = {}
	setmetatable(o, self)
	self.__index = self
    o.character = character
    o.sq1 = sq1
    o.sq2 = sq2
    o.obj = obj
	o.maxTime = 100
	
	return o
end




