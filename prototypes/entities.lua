local config = require("prototypes.config")

local color_entities = {}

-- create new colored indicator lamp entities
for color,rgb in pairs(config.colors) do
  local lamp = util.table.deepcopy(data.raw["lamp"]["small-lamp"])
  lamp.name                      = "small-lamp-"..color
  lamp.icons = {
    {
      icon = "__base__/graphics/icons/small-lamp.png",
      icon_mipmaps = 4,
      icon_size = 64,
    },
    {
      icon = "__color-coding-plus__/graphics/lamp/small-lamp-bulb.png",
      icon_mipmaps = 4,
      icon_size = 64,
      tint = {
        r = rgb.player_color["r"] * 0.9,
        g = rgb.player_color["g"] * 0.9,
        b = rgb.player_color["b"] * 0.9,
        a = 0.5 + 0.5*rgb.player_color["a"],
      }
    }
  }
  lamp.map_color = {
    r = 0.6 + (rgb.player_color["r"] * 0.4),
    g = 0.6 + (rgb.player_color["g"] * 0.4),
    b = 0.6 + (rgb.player_color["b"] * 0.4),
    a = 1
  }
  lamp.icon = nil
  lamp.icon_mipmaps = nil
  lamp.icon_size = nil
  lamp.signal_to_color_mapping   = nil

  lamp.picture_off = {
    layers = {
      {
        filename = "__color-coding-plus__/graphics/lamp/lamp.png",
        priority = "high",
        width = 42,
        height = 36,
        frame_count = 1,
        axially_symmetrical = false,
        direction_count = 1,
        shift = util.by_pixel(0,3),
        hr_version =
        {
          filename = "__color-coding-plus__/graphics/lamp/hr-lamp.png",
          priority = "high",
          width = 83,
          height = 70,
          frame_count = 1,
          axially_symmetrical = false,
          direction_count = 1,
          shift = util.by_pixel(0.25,3),
          scale = 0.5
        }
      },
      {
        filename = "__color-coding-plus__/graphics/lamp/lamp-bulb.png",
        priority = "high",
        width = 42,
        height = 36,
        frame_count = 1,
        axially_symmetrical = false,
        direction_count = 1,
        shift = util.by_pixel(0,3),
        hr_version =
        {
          filename = "__color-coding-plus__/graphics/lamp/hr-lamp-bulb.png",
          priority = "high",
          width = 83,
          height = 70,
          frame_count = 1,
          axially_symmetrical = false,
          direction_count = 1,
          shift = util.by_pixel(0.25,3),
          scale = 0.5
        }
      },
      lamp.picture_off.layers[2] -- shadow
    }
  }

  local wall = util.table.deepcopy(data.raw["wall"]["stone-wall"])
  wall.name = "stone-wall-"..color
  wall.minable["result"]  = "stone-wall-"..color
  wall.icons = {
    {
      icon = wall.icon,
      icon_mipmaps = wall.icon_mipmaps,
      icon_size = wall.icon_size,
      tint = {
        r = rgb.player_color["r"],
        g = rgb.player_color["g"],
        b = rgb.player_color["b"],
        a = rgb.player_color["a"],
      }
    }
  }
  wall.map_color = {
    r = (rgb.player_color["r"] * 0.25),
    g = (rgb.player_color["g"] * 0.25),
    b = (rgb.player_color["b"] * 0.25),
    a = 1
  }
  wall.icon = nil
  wall.icon_mipmaps = nil
  wall.icon_size = nil

  local tint = {
    r = rgb.player_color["r"],
    g = rgb.player_color["g"],
    b = rgb.player_color["b"],
    --a = rgb.chat_color["a"],
  }

  for _,p in pairs(wall.pictures) do
    if p.layers then
      p.layers[1].tint = tint
      p.layers[1].hr_version.tint = tint
    elseif p.filename then
      p.tint = tint
      p.hr_version.tint = tint
    end
  end

  if color == "black" then
    --override blacklight color without affecting global definition of black
    lamp.picture_on.tint = config.blacklight.on_tint
    lamp.picture_on.hr_version.tint = config.blacklight.on_tint
    lamp.picture_off.layers[2].tint = config.blacklight.off_tint
    lamp.picture_off.layers[2].hr_version.tint = config.blacklight.off_tint
  else
    lamp.picture_on.tint = tint
    lamp.picture_on.hr_version.tint = tint
    lamp.picture_off.layers[2].tint = tint
    lamp.picture_off.layers[2].hr_version.tint = tint
  end
  
  lamp.energy_usage_per_tick     = "250W"
  lamp.light["size"]             = 5
  lamp.light["intensity"]        = 1
  lamp.circuit_wire_max_distance = 10
  lamp.light["color"]            = {
      r                          = rgb.chat_color["r"],
      g                          = rgb.chat_color["g"],
      b                          = rgb.chat_color["b"],
  }
  lamp.minable["result"]  = "small-lamp-"..color
  table.insert(color_entities,lamp)
  table.insert(color_entities,wall)
end

data:extend(color_entities)
