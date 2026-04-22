Config = {}

--[[
    Core behavior
]]
Config.Debug = false
Config.TabletItem = 'tablet'
Config.RequiredItems = {
    underground = 'ugchip',
    hq = 'hqchip'
}

--[[
    Framework selection
    Options: 'auto', 'qbcore', 'qbox', 'esx', 'standalone'
]]
Config.Framework = 'auto'

Config.FrameworkResources = {
    qbcore = 'qb-core',
    qbox = 'qbx_core',
    esx = 'es_extended'
}

--[[
    Inventory selection
    Options: 'auto', 'qb-inventory', 'ox_inventory', 'esx_inventory', 'qs-inventory', 'standalone'
]]
Config.Inventory = 'auto'

Config.InventoryResources = {
    ['qb-inventory'] = 'qb-inventory',
    ['ox_inventory'] = 'ox_inventory',
    ['esx_inventory'] = 'esx_inventory',
    ['qs-inventory'] = 'qs-inventory'
}

--[[
    Fuel selection
    Options: 'auto', 'LegacyFuel', 'cdn-fuel', 'ox_fuel', 'qb-fuel', 'standalone'
    Note: fuel is optional for this script, but adapter is provided for integration/extensions.
]]
Config.Fuel = 'auto'

Config.FuelResources = {
    ['LegacyFuel'] = 'LegacyFuel',
    ['cdn-fuel'] = 'cdn-fuel',
    ['ox_fuel'] = 'ox_fuel',
    ['qb-fuel'] = 'qb-fuel'
}

Config.Progressbar = {
    enabled = true,
    fallbackDuration = 2500
}

Config.Defaults = {
    background = 'assets/backgroundimage/OIP.jpg'
}
