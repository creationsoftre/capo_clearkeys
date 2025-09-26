Inventory = Inventory or {}

local detected = nil

local function state(name)
  local s = GetResourceState(name)
  return s == 'started' or s == 'starting'
end

local function detect()
  if Config.Inventory and Config.Inventory ~= 'AUTO' then
    detected = Config.Inventory
    return detected
  end

  if state('ox_inventory') then
    detected = 'OX'
    return detected
  end
  if state('qs-inventory') then
    detected = 'QS'
    return detected
  end
  -- Treat both qb-inventory and ps-inventory as QB-like
  if state('qb-inventory') or state('ps-inventory') then
    detected = 'QB'
    return detected
  end

  -- Fall back by framework (ESX default)
  local fw = Framework.Get()
  if fw == 'ESX' then
    detected = 'ESX'
  else
    -- If nothing matched, prefer QB path since most qb/qbx store items on PlayerData
    detected = 'QB'
  end
  return detected
end

-- Return detected type (string)
function Inventory.Type()
  return detected or detect()
end

-- Normalize a single item entry to a common schema:
-- { name=string, count=number, slot=number|nil, metadata=table|nil }
local function normItem(name, count, slot, meta)
  return { name = name, count = count or 1, slot = slot, metadata = meta or {} }
end

-- Get a list of items (optionally filtered by `itemName`)
-- RETURNS: array of normalized items
function Inventory.GetItems(src, itemName)
  local kind = Inventory.Type()
  local items = {}

  if kind == 'OX' then
    -- ox_inventory: prefer slot-based search for performance/metadata access
    local ok, res = pcall(function()
      return exports.ox_inventory:Search(src, 'slots', itemName or nil)
    end)
    if ok and type(res) == 'table' then
      for _, it in pairs(res) do
        -- ox returns entries like {slot=, name=, count=, metadata=}
        if (not itemName) or it.name == itemName then
          items[#items+1] = normItem(it.name, it.count or it.amount or 1, it.slot, it.metadata or it.info or it.meta or {})
        end
      end
    else
      -- fallback: full inventory
      local ok2, inv = pcall(function() return exports.ox_inventory:GetInventory(src, false) end)
      if ok2 and inv and inv.items then
        for _, it in pairs(inv.items) do
          if (not itemName) or it.name == itemName then
            items[#items+1] = normItem(it.name, it.count or it.amount or 1, it.slot, it.metadata or it.info or {})
          end
        end
      end
    end

  elseif kind == 'QS' then
    local ok, inv = pcall(function()
      if exports['qs-inventory'] and exports['qs-inventory'].GetInventory then
        return exports['qs-inventory']:GetInventory(src)
      end
      return nil
    end)
    if ok and inv and inv.items then
      for _, it in pairs(inv.items) do
        if it and ((not itemName) or it.name == itemName) then
          items[#items+1] = normItem(it.name, it.count or it.amount or 1, it.slot, it.metadata or it.info or {})
        end
      end
    else
      -- Some QS builds sync with framework items; fallback to QB/ESX style
      local fw = Framework.Get()
      if fw == 'QBCORE' or fw == 'QBX' then
        local Core = Framework.Core()
        local Player = Core and Core.Functions.GetPlayer(src)
        if Player and Player.PlayerData and Player.PlayerData.items then
          for slot, it in pairs(Player.PlayerData.items) do
            if it and ((not itemName) or it.name == itemName) then
              items[#items+1] = normItem(it.name, it.amount or it.count or 1, it.slot or slot, it.info or it.metadata or {})
            end
          end
        end
      elseif fw == 'ESX' then
        local ESX = Framework.Core()
        local xPlayer = ESX and ESX.GetPlayerFromId(src)
        if xPlayer then
          for _, it in pairs(xPlayer.getInventory() or {}) do
            if it and ((not itemName) or it.name == itemName) then
              items[#items+1] = normItem(it.name, it.count or it.amount or it.quantity or 1, it.slot, it.metadata or it.info or {})
            end
          end
        end
      end
    end

  elseif kind == 'QB' then
    local Core = Framework.Core()
    local Player = Core and Core.Functions and Core.Functions.GetPlayer(src)
    local list = Player and Player.PlayerData and Player.PlayerData.items or {}
    for slot, it in pairs(list) do
      if it and ((not itemName) or it.name == itemName) then
        items[#items+1] = normItem(it.name, it.amount or it.count or 1, it.slot or slot, it.info or it.metadata or {})
      end
    end

  elseif kind == 'ESX' then
    local ESX = Framework.Core()
    local xPlayer = ESX and ESX.GetPlayerFromId(src)
    if xPlayer then
      for _, it in pairs(xPlayer.getInventory() or {}) do
        if it and ((not itemName) or it.name == itemName) then
          items[#items+1] = normItem(it.name, it.count or it.amount or it.quantity or 1, it.slot, it.metadata or it.info or {})
        end
      end
    end
  end

  return items
end

-- Remove an item (returns true/false)
function Inventory.RemoveItem(src, name, amount, slot)
  local kind = Inventory.Type()
  amount = amount or 1

  if kind == 'OX' then
    local ok, res = pcall(function()
      return exports.ox_inventory:RemoveItem(src, name, amount, nil, slot)
    end)
    return ok and res or false
  elseif kind == 'QS' then
    local ok, res = pcall(function()
      return exports['qs-inventory']:RemoveItem(src, name, amount, slot)
    end)
    return ok and (res ~= false)
  elseif kind == 'QB' then
    local Core = Framework.Core()
    local Player = Core and Core.Functions and Core.Functions.GetPlayer(src)
    if Player and Player.Functions and Player.Functions.RemoveItem then
      return Player.Functions.RemoveItem(name, amount, slot) or false
    end
    return false
  elseif kind == 'ESX' then
    local ESX = Framework.Core()
    local xPlayer = ESX and ESX.GetPlayerFromId(src)
    if xPlayer and xPlayer.removeInventoryItem then
      xPlayer.removeInventoryItem(name, amount)
      return true
    end
    return false
  end

  return false
end
