--
-- Created by IntelliJ IDEA.
-- User: playcrab
-- Date: 27/4/16
-- Time: 下午4:58
-- To change this template use File | Settings | File Templates.
--

ViewSettingPop=PopView:subClass("ViewSettingPop")

--Dot=ccui.Text:create()
--Dot:setScale(1)
--Dot:setFontSize(30)
--Dot:setString("@")
--Dot:setTextColor({r=255,g=255,b=255,a=255})
--Dot:retain()
Dot=ccui.ImageView:create()
Dot:loadTexture("common/sliver_ResTop.png")
Dot:setVisible(true)
Dot:setAnchorPoint({x=0,y=0})
Dot:retain()
function ViewSettingPop:close()
    self.dots={}
    if self.dots then
        for k,v in pairs(self.dots) do
            v:release()
        end
        self.dots=nil
    end
    if self.timer then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timer)
        self.timer=nil
    end
    super.close(self)
end
--local rotate=0
function ViewSettingPop:getDot()
    local dot=Dot:clone()
    if self.beeNode then
        dot:setRotation(self.beeNode:getRotation())
    end
    dot:retain()
--    rotate=rotate+45
--    dot:setRotation(rotate)
    print('dot=',dot:getRotation())
    dot:setTouchEnabled(false)
    dot:setColorTransform(cc.colorTransform(1,1,1,0.5))
    return dot
end
function getDis(startPos,newPos)
    return math.sqrt((newPos.x-startPos.x)*(newPos.x-startPos.x)+(newPos.y-startPos.y)*(newPos.y-startPos.y))
end
function ViewSettingPop:initFlower()
    self.flowers={}
    local flower=cc.Sprite:create("common/blue_common.png")
    flower:setScale(1.3)
    flower:setRotation(45)
    flower:setPosition({x=300,y=330})
    self.view:addChild(flower)
    table.insert(self.flowers,flower)
end
function ViewSettingPop:handleData(data)
    print(data.from)
    self:initFlower()
    seekNode("Button_btnClose",seekNode("FileNode_1",self.view)):addClickEventListener(function()
        print("clllllllose")
        self:close()
    end)
    seekNode("playerinfoPop",self.view):setVisible(false)
    seekNode("FileNode_5",self.view):setVisible(false)
    self:touchBee()
end
function ViewSettingPop:clearDots()
    self.beeNode:stopAllActions()
    if self.dots then
        for i=1,#self.dots do
            local dot=self.dots[i]
            dot:release()
            dot:getParent():removeChild(dot);
        end
    end
    self.beePointStack={}
    self.dots={}
end

-----求point绕o点逆时针旋转angle度之后，新点的位置
function getRotatedPos(o,point,angle)
    return
    {
        x=(point.x-o.x)*math.cos(math.rad(angle))-(point.y-o.y)*math.sin(math.rad(angle))+o.x,
        y=(point.x-o.x)*math.sin(math.rad(angle))+(point.y-o.y)*math.cos(math.rad(angle))+o.y,
    }
end

----node里是否包含点point
function containPoint(node,point)
    local size=node:getContentSize()
    size={width=size.width*node:getScaleX(),height=size.height*node:getScaleY()}
    local pos={x=node:getPositionX(),y=node:getPositionY() }
    local anchor=node:getAnchorPoint()
    local rotate=node:getRotation()%360
    local pointRotated=getRotatedPos(pos,point,rotate)
    local rectRotated={x=pos.x-size.width*anchor.x,y=pos.y-size.height*anchor.y,width=size.width,height=size.height}
    if pointRotated.x>=rectRotated.x and pointRotated.x<=rectRotated.x+rectRotated.width and
            pointRotated.y>=rectRotated.y and pointRotated.y<=rectRotated.y+rectRotated.height then
        return true
    end
end

function ViewSettingPop:checkNodeHit(node1,node2)
    node2=self.flowers[1]
    local size1=node1:getContentSize()
    size1={width=size1.width*node1:getScaleX(),height=size1.height*node1:getScaleY()}
    local size2=node2:getContentSize()
    size2={width=size2.width*node2:getScaleX(),height=size2.height*node2:getScaleY()}
    local pos1={x=node1:getPositionX(),y=node1:getPositionY()}
    local pos2={x=node2:getPositionX(),y=node2:getPositionY()}
    local anchor1=node1:getAnchorPoint()
    local anchor2=node2:getAnchorPoint()
    local rotation1=node1:getRotation()%360
    local rotation2=node2:getRotation()%360
    local rect1={x=pos1.x-size1.width*anchor1.x,y=pos1.y-size1.height*anchor1.y,width=size1.width,height=size1.height}
    local rect2={x=pos2.x-size2.width*anchor2.x,y=pos2.y-size2.height*anchor2.y,width=size2.width,height=size2.height}
    local rect1Points={------待优化（数学计算sin和cos部分可以使用同一个值）
        getRotatedPos(pos1,{x=rect1.x,y=rect1.y},360-rotation1),
        getRotatedPos(pos1,{x=rect1.x+rect1.width,y=rect1.y},360-rotation1),
        getRotatedPos(pos1,{x=rect1.x,y=rect1.y+rect1.height},360-rotation1),
        getRotatedPos(pos1,{x=rect1.x+rect1.width,y=rect1.y+rect1.height},360-rotation1),
    }
    local rect2Points={
        getRotatedPos(pos2,{x=rect2.x,y=rect2.y},360-rotation2),
        getRotatedPos(pos2,{x=rect2.x+rect2.width,y=rect2.y},360-rotation2),
        getRotatedPos(pos2,{x=rect2.x,y=rect2.y+rect2.height},360-rotation2),
        getRotatedPos(pos2,{x=rect2.x+rect2.width,y=rect2.y+rect2.height},360-rotation2),
    }
    ---------todo 做一些缓存来加快计算速度
    for _,p in pairs(rect1Points) do
        if containPoint(node2,p) then
            return true
        end
    end
    for _,p in pairs(rect2Points) do
        if containPoint(node1,p) then
            return true
        end
    end
