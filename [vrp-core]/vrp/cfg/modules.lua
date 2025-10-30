-- Loaded client-side and server-side.
--
-- Enable/disable modules (some may be required by others).
-- It's recommended to disable things from the modules configurations directly if possible.

local modules = {
  map = true,
  gui = true,
  audio = true,
  login = true,
  admin = true,
  identity = true,
  group = true,
  inventory = true,
  player_state = true,
  survival = true,
  money = true,
  emotes = false,
  atm = false,
  phone = true,
  aptitude = true,
  shop = true,
  skinshop = false,
  mission = true,
  cloak = true,
  garage = true,
  business = false,
  transformer = true,
  hidden_transformer = true,
  home = false,
  home_components = false,
  police = true,
  radio = true,
  ped_blacklist = false,
  veh_blacklist = false,
  edible = true,
  warp = true,
  --
  profiler = false
}

return modules
