if AlarmCheck == nil then AlarmCheck = {} end
if AlarmCheck.UI == nil then AlarmCheck.UI = {} end

-- Adding outside options
function AlarmCheck.UI.addOutsideOptions(playerObj)
    local menu = getPlayerRadialMenu(playerObj:getPlayerNum())
    if menu == nil then return end

    local vehicle = playerObj:getUseableVehicle()
    if vehicle == nil then return end

    local part = vehicle:getUseablePart(playerObj)
    if part and part:getDoor()then
        if part:getId() == "EngineDoor" and playerObj:getKnownRecipes():contains("Check for Alarm") then
            menu:addSlice(getText("UI_AlarmCheck_CheckAlarm"), getTexture("media/textures/AlarmCheck_alarmIcon.png"), AlarmCheck.UI.alarmCheck, playerObj, vehicle, part)
        end
    end
end

-- Save default function for wrap it
if AlarmCheck.UI.defaultShowRadialMenu == nil then
    AlarmCheck.UI.defaultShowRadialMenu = ISVehicleMenu.showRadialMenu
end
  
-- Wrap default fuction
function ISVehicleMenu.showRadialMenu(playerObj)
    AlarmCheck.UI.defaultShowRadialMenu(playerObj)
    
    if not playerObj:getVehicle() then
        AlarmCheck.UI.addOutsideOptions(playerObj)
    end
end

-- Functions

function AlarmCheck.UI.alarmCheck(playerObj, vehicle, part)
    if not part:getDoor():isLocked() then
        ISTimedActionQueue.add(CheckAlarmVehicleAction:new(playerObj, vehicle));
    else
        playerObj:facePosition(vehicle:getX(), vehicle:getY())
        playerObj:getEmitter():playSound("DoorIsLocked")
    end
end