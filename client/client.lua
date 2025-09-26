--==============================================================
-- Clear Vehicle Keys - Client (Locales + AUTO framework + Inventory autodetect)
-- deps: ox_lib (for menu/notify), qb-core or qbx-core or ESX
--       + any inventory (ox_inventory / qs-inventory / qb-inventory / ps-inventory / ESX)
--==============================================================

-- Uses:
--   - Config.* from config.lua
--   - _L(...) from locales.lua
--   - Framework from shared/framework.lua
--   - (No direct inventory usage on client; server handles removal)

local NEARBY_RADIUS = Config.NearbyRadius or 7.5

-- Titles: from locales unless overridden in config
local Titles = {
  MenuTitle   = _L('title_menu'),
  RemoveAll   = _L('title_remove_all'),
  KeepClosest = _L('title_keep_closest'),
  KeepCurrent = _L('title_keep_current'),
}
if type(Config.OverrideTitles) == 'table' then
  for k,v in pairs(Config.OverrideTitles) do
    if v ~= nil then Titles[k] = v end
  end
end

-- Notify adapter (ox / qb / qbx / esx / custom / print)
local function notify(msg, nType)
  local provider = (Config.NotifyProvider or 'ox'):lower()

  if provider == 'ox' and lib and lib.notify then
    lib.notify({ title = Titles.MenuTitle, description = msg, type = nType or 'inform' })
    return
  end

  local fw = Framework.Get()
  if provider == 'qb' or (provider == 'auto' and fw == 'QBCORE') then
    local QBCore = Framework.Core()
    if QBCore and QBCore.Functions and QBCore.Functions.Notify then
      QBCore.Functions.Notify(msg, nType or 'primary')
      return
    end
  end

  if provider == 'qbx' or (provider == 'auto' and fw == 'QBX') then
    local QBX = Framework.Core()
    if QBX and QBX.Functions and QBX.Functions.Notify then
      QBX.Functions.Notify(msg, nType or 'primary')
      return
    end
  end

  if provider == 'esx' or (provider == 'auto' and fw == 'ESX') then
    if ESX and ESX.ShowNotification then
      ESX.ShowNotification(msg)
      return
    end
  end

  if provider == 'custom' and type(Config.CustomNotify) == 'function' then
    Config.CustomNotify(msg, nType)
    return
  end

  print(("[%s] %s"):format(nType or "info", msg))
end

-- Plate helpers
local function normalizePlate(plate)
  if not plate then return nil end
  return (plate:gsub("%s+", "")):upper()
end

local function getVehiclePlate(veh)
  if not veh or veh == 0 then return nil end
  local plate = GetVehicleNumberPlateText(veh)
  if not plate or plate == "" then return nil end
  return plate
end

-- Find closest vehicle around player using game pool
local function getClosestVehicle(radius)
  local ped = PlayerPedId()
  local pcoords = GetEntityCoords(ped)
  local vehicles = GetGamePool('CVehicle')
  local closestVeh, closestDist = 0, (radius or NEARBY_RADIUS) + 0.001

  for _, veh in ipairs(vehicles or {}) do
    local vcoords = GetEntityCoords(veh)
    local dist = #(pcoords - vcoords)
    if dist < closestDist then
      closestVeh = veh
      closestDist = dist
    end
  end
  return closestVeh, closestDist
end

-- Show menu via ox_lib
local function showClearKeysMenu()
  if not lib or not lib.registerContext then
    notify(_L('error_ox_missing'), "error")
    return
  end

  local keyItemName = Config.KeyItem or 'vehiclekeys'
  local ped = PlayerPedId()
  local inVeh = IsPedInAnyVehicle(ped, false)
  local myVeh = inVeh and GetVehiclePedIsIn(ped, false) or 0
  local myPlate = inVeh and getVehiclePlate(myVeh) or nil

  local nearPlate = nil
  do
    local v = getClosestVehicle(NEARBY_RADIUS)
    if v ~= 0 then nearPlate = getVehiclePlate(v) end
  end

  lib.registerContext({
    id = 'capo_clear_keys_menu',
    title = Titles.MenuTitle,
    options = {
      {
        title = '🗑️ ' .. Titles.RemoveAll,
        description = _L('menu_desc_all', keyItemName),
        onSelect = function()
          TriggerServerEvent('capo_clearkeys:clear', 'all', nil, keyItemName)
        end
      },
      {
        title = '🚗 ' .. Titles.KeepClosest,
        description = _L('menu_desc_keep_closest', nearPlate),
        disabled = not nearPlate,
        onSelect = function()
          TriggerServerEvent('capo_clearkeys:clear', 'except', nearPlate, keyItemName)
        end
      },
      {
        title = '🔑 ' .. Titles.KeepCurrent,
        description = _L('menu_desc_keep_current', myPlate),
        disabled = not myPlate,
        onSelect = function()
          TriggerServerEvent('capo_clearkeys:clear', 'except', myPlate, keyItemName)
        end
      },
    }
  })

  lib.showContext('capo_clear_keys_menu')
end

-- Command / keybind
RegisterCommand(Config.Command or 'clearkeys', function()
  showClearKeysMenu()
end, false)

if Config.RegisterKeyMapping then
  RegisterKeyMapping(
    Config.KeyMapping.command or 'clearkeys',
    Config.KeyMapping.description or 'Open Vehicle Keys Manager',
    'keyboard',
    Config.KeyMapping.default or 'F7'
  )
end

-- Optional ox_target hookup
CreateThread(function()
  if Config.UseOxTarget and exports.ox_target then
    exports.ox_target:addGlobalVehicle({
      {
        name = 'capo_clearkeys_target',
        icon = Config.TargetIcon or 'fa-solid fa-key',
        label = Config.TargetLabel or 'Open Vehicle Keys Manager',
        distance = Config.TargetDistance or 2.0,
        onSelect = function(_data)
          showClearKeysMenu()
        end
      }
    })
  end
end)

-- Server feedback
RegisterNetEvent('capo_clearkeys:clear:result', function(removed, kept, mode, keepPlate)
  if mode == 'all' then
    notify(_L('ntf_removed_all', removed), removed > 0 and 'success' or 'error')
  else
    notify(_L('ntf_removed_except', removed, keepPlate), removed > 0 and 'success' or 'error')
  end
end)
