--
-- Created by IntelliJ IDEA.
-- User: playcrab
-- Date: 26/4/16
-- Time: 下午5:56
-- To change this template use File | Settings | File Templates.
--
local sz=cc.Director:getInstance():getWinSize()
NodeFactory={size={width=sz.width,height=sz.height} }
require "factory.PCComponentLibrary"
PCComponentLibrary:initLibrary()
function NodeFactory:createView(name)
    local node=cc.CSLoader:createNode(name)
    node:setContentSize(self.size)
--    local clickMask=ccui.Layout:create()
--    clickMask:setContentSize(self.size)
--    clickMask:setBackGroundColorOpacity(0)
--    clickMask:setVisible(true)
--    clickMask:setAnchorPoint({x=0,y=0})
--    clickMask:addChild(node,100)
    ccui.Helper:doLayout(node)
--    return clickMask
    return node
end


function NodeFactory:createMc(name)
    return PCComponentLibrary:createMovieClip(name)
end