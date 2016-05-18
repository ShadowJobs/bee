--[[
    Filename:    PCComponentLibrary.lua
    Author:      chenhailong@playcrab.com 
    Datetime:    2014-08-08 17:50:36
    Description: Library that contains all playcrab view components.
--]]
local nodeFactory = pc.DisplayNodeFactory:getInstance()
local timelineDriver = pc.MCTimelineDriver:getInstance()

--------------------------------------------------------------------------------
-- MCGroupManager 
--------------------------------------------------------------------------------
MCGroupManager = MCGroupManager or {}

function MCGroupManager:getTimelineGroup(groupName)
    if groupName==nil then
        return timelineDriver:getDefaultTimelineGroup()
    end

    if self._groups==nil then
        return nil
    end
    return self._groups[groupName]
end

function MCGroupManager:newTimelineGroup(groupName)
    if groupName==nil then
        return nil
    end
    if self._groups==nil then
        self._groups = {}
    end
    assert(self._groups[groupName]==nil)
    local group = pc.MCTimelineGroup:create()
    if group~=nil then
        group:retain()
    end
    self._groups[groupName] = group
    return group
end

function MCGroupManager:clearAllGroups()
    if self._groups==nil then
        return
    end
    for name,group in pairs(self._groups) do
        group:release()
    end
    self._groups = nil
end

--------------------------------------------------------------------------------
-- PCComponentLibrary 
--------------------------------------------------------------------------------
PCComponentLibrary = {}

function PCComponentLibrary:initLibrary()
    -- nodeFactory:setParticlePaths("asset/particle/")
    nodeFactory:loadIndices("anim/plist.index.json")
    nodeFactory:loadIndices("anim/animxml.index.json")
    --nodeFactory:loadIndices("asset/ui/plist.index.json")
end

function PCComponentLibrary:clearLibrary()
    nodeFactory:clearIndices()
    nodeFactory:clearMCLibrary()
end

function PCComponentLibrary:supportPreloading()
    return nodeFactory.preload~=nil and nodeFactory.preloadAsync~=nil
end

function PCComponentLibrary:preload(resName)
    if nodeFactory.preload~=nil then
        return nodeFactory:preload(resName)
    else
        -- do nothing
        return 0
    end
end

local function emptyCallback(result)
    -- no thing
end
function PCComponentLibrary:preloadAsync(resName, callback)
    if nodeFactory.preloadAsync~=nil then
        nodeFactory:preloadAsync(resName, callback or emptyCallback)
    else
        -- do nothing
        if callback then callback(0) end
    end
end

function PCComponentLibrary:createMovieClip(libName, groupName)
    local mc = nodeFactory:createMovieClip(libName)
    if mc==nil then
        return nil
    end

    local labelMap = {}
    local framesMap = {}

    function mc:getLibName()
        return libName
    end

    function mc:getLabelsAtFrame(frameIndex)
        return labelMap and labelMap[tostring(frameIndex)]
    end

    function mc:getFrameIndicesByLabel(label)
        return framesMap[label]
    end

 


    function mc:enableRepeat(isEnable)
        self.isEnable =isEnable
        if not self.__enableRepeat__ then 
            self.__enableRepeat__ = self:addEndCallback(
                function ()
                    if self.isEnable == false then 
                        self:stop()
                    end
                end)
        end
    end

    function mc:setTimelineGroupByName(name)
        local group = MCGroupManager:getTimelineGroup(name)
        if group==nil and name~=nil then
            group = MCGroupManager:newTimelineGroup(name)
        end
        if group~=nil then
            self:setTimelineGroup(group)
        end
    end

    if groupName~=nil then
        mc:setTimelineGroupByName(groupName)
    end

    if mc.setLuaEndCallback==nil then
        mc.setLuaEndCallback = function (self, target, func)
            if self.__endCall__~=nil and self.__endCall__~=0 then
                self:removeCallback(self.__endCall__)
                self.__endCall__ = nil
            end
            if func~=nil then
                self.__endCall__ = self:addEndCallback(
                    function (fid, mc, ...)
                        func(target, mc, ...)
                    end)
            end
        end
    end

    if mc.setLuaCallbackAtFrame==nil then
        mc.setLuaCallbackAtFrame = function (self, frameIndex, target, func)
            assert(false, "setLuaCallbackAtFrame() is discarded."
                + "Use addCallbackAtFrame() or addCallbackByLabel() instead.")
            local calls = self.__frameCalls__
            if calls~=nil and calls[frameIndex]~=nil then
                self:removeCallback(calls[frameIndex])
                calls[frameIndex] = nil
            end
            if func~=nil then
                local fid = self:addCallbackAtFrame(
                    frameIndex,
                    function (fid, mc, frameIndex)
                        func(target, mc, frameIndex)
                    end)
                if fid~=nil and fid~=0 then
                    if self.__frameCalls__==nil then
                        self.__frameCalls__ = {}
                    end
                    self.__frameCalls__[frameIndex] = fid
                end
            end
        end
    end

    function mc:setScriptInterpreter(func)
        self:setIsScriptEnabled(func~=nil)
        pc.MovieClip.setScriptInterpreter(self, func)
    end

    return mc
end

function PCComponentLibrary:createSimpleSprite(libName)
    return nodeFactory:createSpriteNode(libName)
end

function PCComponentLibrary:createMaskSprite(libName)
    local maskSprite = pc.MaskSprite:create()
    if maskSprite~=nil then
        nodeFactory:setSpriteTexture(maskSprite, libName)
    end
    return maskSprite
end
