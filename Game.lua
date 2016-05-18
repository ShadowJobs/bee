--
-- Created by IntelliJ IDEA.
-- User: playcrab
-- Date: 26/4/16
-- Time: 下午5:35
-- To change this template use File | Settings | File Templates.
--

require 'base.Obj'
require "object.Bee"
require "object.Flower"
require "configs.LevelConfig"
require "factory.NodeFactory"
require "view.View"
require "view.PopView"
require "base.Control"
require "base.NodeTool"
require "base.Event"
Model={}
ccui.TouchEventType =
{
    began = 0,
    moved = 1,
    ended = 2,
    canceled = 3,
}

function cc.colorTransform(r, g, b, a, offr, offg, offb, offa)
    return {
        mults = {x=r or 1, y=g or 1, z=b or 1, w=a or 1},
        offsets = {x=offr or 0, y=offg or 0, z=offb or 0, w=offa or 0},
    }
end
function dispatch(e)
--    if e.data.type==1 then---popup
        if EventMap[e.name] then
            EventMap[e.name](e)
        end
--    end
end
function showPopFunc(e)
    print("function showPopFunc(e)")
    local node=NodeFactory:createView(e.csbName)
    local view=e.codeName:new(node)
    view:show()
    view:handleData(e.data)

end
function initFrameWork()
    EventMap={
        ShowPop=showPopFunc,
    }
    ---- {name={view={},control={}}}
    ViewMap={}
end

cc.FileUtils:getInstance():addSearchPath("asset")
function initMap()

end
function startGame()
    initFrameWork()
    local director=cc.Director:getInstance()
    local scene=cc.Scene:create()
    local layout=ccui.Layout:create()
    layout:setContentSize(NodeFactory.size)
    if director:getRunningScene() then
        director:replaceScene(scene)
    else
        director:runWithScene(scene)
    end
    local mainPage=NodeFactory:createView('friend.csb')
    Layers={}
    local sceneLayer=cc.Layer:create()
    scene:addChild(sceneLayer)
    Layers.sceneLayer=sceneLayer
    local popLayer=cc.Layer:create()
    scene:addChild(popLayer)
    Layers.popLayer=popLayer


    sceneLayer:addChild(mainPage)

    local btn=seekNode('Button_Btntuijian',mainPage)
    btn:setAnchorPoint({x=0.2,y=0.2})
    print(btn:getContentSize().width,btn:getContentSize().height)
    print(btn:getAnchorPointInPoints().x,btn:getAnchorPointInPoints().y)
    btn:setScale(1.5)
    print(btn:getContentSize().width*btn:getScaleX(),btn:getContentSize().height*btn:getScaleY())
    print(btn:getAnchorPointInPoints().x,btn:getAnchorPointInPoints().y)
    seekNode('Button_tempBtn',btn):addClickEventListener(function()
        print("aaaa")
        require "view.ViewSettingPop"
        dispatch(PopEvent:new("friendPop.csb",ViewSettingPop,{from="Game"}))
    end)


end

