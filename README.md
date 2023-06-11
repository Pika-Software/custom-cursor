## Example
```lua
local arrows = {
    ["arrow"] = Material( "icon16/bullet_white.png", "smooth mips" ),
    ["hand"] = Material( "icon16/bullet_blue.png", "smooth mips" )
}

hook.Add( "DrawCursor", "test", function( cursor )
    if cursor.visible then

        surface.SetMaterial( arrows[ cursor.type ] or arrows.arrow )

        surface.SetDrawColor( 0, 0, 0 )
        surface.DrawTexturedRect( cursor.x - 16 / 2 - 2, cursor.y - 16 / 2 - 2, 16 + 4, 16 + 4 )

        surface.SetDrawColor( 255, 255, 255 )
        surface.DrawTexturedRect( cursor.x - 16 / 2, cursor.y - 16 / 2, 16, 16 )
    end

    return true
end )
```