--==============================================================
-- Clear Vehicle Keys - Server (Framework + Inventory autodetect)
-- deps: qb-core or qbx-core or ESX
--       + any inventory (ox_inventory / qs-inventory / qb-inventory / ps-inventory / ESX)
--==============================================================

-- Uses:
--   - Config.* from config.lua
--   - Framework from shared/framework.lua
--   - Inventory.* from shared/inventory.lua

local function normalizePlate(plate)
    if not plate then return nil end
    return (plate:gsub("%s+", "")):upper()
  end
  
  local function readPlateFromMeta(meta)
    if not meta then return nil end
    local keys = Config.PlateMetaKeys or { 'plate', 'vehplate', 'vehPlate', 'plateText', 'Plate' }
    for _, k in ipairs(keys) do
      local v = meta[k]
      if v and v ~= '' then return v end
    end
    return meta.plate or meta.Plate or meta.vehplate or meta.vehPlate or meta.plateText
  end
  
  RegisterNetEvent('capo_clearkeys:clear', function(mode, keepPlate, keyItemName)
    local src = source
    local itemName = keyItemName or (Config and Config.KeyItem) or 'vehiclekeys'
    local keepPlateN = normalizePlate(keepPlate)
    local removed, kept = 0, 0
  
    -- Get all key items no matter the active inventory
    local items = Inventory.GetItems(src, itemName)
  
    for _, it in ipairs(items) do
      local info = it.metadata or {}
      local iPlate = readPlateFromMeta(info)
      local iPlateN = normalizePlate(iPlate)
  
      local keepThis = (mode == 'except') and (iPlateN ~= nil and iPlateN == keepPlateN)
      if keepThis then
        kept = kept + (it.count or 1)
      else
        local ok = Inventory.RemoveItem(src, itemName, it.count or 1, it.slot)
        if ok then
          removed = removed + (it.count or 1)
        end
      end
    end
  
    TriggerClientEvent('capo_clearkeys:clear:result', src, removed, kept, mode, keepPlate or "")
  end)

local requiredName = "capo_clearkeys"
if GetCurrentResourceName() ~= requiredName then
    if IsDuplicityVersion() then
        print("^1[SECURITY]^7 Wrong resource name: " .. GetCurrentResourceName())
        StopResource(GetCurrentResourceName())
    else
        CreateThread(function()
            while true do
                Wait(1000)
                print("^1[SECURITY]^7 This client resource is misnamed. Please rename to " .. requiredName)
            end
        end)
    end
    return
end

  