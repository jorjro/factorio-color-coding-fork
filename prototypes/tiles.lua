local config = require("prototypes.config")

local color_tiles = {}
local count = 0
for colors,rgb in pairs(config.colors) do
  count = count + 1
end
local stone_layer = 64
local concrete_layer = 64 + count
local rconcrete_layer = 64 + count*2

local function tile(name,base,color,rgb,concrete,itemname)
  local t = util.table.deepcopy(data.raw["tile"][base])
  t.name = name.."-"..color
  t.next_direction = nil
  --t.transition_merges_with_tile = name
  
  if color == "white" or color == "black" then
    t.variants.side = {
      picture = "__color-coding-plus__/graphics/tiles/"..color.."/concrete-side.png",
      count = 16,
      size = 4,
      hr_version = {
        picture = "__color-coding-plus__/graphics/tiles/"..color.."/hr-concrete-side.png",
        count = 16,
        size = 4,
        scale = 0.5
      }
    }
    t.variants.inner_corner = {
      picture = "__color-coding-plus__/graphics/tiles/"..color.."/concrete-inner-corner.png",
      count = 16,
      size = 4,
      hr_version = {
        picture = "__color-coding-plus__/graphics/tiles/"..color.."/hr-concrete-inner-corner.png",
        count = 16,
        size = 4,
        scale = 0.5
      }
    }
    t.variants.outer_corner = {
      picture = "__color-coding-plus__/graphics/tiles/"..color.."/concrete-outer-corner.png",
      count = 8,
      size = 4,
      hr_version = {
        picture = "__color-coding-plus__/graphics/tiles/"..color.."/hr-concrete-outer-corner.png",
        count = 8,
        size = 4,
        scale = 0.5
      }
    }
    t.variants.o_transition = {
      picture = "__color-coding-plus__/graphics/tiles/"..color.."/concrete-o.png",
      count = 4,
      size = 1,
      hr_version = {
        picture = "__color-coding-plus__/graphics/tiles/"..color.."/hr-concrete-o.png",
        count = 4,
        size = 1,
        scale = 0.5
      }
    }
    t.variants.u_transition = {
      picture = "__color-coding-plus__/graphics/tiles/"..color.."/concrete-u.png",
      count = 8,
      size = 4,
      hr_version = {
        picture = "__color-coding-plus__/graphics/tiles/"..color.."/hr-concrete-u.png",
        count = 8,
        size = 4,
        scale = 0.5
      }
    }
    t.variants.material_background.picture = "__color-coding-plus__/graphics/tiles/"..color.."/"..name..".png"
    t.variants.material_background.hr_version.picture = "__color-coding-plus__/graphics/tiles/"..color.."/hr-"..name..".png"
  else
    if concrete then
      t.variants.material_background.picture = "__base__/graphics/terrain/concrete/"..name..".png"
      t.variants.material_background.hr_version.picture = "__base__/graphics/terrain/concrete/hr-"..name..".png"
    else
      t.variants.material_background = {
        picture = "__color-coding-plus__/graphics/tiles/plain/"..name..".png",
        count = 8,
        size = 1,
        hr_version =
        {
          picture = "__color-coding-plus__/graphics/tiles/plain/hr-"..name..".png",
          count = 8,
          size = 1,
          scale = 0.5
        }
      }
    end
    
  t.tint = rgb.chat_color
  end
  t.map_color = rgb.player_color
  t.minable["result"] = (itemname or name).."-"..color
  return t
end

for color,rgb in pairs(config.colors) do
  local concrete = tile("concrete","concrete",color,rgb,true)
  concrete.layer = concrete_layer
  table.insert(color_tiles, concrete)
  
  local rconcrete = tile("refined-concrete","refined-concrete",color,rgb,true)
  rconcrete.layer = rconcrete_layer
  rconcrete.map_color = {
    r = (rgb.player_color["r"] * 0.5),
    g = (rgb.player_color["g"] * 0.5),
    b = (rgb.player_color["b"] * 0.5),
    a = rgb.player_color["a"]
  }
  table.insert(color_tiles,rconcrete)

  local stonepath = tile("stone-path","concrete",color,rgb,false,"stone-brick")
  stonepath.layer = stone_layer
  stonepath.map_color = {
    r = 0.5 + (rgb.player_color["r"] * 0.5),
    g = 0.5 + (rgb.player_color["g"] * 0.5),
    b = 0.5 + (rgb.player_color["b"] * 0.5),
    a = rgb.player_color["a"]
  }
  table.insert(color_tiles,stonepath)

  stone_layer = stone_layer + 1
  concrete_layer = concrete_layer + 1
  rconcrete_layer = rconcrete_layer + 1
end

data:extend(color_tiles)
