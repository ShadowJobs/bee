--
-- Created by IntelliJ IDEA.
-- User: playcrab
-- Date: 28/4/16
-- Time: 下午3:14
-- To change this template use File | Settings | File Templates.
--

PopView=View:subClass("PopView")
PopStack={}
function PopView:show()
    local size={width=self.view:getContentSize().width,height=self.view:getContentSize().height}
    local maskLayer = cc.LayerColor:create(
        {r=0,g=0,b=0,a=80}, NodeFactory.size.width,NodeFactory.size.height)
    maskLayer:setTouchEnabled(true)
    maskLayer:registerScriptTouchHandler(function(e,x,y)if e=='began' then return true end end)---这里加了return true之后，点击事件就不会穿透这一层

    self.view:addChild(maskLayer,-100)
    maskLayer:setAnchorPoint({x=0.5,y=0.5})
    maskLayer:setPosition({x=0,0})

    Layers.popLayer:addChild(self.view)
    table.insert(PopStack,self)
    self.index=#PopStack
end

function PopView:close()
    table.remove(PopStack,self.index)
    Layers.popLayer:removeChild(self.view,true)
end


