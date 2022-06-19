if AlarmCheck == nil then AlarmCheck = {} end
if AlarmCheck.UI == nil then AlarmCheck.UI = {} end


function AlarmCheck.UI.contextMenuOptions(player, context, worldobjects)
    local playerObj = getSpecificPlayer(player)
    local window = nil
    local door = nil

	for _, v in ipairs(worldobjects) do
        if instanceof(v, "IsoDoor") then     
            door = v
        elseif instanceof(v, "IsoWindow") then
            window = v
        end
    end
    
    if door then
        if playerObj:getKnownRecipes():contains("Check for Alarm") and door:isExteriorDoor(playerObj) then
            context:addOption(getText("UI_AlarmCheck_CheckAlarm"), playerObj, AlarmCheck.UI.checkBuildingAlarm, door:getSquare(), door:getOppositeSquare(), door)
        end

    elseif window then
        if playerObj:getKnownRecipes():contains("Check for Alarm") then
            context:addOption(getText("UI_AlarmCheck_CheckAlarm"), playerObj, AlarmCheck.UI.checkBuildingAlarm, window:getSquare(), window:getOppositeSquare(), window)
        end
    else
    end
end

Events.OnFillWorldObjectContextMenu.Add(AlarmCheck.UI.contextMenuOptions);


function AlarmCheck.UI.checkBuildingAlarm(playerObj, sq1, sq2, obj)
    local sq = sq1
    if sq2:DistTo(playerObj:getSquare()) < sq1:DistTo(playerObj:getSquare()) then
        sq = sq2
    end

    ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, sq));
    ISTimedActionQueue.add(CheckAlarmBuildingAction:new(playerObj, sq1, sq2, obj));
end