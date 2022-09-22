--[[
Description: 
A script to export all layers in different trimed SpriteSheet .png files.
Made by Mahjoub.
   - Itch.io: https://mahjoub.itch.io/
   - Twitter: @mahjoub_gamedev
--]]


-- Hides all layers and sublayers inside a group, returning a list with all initial states of each layer's visibility.
function hideLayers(sprite)
    local layerVisibility = {}
    for i,layer in ipairs(sprite.layers) do
       layerVisibility[i] = layer.isVisible
       layer.isVisible = false
       if (layer.isGroup) then
             layerVisibility[i] = hideLayers(layer)
       end
    end
    return layerVisibility
 end

-- Display for debug
function alert(message)
   -- Show error, no sprite active.
   local dlg = Dialog("Debug")
   dlg:label{  id = 0,
               text = message
            }
   dlg:newrow()
   dlg:button{ id = 1,
               text = "Close",
               onclick = function()
                         dlg:close()
                         end
            }
   dlg:show()
   return
 end

-- Identify current sprite.
local sprite = app.activeSprite
if (sprite == nil) then
   -- Show error, no sprite active.
   local dlg = Dialog("Error")
   dlg:label{  id = 0,
               text = "No sprite is currently active. Please, open a sprite first and run the script with it active."
            }
   dlg:newrow()
   dlg:button{ id = 1,
               text = "Close",
               onclick = function()
                         dlg:close()
                         end
            }
   dlg:show()
   return
end

local path,title = sprite.filename:match("^(.+[/\\])(.-).([^.]*)$")
local layerVisibility = hideLayers(sprite)

for i,layer in ipairs(sprite.layers) do
    layer.isVisible = true
    app.command.ExportSpriteSheet {
        ui=false,
        askOverwrite=false,
        type=SpriteSheetType.HORIZONTAL,
        bestFit=false,
        textureFilename=path .. layer.name .. '.png',
        trimSprite=true,
        trim=true,
        trimByGrid=true,
        extrude=false,
        ignoreEmpty=true,
        mergeDuplicates=false,
        openGenerated=false,
    }
    layer.isVisible = false
end