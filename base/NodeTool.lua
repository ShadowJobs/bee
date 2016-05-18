--
-- Created by IntelliJ IDEA.
-- User: playcrab
-- Date: 27/4/16
-- Time: 下午4:23
-- To change this template use File | Settings | File Templates.
--

-- CastNodeType.lua

function gCastNodeToWidget(node)
    return ccui.Helper:CastNodeToWidget(node)
end

function gCastNodeToVBox(node)
    return ccui.Helper:CastNodeToVBox(node)
end
function gCastNodeToTextBMFont(node)
    return ccui.Helper:CastNodeToTextBMFont(node)
end
function gCastNodeToTextAtlas(node)
    return ccui.Helper:CastNodeToTextAtlas(node)
end
function gCastNodeToText(node)
    return ccui.Helper:CastNodeToText(node)
end
function gCastNodeToSlider(node)
    return ccui.Helper:CastNodeToSlider(node)
end
function gCastNodeToScrollView(node)
    return ccui.Helper:CastNodeToScrollView(node)
end
function gCastNodeToRichText(node)
    return ccui.Helper:CastNodeToRichText(node)
end
function gCastNodeToRelativeBox(node)
    return ccui.Helper:CastNodeToRelativeBox(node)
end
function gCastNodeToRadioButton(node)
    return ccui.Helper:CastNodeToRadioButton(node)
end
function gCastNodeToPageView(node)
    return ccui.Helper:CastNodeToPageView(node)
end
function gCastNodeToLoadingBar(node)
    return ccui.Helper:CastNodeToLoadingBar(node)
end
function gCastNodeToListView(node)
    return ccui.Helper:CastNodeToListView(node)
end
function gCastNodeToLayout(node)
    return ccui.Helper:CastNodeToLayout(node)
end
function gCastNodeToImageView(node)
    return ccui.Helper:CastNodeToImageView(node)
end
function gCastNodeToHBox(node)
    return ccui.Helper:CastNodeToHBox(node)
end
function gCastNodeToCheckBox(node)
    return ccui.Helper:CastNodeToCheckBox(node)
end
function gCastNodeToButton(node)
    return ccui.Helper:CastNodeToButton(node)
end

function gCastNodeToSprite(node)
    return ccui.Helper:CastNodeToSprite(node)
end

function gCastNodeToTextField(node)
    return ccui.Helper:CastNodeToTextField(node)
end
local lUITypeFunctionTable = {
    gCastNodeToWidget,
    gCastNodeToVBox,
    gCastNodeToTextBMFont,
    gCastNodeToTextAtlas,
    gCastNodeToText,
    gCastNodeToSlider,
    gCastNodeToScrollView,
    gCastNodeToRichText,
    gCastNodeToRelativeBox,
    gCastNodeToRadioButton,
    gCastNodeToPageView,
    gCastNodeToLoadingBar,
    gCastNodeToListView,
    gCastNodeToLayout,
    gCastNodeToImageView,
    gCastNodeToHBox,
    gCastNodeToCheckBox,
    gCastNodeToButton
}
lUITypeFunctionTable["Sprite"] = gCastNodeToSprite
lUITypeFunctionTable["TextField"] = gCastNodeToTextField



function gSeekUIByName(parent, uiName)
    local uiNode = parent:seekChildByName(uiName)
    -- assert(uiNode ~= nil,"can not find UIName called "..uiName)
    if uiNode then
        return gAutoConvertNode(uiNode)
    else
        return nil
    end
end

function gGetUIByName(parent, uiName)
    local uiNode = parent:getChildByName(uiName)
    -- assert(uiNode ~= nil,"can not find UIName called "..uiName)
    return gAutoConvertNode(uiNode)
end

function gAutoConvertNode(uiNode)
    if not uiNode then
        return nil
    end
    -- 不是所有的node 都有 getUITypeName这个方法，没有该方法的node 不进行向下转换 需要手动类型转换
    if uiNode.getUITypeName == nil then
        return uiNode
    end
    local typeName = uiNode:getUITypeName()
    -- pclog(typeName)
    local funcName
    if type(typeName)=="string" then
        funcName = lUITypeFunctionTable[typeName]
    else
        funcName = lUITypeFunctionTable[tonumber(typeName) + 1]
    end
    if funcName == nil then
        print(" no type ")
    end
    return funcName(uiNode)
end



function seekNode(name,parent)
    --    if not parent then
    --        parent=self.view
    --    end
    local node=parent:seekChildByName(name)
    if node then
        return gAutoConvertNode(node)
    end
end