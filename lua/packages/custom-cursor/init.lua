local gui_IsGameUIVisible = gui.IsGameUIVisible
local PANEL = FindMetaTable( 'Panel' )
local IsValid = IsValid
local vgui = vgui

PANEL.__SetCursor = PANEL.__SetCursor or PANEL.SetCursor

local overriding = false
function PANEL:SetCursor( name )
    if overriding then
        ArgAssert( name, 1, 'string' )
        self.__cursorType = name

        return PANEL.__SetCursor( self, 'blank' )
    end

    return PANEL.__SetCursor( self, name )
end

local cursor = {
    ['visible'] = vgui.CursorVisible(),
    ['type'] = 'blank',
    ['x'] = 0,
    ['y'] = 0
}

hook.Add( 'PostRenderVGUI', 'gpm.custom_cursor', function()
    if gui_IsGameUIVisible() then return end

    overriding = hook.Run( 'DrawCursor', cursor )

    if overriding then
        cursor.x, cursor.y = input.GetCursorPos()

        local visible = vgui.CursorVisible()
        cursor.visible = visible

        if visible then
            local pnl = vgui.GetHoveredPanel()
            if IsValid( pnl ) then
                cursor.type = pnl.__cursorType or 'arrow'
                PANEL.__SetCursor( pnl, 'blank' )
            else
                cursor.type = 'arrow'
            end
        end
    end
end )

-- Example Usage
--[[

local arrows = {
    ['arrow'] = Material( 'icon16/bullet_white.png', 'smooth mips' ),
    ['hand'] = Material( 'icon16/bullet_blue.png', 'smooth mips' )
}

hook.Add( 'DrawCursor', 'test', function( cursor )
    if cursor.visible then

        surface.SetMaterial( arrows[ cursor.type ] or arrows.arrow )

        surface.SetDrawColor( 0, 0, 0 )
        surface.DrawTexturedRect( cursor.x - 16 / 2 - 2, cursor.y - 16 / 2 - 2, 16 + 4, 16 + 4 )

        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawTexturedRect( cursor.x - 16 / 2, cursor.y - 16 / 2, 16, 16 )
    end

    return true
end )

--]]