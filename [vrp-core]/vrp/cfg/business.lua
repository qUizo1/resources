
local cfg = {}

-- minimum capital to open a business
cfg.minimum_capital = 0

-- capital transfer reset interval in minutes
-- default: reset every 24h
cfg.transfer_reset_interval = 24*60

-- {ent,cfg} will fill cfg.title, cfg.pos
cfg.commerce_chamber_map_entity = {"PoI", {blip_id = 431, blip_color = 70, marker_id = 1}}

-- positions of commerce chambers
cfg.commerce_chambers = {
}

return cfg