end

function ViewSettingPop:checkHit()
    if self:checkNodeHit(self.beeNode,self.flowers[1]) then
        print("hited")
        local node=self.beeNode:clone()
        node:setColorTransform(cc.colorTransform(1,1,1,0.5))
        self.view:addChild(node)
    end
end

function ViewSettingPop:delOneDot()
    if #self.beePointStack==1 then
        self.lastStartPos=self.beePointStack[1]
    end
    table.remove(self.beePointStack,1)
    local dot=self.dots[1]
    table.remove(self.dots,1)
    dot:release()
    dot:getParent():removeChild(dot);
end
function ViewSettingPop:startTimer()
    local start=os.time()
    local speed=30  ------每一帧走的像素
    local hitDis=0.1  -----碰撞检测的最小距离，小于这个值，则为碰撞
    self:clearDots()
    if not self.timer then
        self.timer=cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
            local point=self.beePointStack[1]
            if not point then return end
            local posx,posy=self.beeNode:getPosition()
            local oriPos={x=posx,y=posy} ----本次计算时的初始点
            local dis2=getDis(point,oriPos)
            ---dis2表示当前速度下，这一帧，bee应该走到哪一个位置，所以这里将dis2算到刚好超过speed
            while dis2<speed and self.beePointStack[2] do
                dis2=dis2+getDis({x=self.beePointStack[1].x,y=self.beePointStack[1].y},
                    {x=self.beePointStack[2].x,y=self.beePointStack[2].y})
                if dis2>=speed then
                    break ;
                else
                    self.beeNode:setPosition(self.beePointStack[1])
                    self:checkHit()
                    self:delOneDot()
                end
            end
            point=self.beePointStack[1]----因为上面的while循环，可能之前的第一个点有变化
            if dis2<speed then-----stack里没有点了
                self.beeNode:setPosition(point)
            else
                posx,posy=self.beeNode:getPosition()
                local k=(dis2-speed)/getDis(point,{x=posx,y=posy})
                local disx=point.x-posx
                local disy=point.y-posy
                local newPos={x=posx+disx*k,y=posy+disy*k}
                self.beeNode:setPosition(newPos)
            end
            self:checkHit()
            self:delOneDot();

        end,0,false)
    end
end
function ViewSettingPop:touchBee()
    local bee=self:getDot()
    bee:setVisible(true)
    bee:setTouchEnabled(true)
    self.view:addChild(bee,10000)
    bee:setPosition({x=50,y=100})
    bee:setColorTransform(cc.colorTransform(1,1,1,1))
    self.beeNode=bee
    bee:setRotation(45)
    local unitDis=5
    local n
    bee:addTouchEventListener(function(node,tp)
        if tp==ccui.TouchEventType.began then
            self.lastStartPos=nil
            local pos=node:getTouchBeganPosition()
            self.clickOffset={x=pos.x-node:getPositionX(),y=pos.y-node:getPositionY()}
            print('origin',node:getPositionX(),node:getPositionY())
            print('ssssssstart',pos.x,pos.y)
            self:startTimer()
        elseif tp==ccui.TouchEventType.moved then
            local startPos
            if #self.beePointStack>0 then
                startPos=self.beePointStack[#self.beePointStack]
            elseif self.lastStartPos then
                startPos=self.lastStartPos
            else
                startPos=node:getTouchBeganPosition()
            end
            local newPos=node:getTouchMovePosition();
            newPos.x=newPos.x-self.clickOffset.x
            newPos.y=newPos.y-self.clickOffset.y
            local moveDes=getDis(startPos,newPos)
--            print("moveeeeeed"..moveDes)
            if moveDes>=unitDis then
                local disx,disy=newPos.x-startPos.x,newPos.y-startPos.y
                n=math.floor(moveDes/unitDis)
                for i=1,n do
                    local unitPos={x=startPos.x+disx*i/n,y=startPos.y+disy*i/n}-------todo 后期改用贝塞尔曲线来计算中间点，现在拐弯处都是尖角
                    table.insert(self.beePointStack,unitPos)
                    local dot=self:getDot()
                    dot:setPosition(unitPos)
                    self.view:addChild(dot,100)
                    table.insert(self.dots,dot)
                end
            end
        elseif tp==ccui.TouchEventType.ended then
            local newPos=node:getTouchEndPosition();
            table.insert(self.beePointStack,{x=newPos.x-self.clickOffset.x,y=newPos.y-self.clickOffset.y})
            print('eeeeeeeeend',newPos.x,newPos.y)
            local dot=self:getDot()
            dot:setPosition(newPos)
            self.view:addChild(dot,100)
            table.insert(self.dots,dot)

        elseif tp==ccui.TouchEventType.canceled then
--            local newPos=node:getTouchMovePosition();
--            print('ccccccccccancle',newPos.x,newPos.y)
--
--            table.insert(self.beePointStack,{x=newPos.x-self.clickOffset.x,y=newPos.y-self.clickOffset.x})
--            local dot=self:getDot()
--            dot:setPosition(newPos)
--            self.view:addChild(dot,100)
--            table.insert(self.dots,dot)

        end
    end)
end