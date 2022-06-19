require "TimedActions/ISBaseTimedAction"

CheckAlarmVehicleAction = ISBaseTimedAction:derive("CheckAlarmVehicleAction")

function CheckAlarmVehicleAction:isValid()
	return true
end

function CheckAlarmVehicleAction:update()
	local uispeed = UIManager.getSpeedControls():getCurrentGameSpeed()
    if uispeed ~= 1 then
        UIManager.getSpeedControls():SetCurrentGameSpeed(1)
    end
end

function CheckAlarmVehicleAction:start()
    self.character:facePosition(self.vehicle:getX(), self.vehicle:getY())
    self:setActionAnim("Loot")
end

function CheckAlarmVehicleAction:stop()
	ISBaseTimedAction.stop(self)
end

function CheckAlarmVehicleAction:perform()
    if self.vehicle:isAlarmed() then
        self.character:Say(getText("UI_is_alarm"))
    else
        self.character:Say(getText("UI_is_no_alarm"))
    end

    ISBaseTimedAction.perform(self)
end

function CheckAlarmVehicleAction:new(character, vehicle)
	local o = {}
	setmetatable(o, self)
	self.__index = self
    o.character = character
    o.vehicle = vehicle
	o.maxTime = 100
	
	return o
end




