Framework = Framework or {}

-- Detect running framework once and cache
local detected = nil
function Framework.Get()
  if detected ~= nil then return detected end

  -- Respect explicit config override if set
  if Config and Config.Framework and Config.Framework ~= 'AUTO' then
    detected = Config.Framework
    return detected
  end

  -- Try QB Core (legacy) first
  if GetResourceState('qb-core') == 'started' and exports['qb-core'] and exports['qb-core'].GetCoreObject then
    detected = 'QBCORE'
    return detected
  end

  -- Try Qbox / qbx-core
  if GetResourceState('qbx-core') == 'started' and exports['qbx-core'] and exports['qbx-core'].GetCoreObject then
    detected = 'QBX'
    return detected
  end

  -- Try ESX
  if GetResourceState('es_extended') == 'started' then
    detected = 'ESX'
    return detected
  end

  detected = 'NONE'
  return detected
end

function Framework.Core()
  local fw = Framework.Get()
  if fw == 'QBCORE' then
    return exports['qb-core']:GetCoreObject()
  elseif fw == 'QBX' then
    return exports['qbx-core']:GetCoreObject()
  elseif fw == 'ESX' then
    return exports['es_extended']:getSharedObject()
  end
  return nil
end
