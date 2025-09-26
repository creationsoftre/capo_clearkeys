Config = Config or {}

-- === Framework selection ===
-- 'AUTO' | 'QBCORE' | 'QBX' | 'ESX'
Config.Framework = 'AUTO'

-- === Key item ===
Config.KeyItem = 'vehiclekeys'

-- === Plate metadata keys to try (in order)
Config.PlateMetaKeys = { 'plate', 'vehplate', 'vehPlate', 'plateText', 'Plate' }

-- === Radius / targeting ===
Config.NearbyRadius = 7.5

-- === Command + Keybind ===
Config.Command = 'clearkeys'
Config.RegisterKeyMapping = true
Config.KeyMapping = {
  command = 'clearkeys',
  default = 'F7',
  description = 'Open Vehicle Keys Manager'
}

-- === UI / Interaction ===
Config.UseOxTarget = false
Config.TargetIcon = 'fa-solid fa-key'
Config.TargetLabel = 'Open Vehicle Keys Manager'
Config.TargetDistance = 2.0

-- === Notifications ===
-- 'ox' | 'qb' | 'qbx' | 'esx' | 'print' | 'custom'
Config.NotifyProvider = 'ox'
Config.CustomNotify = function(message, nType)
  print(('[%s] %s'):format(nType or 'info', message))
end

-- === Locales ===
Config.Locale = 'auto'
Config.OverrideTitles = nil

-- === Inventory autodetection ===
-- Leave 'AUTO' to let the script pick one by running resources.
-- You may force: 'OX' | 'QS' | 'QB' | 'ESX'
Config.Inventory = 'AUTO'
