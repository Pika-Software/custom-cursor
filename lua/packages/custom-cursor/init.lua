local gui_IsGameUIVisible = gui.IsGameUIVisible
local PANEL = FindMetaTable( "Panel" )
local IsValid = IsValid
local vgui = vgui

PANEL.__SetCursor = PANEL.__SetCursor or PANEL.SetCursor

local overriding = false
function PANEL:SetCursor( name )
    if overriding then
        ArgAssert( name, 1, "string" )
        self.__cursorType = name

        return PANEL.__SetCursor( self, "blank" )
    end

    return PANEL.__SetCursor( self, name )
end

local cursor = {
    ["visible"] = vgui.CursorVisible(),
    ["type"] = "blank",
    ["x"] = 0,
    ["y"] = 0
}

hook.Add( "PostRenderVGUI", "Drawing", function()
    if gui_IsGameUIVisible() then return end

    overriding = hook.Run( "DrawCursor", cursor )

    if overriding then
        cursor.x, cursor.y = input.GetCursorPos()

        local visible = vgui.CursorVisible()
        cursor.visible = visible

        if visible then
            local pnl = vgui.GetHoveredPanel()
            if IsValid( pnl ) then
                cursor.type = pnl.__cursorType or "arrow"
                PANEL.__SetCursor( pnl, "blank" )
            else
                cursor.type = "arrow"
            end
        end
    end
end )