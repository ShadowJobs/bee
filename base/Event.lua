--
-- Created by IntelliJ IDEA.
-- User: playcrab
-- Date: 26/4/16
-- Time: 下午8:43
-- To change this template use File | Settings | File Templates.
--
Event=Obj:subClass("Event")
Event.static.hash={}
function Event:init(name,data)
    self.name=name
    self.data=data or {}
end

function Event:stop()
    self.stoped=true
end


PopEvent=Event:subClass("PopupEvent")
function PopEvent:init(csbname,codename,data)
    self.csbName=csbname
    self.codeName=codename
    super.init(self,"ShowPop",data)

end