BH_VERSION = "1.1.1"

require('libraries/timers')
require('libraries/selection')
require('libraries/keyvalues')
require('stats')
if not BuildingHelper then
    BuildingHelper = class({})
end

--[[
    BuildingHelper Init
    * Loads Key Values into the BuildingAbilities
]]--
function BuildingHelper:Init()

    -- building_settings nettable from buildings.kv
    BuildingHelper:LoadSettings()

    BuildingHelper:print("BuildingHelper Init")
    BuildingHelper.Players = {} -- Holds a table for each player ID
    BuildingHelper.Dummies = {} -- Holds up to one entity for each building name
    BuildingHelper.Grid = {}    -- Construction grid
    BuildingHelper.Terrain = {} -- Terrain grid, this only changes when a tree is cut
    BuildingHelper.Encoded = "" -- String containing the base terrain, networked to clients
    BuildingHelper.squareX = 0  -- Number of X grid points
    BuildingHelper.squareY = 0  -- Number of Y grid points

    -- Grid States
    BuildingHelper.GridTypes = {}
    BuildingHelper.NextGridValue = 1
    BuildingHelper:NewGridType("BLOCKED")
    BuildingHelper:NewGridType("BUILDABLE")

    -- Panorama Event Listeners
    CustomGameEventManager:RegisterListener("building_helper_build_command", Dynamic_Wrap(BuildingHelper, "BuildCommand"))
    CustomGameEventManager:RegisterListener("building_helper_cancel_command", Dynamic_Wrap(BuildingHelper, "CancelCommand"))
    CustomGameEventManager:RegisterListener("building_helper_repair_command", Dynamic_Wrap(BuildingHelper, "RepairCommand"))
    CustomGameEventManager:RegisterListener("selection_update", Dynamic_Wrap(BuildingHelper, 'OnSelectionUpdate')) --Hook selection library
    CustomGameEventManager:RegisterListener("gnv_request", Dynamic_Wrap(BuildingHelper, "SendGNV"))
    CustomGameEventManager:RegisterListener("rightclick_order", Dynamic_Wrap(BuildingHelper, "RightClickOrder"))
    CustomGameEventManager:RegisterListener("give_resources", Dynamic_Wrap(BuildingHelper, "GiveResources"))
    CustomGameEventManager:RegisterListener("choose_help_side", Dynamic_Wrap(BuildingHelper, "ChooseHelpSide"))
     -- Game Event Listeners
    ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(BuildingHelper, 'OnGameRulesStateChange'), self)
    ListenToGameEvent('npc_spawned', Dynamic_Wrap(BuildingHelper, 'OnNPCSpawned'), self)
    ListenToGameEvent('entity_killed', Dynamic_Wrap(BuildingHelper, 'OnEntityKilled'), self)
    ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(BuildingHelper, 'OnItemPurchase'), self)
    if BuildingHelper.Settings["UPDATE_TREES"] then
        ListenToGameEvent('tree_cut', Dynamic_Wrap(BuildingHelper, 'OnTreeCut'), self)
    end
    if BuildingHelper.Settings["REPAIR_PATH"] then
        require(BuildingHelper.Settings["REPAIR_PATH"])
    end
    if BuildingHelper.Settings["BUILD_PATH"] then
        require(BuildingHelper.Settings["BUILD_PATH"])
    end

    -- Lua Modifiers
    LinkLuaModifier("modifier_building", "libraries/modifiers/modifier_building", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_disconnected", "libraries/modifiers/modifier_disconnected", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_out_of_world", "libraries/modifiers/modifier_out_of_world", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_builder_hidden", "libraries/modifiers/modifier_builder_hidden", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_repairing", "libraries/modifiers/repair_modifiers", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_builder_repairing", "libraries/modifiers/repair_modifiers", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_minimap", "libraries/modifiers/modifier_minimap", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_tree_cut", "libraries/modifiers/modifier_tree_cut", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_poison", "libraries/modifiers/modifier_poison", LUA_MODIFIER_MOTION_NONE)

    require("libraries/modifiers/grid_modifiers")
    
    BuildingHelper:ParseKV()

    self:HookBoilerplate()


    --GameRules.TrollWin = false
end
function BuildingHelper:HookBoilerplate()
    if not __ACTIVATE_HOOK then
        __ACTIVATE_HOOK = {funcs={}}
        setmetatable(__ACTIVATE_HOOK, {
          __call = function(t, func)
            table.insert(t.funcs, func)
          end
        })

        debug.sethook(function(...)
          local info = debug.getinfo(2)
          local src = tostring(info.short_src)
          local name = tostring(info.name)
          if name ~= "__index" then
            if string.find(src, "addon_game_mode") then
              if GameRules:GetGameModeEntity() then
                for _, func in ipairs(__ACTIVATE_HOOK.funcs) do
                  local status, err = pcall(func)
                  if not status then
                    print("__ACTIVATE_HOOK callback error: " .. err)
                  end
                end

                debug.sethook(nil, "c")
              end
            end
          end
        end, "c")
    end

    -- Hook the order filter
    __ACTIVATE_HOOK(function()
        local mode = GameRules:GetGameModeEntity()
        mode:SetExecuteOrderFilter(Dynamic_Wrap(BuildingHelper, 'OrderFilter'), BuildingHelper)
        self.oldFilter = mode.SetExecuteOrderFilter
        mode.SetExecuteOrderFilter = function(mode, fun, context)
            BuildingHelper.nextFilter = fun
            BuildingHelper.nextContext = context
        end
    end)
end

function BuildingHelper:LoadSettings()
    BuildingHelper.Settings = LoadKeyValues("scripts/kv/building_settings.kv")
    
    BuildingHelper.Settings["TESTING"] = tobool(BuildingHelper.Settings["TESTING"])
    BuildingHelper.Settings["RECOLOR_BUILDING_PLACED"] = tobool(BuildingHelper.Settings["RECOLOR_BUILDING_PLACED"])
    BuildingHelper.Settings["UPDATE_TREES"] = tobool(BuildingHelper.Settings["UPDATE_TREES"])
    BuildingHelper.Settings["DISABLE_BUILDING_TURNING"] = tobool(BuildingHelper.Settings["DISABLE_BUILDING_TURNING"])
    BuildingHelper.Settings["RIGHT_CLICK_REPAIR"] = tobool(BuildingHelper.Settings["RIGHT_CLICK_REPAIR"])
    BuildingHelper.Settings["MAGIC_IMMUNE_BUILDINGS"] = tobool(BuildingHelper.Settings["MAGIC_IMMUNE_BUILDINGS"])
    BuildingHelper.Settings["DENIABLE_BUILDINGS"] = tobool(BuildingHelper.Settings["DENIABLE_BUILDINGS"])

    CustomNetTables:SetTableValue("building_settings", "grid_alpha", { value = BuildingHelper.Settings["GRID_ALPHA"] })
    CustomNetTables:SetTableValue("building_settings", "alt_grid_alpha", { value = BuildingHelper.Settings["ALT_GRID_ALPHA"] })
    CustomNetTables:SetTableValue("building_settings", "alt_grid_squares", { value = BuildingHelper.Settings["ALT_GRID_SQUARES"] })
    CustomNetTables:SetTableValue("building_settings", "range_overlay_alpha", { value = BuildingHelper.Settings["RANGE_OVERLAY_ALPHA"] })
    CustomNetTables:SetTableValue("building_settings", "model_alpha", { value = BuildingHelper.Settings["MODEL_ALPHA"] })
    CustomNetTables:SetTableValue("building_settings", "recolor_ghost", { value = tobool(BuildingHelper.Settings["RECOLOR_GHOST_MODEL"]) })
    CustomNetTables:SetTableValue("building_settings", "turn_red", { value = tobool(BuildingHelper.Settings["RED_MODEL_WHEN_INVALID"]) })
    CustomNetTables:SetTableValue("building_settings", "permanent_alt_grid", { value = tobool(BuildingHelper.Settings["PERMANENT_ALT_GRID"]) })
    CustomNetTables:SetTableValue("building_settings", "update_trees", { value = BuildingHelper.Settings["UPDATE_TREES"] })
    CustomNetTables:SetTableValue("building_settings", "right_click_repair", { value = BuildingHelper.Settings["RIGHT_CLICK_REPAIR"] })


    if BuildingHelper.Settings["HEIGHT_RESTRICTION"] and BuildingHelper.Settings["HEIGHT_RESTRICTION"] ~= "" then
        CustomNetTables:SetTableValue("building_settings", "height_restriction", { value = BuildingHelper.Settings["HEIGHT_RESTRICTION"] })
    end
end

function BuildingHelper:ParseKV()
    for name,info in pairs(KeyValues.All) do
        if type(info) == "table" then
            local isBuilding = info["ConstructionSize"]
            local isBuildingAbility = info["Building"]
            if isBuilding then
                -- Build NetTable with the building properties
                local values = {}

                if info['ConstructionSize'] then
                    values.size = info['ConstructionSize']
                end

                if info['Limit'] then
                    values.limit = info['Limit']
                end

                if info['Requirements'] then
                    values.requirements = info["Requirements"]
                end

                if info['Upgrades'] then
                    local count = info['Upgrades']['Count']
                    for i = 1,count do
                        local unit_name = info['Upgrades'][tostring(i)]['unit_name']
                        values[unit_name] = {}
                        values[unit_name].gold_cost = info['Upgrades'][tostring(i)]['gold_cost']
                        values[unit_name].lumber_cost = info['Upgrades'][tostring(i)]['lumber_cost']
                    end
                end

                if info['GoldAmount'] then
                    values.gold_gain = info['GoldAmount']
                end
                CustomNetTables:SetTableValue("buildings", name, values)

            elseif isBuildingAbility then

                if info['UnitName'] then
                    local values = {}
                    values.upgradeUnitName = info['UnitName']
                    values.gold_cost = info['AbilitySpecial']['01']['gold_cost']
                    values.lumber_cost = info['AbilitySpecial']['02']['lumber_cost']
                    CustomNetTables:SetTableValue("buildings",name, values)
                elseif info['OnSpellStart'] then
                    if info['OnSpellStart']['RunScript'] then
                        if info['OnSpellStart']['RunScript']['NewName'] then
                            CustomNetTables:SetTableValue("buildings",name, { upgradeUnitName = info['OnSpellStart']['RunScript']['NewName']})
                        end
                    end
                end

            elseif info["BuyItem"] then
                local itemName = info["ItemName"]
                local bonus_attr
                if GetItemKV(itemName)["AbilitySpecial"]["01"] then
                    for key,value in pairs(GetItemKV(itemName)["AbilitySpecial"]["01"]) do
                        if string.match(key,"bonus") then
                            bonus_attr = key
                        end
                    end
                    local bonus_values = GetItemKV(itemName)["AbilitySpecial"]["01"][bonus_attr]
                    local gold = GetItemKV(itemName)["AbilitySpecial"]["02"]["gold_cost"]
                    local lumber = GetItemKV(itemName)["AbilitySpecial"]["03"]["lumber_cost"]
                    CustomNetTables:SetTableValue("items",name, { bonus_stats = bonus_attr , bonus_value = bonus_values , gold_cost = gold , lumber_cost = lumber })
                else
                    local gold = GetItemKV(itemName)["AbilitySpecial"]["02"]["gold_cost"]
                    local lumber = GetItemKV(itemName)["AbilitySpecial"]["03"]["lumber_cost"]
                    CustomNetTables:SetTableValue("items",name, { gold_cost = gold , lumber_cost = lumber })
                end
            elseif info["LumberAmount"] and info["LumberInterval"] then
                CustomNetTables:SetTableValue("abilities",name, { lumber_interval = info["LumberInterval"],amount = info["LumberAmount"] })
            elseif string.match(name,"train_") then
                CustomNetTables:SetTableValue("abilities",name, { gold_cost = info['AbilitySpecial']['01']['gold_cost'],lumber_cost = info['AbilitySpecial']['02']['lumber_cost'],food_cost = info['AbilitySpecial']['03']['food_cost'] })
            elseif info["RepairSpeed"] then
                CustomNetTables:SetTableValue("abilities",name, { speed = info["RepairSpeed"] })
            end
        end
    end
end

function BuildingHelper:OnGameRulesStateChange(keys)
    local newState = GameRules:State_Get()
    if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        -- The base terrain GridNav is obtained directly from the vmap
        BuildingHelper:InitGNV()
    end
end


function BuildingHelper:OnNPCSpawned(keys)
    local npc = EntIndexToHScript(keys.entindex)
    if IsBuilder(npc) then
        DebugPrint("BuildingHelper:OnNPCSPAWNED, initialize Builder")
        BuildingHelper:InitializeBuilder(npc)
    end
    local collision_size = npc:GetCollisionSize()
    local hull_radius = npc:GetHullRadius()
    if collision_size and collision_size ~= hull_radius then
        npc:SetHullRadius(collision_size)
    end
end
function BuildingHelper:OnEntityKilled(keys)
    local killed = EntIndexToHScript(keys.entindex_killed)
    local attacker = EntIndexToHScript(keys.entindex_attacker)
    local unitTable = killed:GetKeyValue()
    local gridTable = unitTable and unitTable["Grid"]
    local bounty = -1
    local killedID = killed:GetPlayerOwnerID()
    local attackerID = attacker:GetPlayerOwnerID()
    local killedName = PlayerResource:GetSelectedHeroEntity(killedID) and PlayerResource:GetSelectedHeroEntity(killedID):GetUnitName() or killed:GetUnitName()
    local attackerName = PlayerResource:GetSelectedHeroEntity(attackerID) and PlayerResource:GetSelectedHeroEntity(attackerID):GetUnitName() or attacker:GetUnitName()
    if IsBuilder(killed) and killed.alive then
        BuildingHelper:ClearQueue(killed)
        killed.alive = false
        killed.legitChooser = true

        bounty = PlayerResource:GetGold(killedID)
        PlayerResource:SetGold(killed,0)
        PlayerResource:SetLumber(killed,0)

        if GameRules:GetGameTime() - GameRules.startTime < 420 then
            local args = {}
            args.team = DOTA_TEAM_GOODGUYS
            args.playerID = killedID
            Timers:CreateTimer(1,function()
                BuildingHelper:ChooseHelpSide(args)
            end)
        else
            local orgPlayer = killed:GetPlayerOwner()
            if orgPlayer then
                CustomGameEventManager:Send_ServerToPlayer(orgPlayer, "show_helper_options", { })
                CustomGameEventManager:Send_ServerToPlayer(orgPlayer, "hide_cheese_panel", { })
                Timers:CreateTimer(30,function()
                    if killed and killed.legitChooser and killed.legitChooser == true then
                       local args = {}
                        args.team = RandomInt(0, 1) == 1 and DOTA_TEAM_GOODGUYS or DOTA_TEAM_BADGUYS
                        args.playerID = killedID
                        BuildingHelper:ChooseHelpSide(args)
                    end
                end)
            end
            if PlayerResource:GetConnectionState(killedID) == 3 then
                GameRules.dcedChoosers[killedID] = true
            end
        end

        if CheckTrollVictory() then
            SetResourceValues()
            Stats.SubmitMatchData(DOTA_TEAM_BADGUYS,callback)
            GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
            return
        end
        for i=#killed.units,1,-1 do
            if killed and killed.units[i] then
                if killed.units[i].minimapEntity then
                    UTIL_Remove(killed.units[i].minimapEntity)
                end
                killed.units[i]:ForceKill(false)
            end
        end
        killed:SetAbsOrigin(Vector(-10000,-10000,0))
        PlayerResource:SetCameraTarget(killedID, PlayerResource:GetSelectedHeroEntity(GameRules.trollID))



    elseif IsCustomBuilding(killed) or gridTable then
        -- Building Helper grid cleanup
        BuildingHelper:RemoveBuilding(killed, false)

        if gridTable then
            for grid_type,v in pairs(gridTable) do
                if tobool(v.RemoveOnDeath) then
                    local location = killed:GetAbsOrigin()
                    BuildingHelper:print("Clearing special grid of "..grid_type)
                    if (v.Radius) then
                        BuildingHelper:RemoveGridType(v.Radius, location, grid_type, "radius")
                    elseif (v.Square) then
                        BuildingHelper:RemoveGridType(v.Square, location, grid_type)
                    end                
                end
            end
        end

        local hero = killed:GetOwner()
        local name = killed:GetUnitName()
        if hero.buildings[name] and hero.buildings[name] > 0 then
            hero.buildings[name] = hero.buildings[name] - 1
        end
        if killed.ancestors then
            for key,aname in pairs(killed.ancestors) do
                if name ~= aname then
                    hero.buildings[aname] = hero.buildings[aname] - 1
                end
            end
        end
        for i=#hero.units,1,-1 do
            if hero.units[i] == killed then
                table.remove(hero.units,i)
            end
        end

        for k,v in pairs(hero.units) do
            UpdateUpgrades(v)
        end
        UpdateSpells(hero)
    elseif PlayerResource:IsTroll(killed) then
        SetResourceValues()
        Stats.SubmitMatchData(DOTA_TEAM_GOODGUYS,callback)
        GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
    elseif PlayerResource:IsWolf(killed) then
        bounty = math.max(GetNetworth(killed) * 0.10,GameRules:GetGameTime())
        RespawnHelper(killed)
    elseif PlayerResource:IsAngel(killed) then
        bounty = math.max(PlayerResource:GetGold(killedID),GameRules:GetGameTime())
        PlayerResource:SetGold(killed,0)
        RespawnHelper(killed)
    end
    if bounty>=0 and attacker~=killed then
        bounty = math.floor(bounty)
        PlayerResource:ModifyGold(attacker,bounty)
        GameRules:SendCustomMessage("%s1 (" .. GetModifiedName(attackerName)  .. ") killed " .. PlayerResource:GetPlayerName(killedID) .. " (" .. GetModifiedName(killedName) .. ") for <font color='#F0BA36'>"..bounty.."</font> gold!",attackerID,0)
    end
    if killed and killed:GetKeyValue("FoodCost") then
        local food_cost = killed:GetKeyValue("FoodCost")
        local hero = PlayerResource:GetSelectedHeroEntity(killedID)
        PlayerResource:ModifyFood(hero,-food_cost)
    end

end

function CheckTrollVictory()
    for i=1,PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) do
        local playerID = PlayerResource:GetNthPlayerIDOnTeam(2, i)
        local hero = PlayerResource:GetSelectedHeroEntity(playerID)
        if hero and hero.alive then
            return false
        end
    end
    return true
end

function GetModifiedName(orgName)
    if string.match(orgName,"troll") then
        return "<font color='#FF0000'>The Mighty Troll</font>"
    elseif string.match(orgName,"wisp") then
        return "<font color='#00CC00'>Elf</font>"
    elseif string.match(orgName,"lycan") then
        return "<font color='#800000'>Wolf</font>"
    elseif string.match(orgName,"crystal_maiden") then
        return "<font color='#0099FF'>Angel</font>"
    else
        return "?"
    end
end

function BuildingHelper:OnTreeCut(keys)
    local treePos = Vector(keys.tree_x,keys.tree_y,0)
    local tree -- Figure out which tree was cut
    for _,t in pairs(BuildingHelper.AllTrees) do
        local pos = t:GetAbsOrigin()
        if pos.x == treePos.x and pos.y == treePos.y then
            tree = t
            break
        end
    end

    if not tree then
        BuildingHelper:print("ERROR: OnTreeCut couldn't find a tree for pos "..treePos.x..","..treePos.y)
        return
    elseif tree.chopped_dummy then
        UTIL_Remove(tree.chopped_dummy)
    end

    -- Create a dummy for clients to be able to detect trees standing and block their grid
    tree.chopped_dummy = CreateUnitByName("npc_dota_units_base", treePos, false, nil, nil, 0)
    tree.chopped_dummy:AddNewModifier(tree.chopped_dummy,nil,"modifier_tree_cut",{})
    BuildingHelper.TreeDummies[tree:GetEntityIndex()] = tree.chopped_dummy

    -- Allow construction
    if not GridNav:IsBlocked(treePos) then
        BuildingHelper:FreeGridSquares(2, treePos)
    end

    -- Remove the dummy, allowing the tree to regrow
    Timers:CreateTimer(BuildingHelper.TreeRegrowTime, function()
        if IsValidEntity(tree.chopped_dummy) then
            BuildingHelper.TreeDummies[tree:GetEntityIndex()] = nil
            UTIL_Remove(tree.chopped_dummy)
        end
    end)
end

function BuildingHelper:InitGNV()
    local worldMin = Vector(GetWorldMinX(), GetWorldMinY(), 0)
    local worldMax = Vector(GetWorldMaxX(), GetWorldMaxY(), 0)

    local boundX1 = GridNav:WorldToGridPosX(worldMin.x)
    local boundX2 = GridNav:WorldToGridPosX(worldMax.x)
    local boundY1 = GridNav:WorldToGridPosY(worldMin.y)
    local boundY2 = GridNav:WorldToGridPosY(worldMax.y)
   
    BuildingHelper:print("Max World Bounds: ")
    BuildingHelper:print(GetWorldMinX()..' '..GetWorldMaxX()..' '..GetWorldMinY()..' '..GetWorldMaxY())
    BuildingHelper:print(boundX1..' '..boundX2..' '..boundY1..' '..boundY2)

    local blockedCount = 0
    local unblockedCount = 0

    local gnv = {}
    local line = {}
    local ASCII_ART = false

    -- Trigger zones named "bh_blocked" will block the terrain for construction
    local blocked_map_zones = Entities:FindAllByName("*bh_blocked")
    local entities = Entities:FindAllByClassname("npc_dota_creature")

    for y=boundY1,boundY2 do
        local shift = 4
        local byte = 0
        BuildingHelper.Terrain[y] = {}
        for x=boundX1,boundX2 do
            local gridX = GridNav:GridPosToWorldCenterX(x)
            local gridY = GridNav:GridPosToWorldCenterY(y)
            local position = Vector(gridX, gridY, 0)
            local treeBlocked = GridNav:IsNearbyTree(position, 30, true)

            -- If tree updating is enabled, trees aren't networked but detected as ent_dota_tree entities on clients
            local terrainBlocked = not GridNav:IsTraversable(position) or GridNav:IsBlocked(position)
            if BuildingHelper.Settings["UPDATE_TREES"] then
                terrainBlocked = terrainBlocked and not treeBlocked
            end

            if not terrainBlocked then
                -- Check if the position is inside any blocking trigger
                for _,ent in pairs(blocked_map_zones) do
                    local triggerBlocked = BuildingHelper:IsInsideEntityBounds(ent, position)
                    if triggerBlocked then
                        terrainBlocked = true
                        break
                    end
                end
            end
            if not terrainBlocked then
                for _, entity in pairs(entities) do
                    local isInside = BuildingHelper:IsInsideEntityConstructionArea(entity, position)
                    if isInside then
                        terrainBlocked = true
                        break
                    end
                end
            end

            if terrainBlocked then
                BuildingHelper.Terrain[y][x] = BuildingHelper.GridTypes["BLOCKED"]
                byte = byte + bit.lshift(2,shift)
                blockedCount = blockedCount+1
                if ASCII_ART then
                    line[#line+1] = '='
                end
            else
                BuildingHelper.Terrain[y][x] = BuildingHelper.GridTypes["BUILDABLE"]
                byte = byte + bit.lshift(1,shift)
                unblockedCount = unblockedCount+1
                if ASCII_ART then
                    line[#line+1] = '.'
                end
            end

            if treeBlocked then
                BuildingHelper.Terrain[y][x] = BuildingHelper.GridTypes["BLOCKED"]
            end

            shift = shift - 2

            if shift == -2 then
                gnv[#gnv+1] = string.char(byte+58)
                shift = 4
                byte = 0
            end
        end

        if shift ~= 4 then
            gnv[#gnv+1] = string.char(byte+58)
        end

        if ASCII_ART then
            print(table.concat(line,''))
            line = {}
        end
    end

    local gnv_string = table.concat(gnv,'')

    -- Running-length encoding
    local last
    local count = 0
    local gnvRLE = {}
    for i=1,string.len(gnv_string) do
        local c = gnv_string:sub(i,i)
        if last then
            if last == c then
                count = count + 1
            else
                gnvRLE[#gnvRLE+1] = (count == 1 and "" or count) .. last
                last = c
                count = 1
            end
        else
            last = c
            count = count + 1
        end
    end
    local gnvRLE_string = table.concat(gnvRLE,'')

    local squareX = boundX2 - boundX1 + 1
    local squareY = boundY2 - boundY1 + 1

    BuildingHelper:print("Free: "..unblockedCount.." Blocked: "..blockedCount)

    -- Initially, the construction grid equals the terrain grid
    -- Clients will have full knowledge of the terrain grid
    -- The construction grid is only known by the server
    BuildingHelper.Grid = BuildingHelper.Terrain

    BuildingHelper.Encoded = gnvRLE_string
    BuildingHelper.squareX = squareX
    BuildingHelper.squareY = squareY
    BuildingHelper.minBoundX = boundX1
    BuildingHelper.minBoundY = boundY1
end

function BuildingHelper:SendGNV(args)
    local playerID = args.PlayerID
    if playerID then
        local player = PlayerResource:GetPlayer(playerID)
        if player then
            BuildingHelper:print("Sending GNV to player "..playerID)
            BuildingHelper:print("GNV Length: " .. string.len(BuildingHelper.Encoded))
            BuildingHelper:print("Sending GNV: " .. BuildingHelper.Encoded)
            CustomGameEventManager:Send_ServerToPlayer(player, "gnv_register", {gnv=BuildingHelper.Encoded, squareX = BuildingHelper.squareX, squareY = BuildingHelper.squareY, boundX = BuildingHelper.minBoundX, boundY = BuildingHelper.minBoundY })
        end
    end
end

-- Used to find the closest builder to a building location
local GetClosestToPosition = function(unitList, position)
    local t = {}
    local distance = math.huge
    local closest
    for _,unit in pairs(unitList) do
        local thisDistance = (unit:GetAbsOrigin()-position):Length2D()
        if thisDistance < distance then
            closest = unit
            distance = thisDistance
        end
    end
    return closest
end

--[[
    BuildCommand
    * Detects a Left Click with a builder through Panorama
]]--
function BuildingHelper:BuildCommand(args)
    local playerID = args['PlayerID']
    local x = args['X']
    local y = args['Y']
    local z = args['Z']
    local location = Vector(x, y, z)
    local queue = args['Queue'] == 1
    local builder = EntIndexToHScript(args.builder) --activeBuilder

    local name = builder:GetUnitName()
    local builders = {}
    local idle_builders = {}
    local entityList = PlayerResource:GetSelectedEntities(playerID)

    -- Filter all the selected builders
    for k,entIndex in pairs(entityList) do
        local unit = EntIndexToHScript(entIndex)
        if unit:GetUnitName() == name then
            if unit:IsIdle() then
                table.insert(idle_builders, unit)
            end
            table.insert(builders, unit)
        end
    end

    -- First select from idle builders
    if #idle_builders > 0 then
        builder = GetClosestToPosition(idle_builders, location)
    else
        builder = GetClosestToPosition(builders, location)
    end

    -- Cancel current action
    if not queue then
        ExecuteOrderFromTable({UnitIndex = builder:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_STOP, Queue = false})
    end

    BuildingHelper:AddToQueue(builder, location, queue)
end

--[[
    CancelCommand
    * Detects a Right Click/Tab with a builder through Panorama
]]--
function BuildingHelper:CancelCommand(args)
    local playerID = args.PlayerID
    local playerTable = BuildingHelper:GetPlayerTable(playerID)
    playerTable.activeBuilding = nil

    local selectedEntities = PlayerResource:GetSelectedEntities(playerID)
    for _,entityIndex in pairs(selectedEntities) do
        local unit = EntIndexToHScript(entityIndex)
        if unit and IsBuilder(unit) then
            BuildingHelper:ClearQueue(unit)
        end
    end
end


function BuildingHelper:RepairCommand(args)
    local playerID = args.PlayerID or args.caster:GetPlayerOwnerID()
    local building = args.targetIndex and EntIndexToHScript(args.targetIndex) or args.target
    local selectedEntities = PlayerResource:GetSelectedEntities(playerID)
    local queue = tobool(args.queue) or false

    for _,entityIndex in pairs(selectedEntities) do
        local unit = EntIndexToHScript(entityIndex)

        if IsBuilder(unit) then
            -- Cancel current action
            if not queue then
                ExecuteOrderFromTable({UnitIndex = entityIndex, OrderType = DOTA_UNIT_ORDER_STOP, Queue = false}) 
            end

            -- Repair added to the queue
            BuildingHelper:AddRepairToQueue(unit, building, queue)
        end
    end
end


function BuildingHelper:OnSelectionUpdate(event)
    local playerID = event.PlayerID
    if not playerID then return end
    
    -- This is for Building Helper to know which is the currently active builder
    local mainSelected = PlayerResource:GetMainSelectedEntity(playerID)
    if not mainSelected then return end
    mainSelected = EntIndexToHScript(mainSelected)
    local player = BuildingHelper:GetPlayerTable(playerID)

    if IsValidEntity(mainSelected) then
        if IsBuilder(mainSelected) then
            player.activeBuilder = mainSelected
        else
            if IsValidEntity(player.activeBuilder) then
                -- Clear ghost particles when swapping to a non-builder
                BuildingHelper:StopGhost(player.activeBuilder)
            end
        end
    end
end

function BuildingHelper:RightClickOrder( event )
    local pID = event.pID
    local entityIndex = event.mainSelected
    local targetIndex = event.targetIndex
    local building = EntIndexToHScript(targetIndex)
    local queue = tobool(event.queue)

    local unit = EntIndexToHScript(entityIndex)
    local repair_ability = BuildingHelper:GetRepairAbility(unit)
    -- Repair
    if repair_ability and repair_ability:IsFullyCastable() and not repair_ability:IsHidden() then
        ExecuteOrderFromTable({ UnitIndex = entityIndex, OrderType = DOTA_UNIT_ORDER_CAST_TARGET, TargetIndex = targetIndex, AbilityIndex = repair_ability:GetEntityIndex(), Queue = queue})
    end

end

function BuildingHelper:GiveResources( event )
    local targetID = event.target
    local casterID = event.casterID
    local gold = math.floor(math.abs(tonumber(event.gold)))
    local lumber = math.floor(math.abs(tonumber(event.lumber)))
    if tonumber(event.gold) ~= nil and tonumber(event.lumber) ~= nil then
        if PlayerResource:GetSelectedHeroEntity(targetID) and PlayerResource:GetSelectedHeroEntity(targetID):GetTeam() == PlayerResource:GetSelectedHeroEntity(event.casterID):GetTeam() then
            local hero = PlayerResource:GetSelectedHeroEntity(targetID)
            local casterHero = PlayerResource:GetSelectedHeroEntity(casterID)
            if gold and lumber then
                if PlayerResource:GetGold(casterID) < gold or PlayerResource:GetLumber(casterID) < lumber then
                    SendErrorMessage(casterID, "#error_not_enough_resources")
                    return
                end
                PlayerResource:ModifyGold(casterHero,-gold,true)
                PlayerResource:ModifyLumber(casterHero,-lumber,true)
                PlayerResource:ModifyGold(hero,gold,true)
                PlayerResource:ModifyLumber(hero,lumber,true)
                PlayerResource:ModifyGoldGiven(targetID,-gold)
                PlayerResource:ModifyLumberGiven(targetID,-lumber)
                PlayerResource:ModifyGoldGiven(casterID,gold)
                PlayerResource:ModifyLumberGiven(casterID,lumber)
                if gold > 0 or lumber > 0 then
                    local text = PlayerResource:GetPlayerName(casterHero:GetPlayerOwnerID()) .. "(" .. GetModifiedName(casterHero:GetUnitName()) .. ") has sent "
                    if gold > 0 then
                        text = text .. "<font color = '#F0BA36'>" .. gold .. "</font> gold"
                    end
                    if gold > 0 and lumber > 0 then
                        text = text .. " and "
                    end
                    if lumber > 0 then
                        text = text .. "<font color = '#009900'>" .. lumber .. "</font> lumber"
                    end
                    text = text ..  " to " .. PlayerResource:GetPlayerName(hero:GetPlayerOwnerID()) .. "(" .. GetModifiedName(hero:GetUnitName()) .. ")!" 
                    GameRules:SendCustomMessageToTeam(text,casterHero:GetTeamNumber(),0,0)
                end
            else
                SendErrorMessage(event.casterID, "#error_enter_only_digits")
            end
        else
            SendErrorMessage(event.casterID, "#error_select_only_your_allies")
        end
    else
        SendErrorMessage(event.casterID, "#error_type_only_digits")
    end
end

function BuildingHelper:ChooseHelpSide(event)
    local team = event.team
    local pID = event.playerID
    local player = PlayerResource:GetPlayer(pID)
    local hero = PlayerResource:GetSelectedHeroEntity(pID)
    if hero then
        hero.legitChooser = false
    end
    Timers:CreateTimer(3,function()
        PlayerResource:SetCameraTarget(pID, nil)
    end)
    if team == DOTA_TEAM_GOODGUYS then
        PlayerResource:ReplaceHeroWith(pID, "npc_dota_hero_crystal_maiden", 0, 0)
        UTIL_Remove(hero)
        hero = PlayerResource:GetSelectedHeroEntity(pID)
        if hero then
            hero:ClearInventory()
            hero:AddItemByName("item_blink_datadriven")
            hero:SetAbsOrigin(Vector(0,0,0))
            RespawnHelper(hero)
            GameRules:SendCustomMessage("%s1 will keep helping elves and now is an " .. GetModifiedName("crystal_maiden") ,pID,0)
        end
    elseif team == DOTA_TEAM_BADGUYS then
        PlayerResource:SetCustomTeamAssignment(pID,team)
        PlayerResource:ReplaceHeroWith(pID, "npc_dota_hero_lycan", 0, 0)
        UTIL_Remove(hero)
        hero = PlayerResource:GetSelectedHeroEntity(pID)
        if hero then
            hero:ClearInventory()
            RespawnHelper(hero)
            local trollHero = PlayerResource:GetSelectedHeroEntity(GameRules.trollID)
            local lumber = math.floor(GetNetworth(trollHero)/64000*0.3)
            local gold = math.floor((GetNetworth(trollHero)/64000*0.3 - lumber)*64000)
            PlayerResource:SetLumber(hero,lumber)
            PlayerResource:SetGold(hero,gold)
            PlayerResource:SetUnitShareMaskForPlayer(GameRules.trollID,pID, 2 , true)
            GameRules:SendCustomMessage("%s1 has joined the dark side and now will help " .. GetModifiedName("troll") .. ".%s1 is now a" .. GetModifiedName("lycan") ,pID,0)
            Timers:CreateTimer(0.03,function()
                if hero and hero:IsAlive() then
                    AddFOWViewer(hero:GetTeamNumber(), hero:GetAbsOrigin(), 150, 0.03, false)
                end
                if not hero:IsNull() then
                    return 0.03
                end
            end)
        end
    end
    if hero then
        for i=0,15 do
            local ability = hero:GetAbilityByIndex(i)
            if ability then ability:SetLevel(ability:GetMaxLevel()) end
        end
    end

end

function GetNetworth(hero)
    local sum = 0
    for i = 0, 5, 1 do
        local item = hero:GetItemInSlot(i)
        if item then
            local item_name = item:GetAbilityName()
            DebugPrint("Item name: " .. item_name)
            local gold_cost = GetItemKV(item_name)["AbilitySpecial"]["02"]["gold_cost"]
            local lumber_cost = GetItemKV(item_name)["AbilitySpecial"]["03"]["lumber_cost"]
            sum = sum + gold_cost + lumber_cost * 64000
        end
    end
    sum = sum + PlayerResource:GetGold(hero:GetPlayerOwnerID())
    return sum
end

function RandomAngelLocation()
    return (GameRules.angel_spawn_points and #GameRules.angel_spawn_points and #GameRules.angel_spawn_points > 0) and GameRules.angel_spawn_points[RandomInt(1, #GameRules.angel_spawn_points)]:GetAbsOrigin() or Vector(0,0,0)
end

function RespawnHelper(hero)
        local team = hero:GetTeamNumber()
        local timer = team == DOTA_TEAM_GOODGUYS and 30 or 5
        local invul = team == DOTA_TEAM_GOODGUYS and true or false
        local pos = team == DOTA_TEAM_GOODGUYS and RandomAngelLocation() or Vector(0,-640,256)
        hero:SetRespawnsDisabled(false)
        hero:ForceKill(true)
        hero:SetRespawnPosition(pos)
        hero:SetTimeUntilRespawn(timer)
        local countdown = timer
        local countdownColor = team == DOTA_TEAM_GOODGUYS and "#0099FF" or "#800000"
        Timers:CreateTimer(0.03,function()
            if countdown > 0 then
                local player = hero:GetPlayerOwner()
                if player then
                    Notifications:ClearBottom(player)
                    Notifications:Bottom(player,{text="You will respawn in " .. countdown .. " seconds", style={color=countdownColor}, duration=1})
                end
                countdown = countdown - 1
                return 1.0
            else
                hero:RespawnHero(false,false)
                if invul == true then
                    hero:AddNewModifier(hero,nil,"modifier_invulnerable",{duration = 5}) 
                end
                hero:NotifyWearablesOfModelChange(false)
            end

        end)
end

function BuildingHelper:SellItem(args)
    local item = EntIndexToHScript(args.itemIndex)
    if item then
        if not item:IsSellable() then
            SendErrorMessage(issuerID,"#error_item_not_sellable")
        end
        local gold_cost = item:GetSpecialValueFor("gold_cost")
        local lumber_cost = item:GetSpecialValueFor("lumber_cost")
        local hero = item:GetCaster()
        UTIL_Remove(item)
        PlayerResource:ModifyGold(hero,gold_cost,true)
        PlayerResource:ModifyLumber(hero,lumber_cost,true)
        local player = hero:GetPlayerOwner()
        EmitSoundOnClient("DOTA_Item.Hand_Of_Midas", player)
    end

end


-- Requires notifications library from bmddota/barebones
function SendErrorMessage( pID, string )
    Notifications:ClearBottom(pID)
    Notifications:Bottom(pID, {text=string, style={color='#E62020'}, duration=2})
    EmitSoundOnClient("General.Cancel", PlayerResource:GetPlayer(pID))
end


function BuildingHelper:OrderFilter(order)
    local ret = true    
    if BuildingHelper.nextFilter then
        ret = BuildingHelper.nextFilter(BuildingHelper.nextContext, order)
    end

    if not ret then
        return false
    end

    local issuerID = order.issuer_player_id_const

    if issuerID == -1 then return true end


    local queue = order.queue == 1
    local order_type = order.order_type
    local units = order.units
    local abilityIndex = order.entindex_ability
    local targetIndex = order.entindex_target
    local unit = nil
    if units["0"] then
        unit = EntIndexToHScript(units["0"])
    end
    for k,v in pairs(units) do
        local ounit = EntIndexToHScript(v)
        if ounit then
            if ounit.attackTarget then
                local attacked = EntIndexToHScript(ounit.attackTarget)
                if attacked and attacked.attackers then
                    attacked.attackers[ounit.attackTarget] = nil
                    ounit.attackTarget = nil
                end
            end
        end
    end

    -- Item is dropped
    if order_type == DOTA_UNIT_ORDER_DROP_ITEM and IsBuilder(unit) then
        BuildingHelper:ClearQueue(unit)
        return true

    -- Stop and Hold
    elseif order_type == DOTA_UNIT_ORDER_STOP or order_type == DOTA_UNIT_ORDER_HOLD_POSITION then
        for n, unit_index in pairs(units) do 
            local unit = EntIndexToHScript(unit_index)
            if IsBuilder(unit) then
                BuildingHelper:ClearQueue(unit)
            end
        end
        return true

    -- Casting non building abilities
    elseif (abilityIndex and abilityIndex ~= 0) and unit and IsBuilder(unit) then
        local ability = EntIndexToHScript(abilityIndex)
        if not IsBuildingAbility(ability) then
            BuildingHelper:ClearQueue(unit)
        end

        -- Repair Multi Order
        if order_type == DOTA_UNIT_ORDER_CAST_TARGET and BuildingHelper:GetRepairAbility(unit) then
            local ability = EntIndexToHScript(abilityIndex) 
            local abilityName = ability:GetAbilityName()
            local target_handle = EntIndexToHScript(targetIndex)
            local target_name = target_handle:GetUnitName()
            
            if self:OnPreRepair(target_handle, unit) then
                self:print("Order: Repair "..target_handle:GetUnitName())

                -- Get the currently selected units and send new orders
                local entityList = PlayerResource:GetSelectedEntities(unit:GetPlayerOwnerID())
                if not entityList or #entityList == 1 then return true end

                for k,entityIndex in pairs(entityList) do
                    local ent = EntIndexToHScript(entityIndex)
                    local repair_ability = BuildingHelper:GetRepairAbility(ent)
                    if ent ~= unit and repair_ability then
                        if repair_ability:IsHidden() and ent.ReturnAbility then -- Swap to the repair ability
                            ent:SwapAbilities(repair_ability:GetAbilityName(), ent.ReturnAbility:GetAbilityName(), true, false)
                        end

                        ent.skip = true
                        BuildingHelper:print("Repair Multi Order "..target_handle:GetUnitName())
                        ExecuteOrderFromTable({UnitIndex = entityIndex, OrderType = DOTA_UNIT_ORDER_CAST_TARGET, TargetIndex = targetIndex, AbilityIndex = repair_ability:GetEntityIndex(), Queue = queue})
                    end
                end
            end
        end

    end
    if order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
        if units["0"] then
            shop = EntIndexToHScript(units["0"])
            local unit_name = shop:GetUnitName()
            if string.match(unit_name,"shop") or string.match(unit_name,"troll_hut") then
                shop.buyer = issuerID
                if string.match(unit_name,"troll_hut") and string.match(EntIndexToHScript(abilityIndex):GetAbilityName(),"upgrade") and not string.match(PlayerResource:GetSelectedHeroEntity(issuerID):GetUnitName(),"troll") and PlayerResource:GetPlayer(GameRules.trollID) then
                    SendErrorMessage(issuerID,"#error_only_troll_can_upgrade")
                    return false
                end
            end
        end





        local ability = EntIndexToHScript(abilityIndex)
        if ability then
            local abilityName = ability:GetAbilityName()
            local selectedEntities = PlayerResource:GetSelectedEntities(issuerID)
            local count = 0
            if string.match(abilityName,"upgrade_to") then
                for k,v in pairs(selectedEntities) do
                    local ounit = EntIndexToHScript(v)
                    if ounit and ounit:GetUnitName() == unit:GetUnitName() then
                        for a = 0,15 do
                            local upgradeAbility = ounit:GetAbilityByIndex(a)
                            if upgradeAbility then
                                if upgradeAbility:GetAbilityName() == abilityName then
                                    ExecuteOrderFromTable({UnitIndex = v, OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET, TargetIndex = targetIndex, AbilityIndex = upgradeAbility:GetEntityIndex(), Queue = queue})
                                    count = count + 1
                                    break
                                end
                            end
                        end
                    end
                end
                if count == 1 then
                    return false
                end
            end
        end
    end
    if order_type == DOTA_UNIT_ORDER_RADAR then
        SendErrorMessage(issuerID,"#error_no_radar")
        return false
    end
    if order_type == DOTA_UNIT_ORDER_SELL_ITEM then
        local args = {itemIndex = abilityIndex}
        BuildingHelper:SellItem(args)
        return false
    end

    return ret
end    

--[[
      InitializeBuilder
      * Manages each workers build queue. Will run once per builder
]]--
function BuildingHelper:InitializeBuilder(builder)
    BuildingHelper:print("InitializeBuilder "..builder:GetUnitName().." "..builder:GetEntityIndex())

    if not builder.buildingQueue then
        builder.buildingQueue = {}
    end
    builder.state = "idle"
    -- Store the builder entity indexes on a net table
    CustomNetTables:SetTableValue("builders", tostring(builder:GetEntityIndex()), { IsBuilder = true })
end

function BuildingHelper:RemoveBuilder(builder)
    -- Store the builder entity indexes on a net table
    CustomNetTables:SetTableValue("builders", tostring(builder:GetEntityIndex()), { IsBuilder = false })
end

--[[
    AddBuilding
    * Makes a building dummy and starts panorama ghosting
    * Builder calls this and sets the callbacks with the required values
]]--
function BuildingHelper:AddBuilding(keys)
    -- Callbacks
    local callbacks = BuildingHelper:SetCallbacks(keys)
    local builder = keys.caster
    local ability = keys.ability
    local abilName = ability:GetAbilityName()
    local buildingTable = BuildingHelper:SetupBuildingTable(abilName, builder)

    buildingTable:SetVal("AbilityHandle", ability)

    -- Prepare the builder, if it hasn't already been done
    if not builder.buildingQueue then  
        DebugPrint("BuildingHelper:AddBuilding, initialize Builder")
        BuildingHelper:InitializeBuilder(builder)
    end

    local size = buildingTable:GetVal("ConstructionSize", "number")
    local unitName = buildingTable:GetVal("UnitName", "string")

    -- Handle self-ghosting
    if unitName == "self" then
        unitName = builder:GetUnitName()
    end

    local fMaxScale = buildingTable:GetVal("MaxScale", "float")
    if not fMaxScale then
        -- If no MaxScale is defined, check the "ModelScale" KeyValue. Otherwise just default to 1
        local fModelScale = GetUnitKV(unitName, "ModelScale")
        if fModelScale then
          fMaxScale = fModelScale
        else
            fMaxScale = 1
        end
    end
    buildingTable:SetVal("MaxScale", fMaxScale)

    local color = Vector(255,255,255)
    if RECOLOR_GHOST_MODEL then
        color = Vector(0,255,0)
    end

    -- Basic event table to send
    local event = { state = "active", size = size, scale = fMaxScale, builderIndex = builder:GetEntityIndex() }

    -- Set the active variables and callbacks
    local playerID = builder:GetMainControllingPlayer()
    local playerTable = BuildingHelper:GetPlayerTable(playerID)
    playerTable.activeBuilder = builder
    playerTable.activeBuilding = unitName
    playerTable.activeBuildingTable = buildingTable
    playerTable.activeCallbacks = callbacks

    -- Offset Z on the model particle
    event.modelOffset = GetUnitKV(unitName, "ModelOffset") or GetUnitKV(unitName,"ModelGhostOffset") or 0

    -- npc_dota_creature doesn't render cosmetics on the particle ghost, use hero names instead
    local overrideGhost = buildingTable:GetVal("OverrideBuildingGhost", "string")
    unitName = overrideGhost or unitName

    -- Get a model dummy to pass it to panorama
    local mgd = BuildingHelper:GetOrCreateDummy(unitName)
    event.entindex = mgd:GetEntityIndex()

    -- Range overlay
    if mgd:HasAttackCapability() then
        event.range = buildingTable:GetVal("AttackRange", "number") + mgd:GetHullRadius()
    end

    -- Adjust the Model Orientation
    local yaw = buildingTable:GetVal("ModelRotation", "float")
    mgd:SetAngles(0, -yaw, 0)
    
    local player = PlayerResource:GetPlayer(playerID)
    if player then                        
        CustomGameEventManager:Send_ServerToPlayer(player, "building_helper_enable", event)
    end
end

--[[
    SetCallbacks
    * Defines a series of callbacks to be returned in the builder module
]]--
function BuildingHelper:SetCallbacks(keys)
    local callbacks = {}

    function keys:OnPreConstruction(callback)
        callbacks.onPreConstruction = callback -- Return false to abort the build
    end

     function keys:OnBuildingPosChosen(callback)
        callbacks.onBuildingPosChosen = callback -- Spend resources here
    end

    function keys:OnConstructionFailed(callback) -- Called if there is a mechanical issue with the building (cant be placed)
        callbacks.onConstructionFailed = callback
    end

    function keys:OnConstructionCancelled(callback) -- Called when player right clicks to cancel a queue
        callbacks.onConstructionCancelled = callback
    end

    function keys:OnConstructionStarted(callback)
        callbacks.onConstructionStarted = callback
    end

    function keys:OnConstructionCompleted(callback)
        callbacks.onConstructionCompleted = callback
    end

    function keys:OnBelowHalfHealth(callback)
        callbacks.onBelowHalfHealth = callback
    end

    function keys:OnAboveHalfHealth(callback)
        callbacks.onAboveHalfHealth = callback
    end

    return callbacks
end

--[[
    SetupBuildingTable
    * Setup building table, returns a constructed table.
]]--
function BuildingHelper:SetupBuildingTable(abilityName, builderHandle)

    local buildingTable = GetKeyValue(abilityName)

    function buildingTable:GetVal(key, expectedType)
        local val = buildingTable[key]

        -- Return value directly if no second parameter
        if not expectedType then
            return val
        end

        -- Handle missing values.
        if val == nil then
            if expectedType == "bool" then
                return false
            else
                return nil
            end
        end
        
        -- Handle empty values
        local sVal = tostring(val)
        if sVal == "" then
            return nil
        end

        if expectedType == "bool" then
            return sVal == "1"
        elseif expectedType == "number" or expectedType == "float" then
            return tonumber(val)
        end
        return sVal
    end

    function buildingTable:SetVal(key, value)
        buildingTable[key] = value
    end

    -- Extract data from the KV files, set is called to guarantee these have values later on in execution
    local unitName = buildingTable:GetVal("UnitName", "string")
    if not unitName then
        BuildingHelper:print('Error: ' .. abilName .. ' does not have a UnitName KeyValue')
        return
    end
    buildingTable:SetVal("UnitName", unitName)

    -- Self ghosting
    if unitName == "self" then
        unitName = builderHandle:GetUnitName()
    end

    -- Ensure that the unit actually exists
    local unitTable = GetUnitKV(unitName)
    if not unitTable then
        BuildingHelper:print('Error: Definition for Unit ' .. unitName .. ' could not be found in the KeyValue files.')
        return
    end

    local construction_size = unitTable["ConstructionSize"]
    if not construction_size then
        BuildingHelper:print('Error: Unit ' .. unitName .. ' does not have a ConstructionSize KeyValue.')
        return
    end
    buildingTable:SetVal("ConstructionSize", construction_size)

    -- OverrideBuildingGhost
    local override_ghost = GetUnitKV(unitName, "OverrideBuildingGhost")
    if override_ghost then
        buildingTable:SetVal("OverrideBuildingGhost", override_ghost)
    end

    local build_time = buildingTable["BuildTime"] or unitTable["BuildTime"]
    if not build_time then
        BuildingHelper:print('Error: No BuildTime for ' .. unitName .. '. Default to 0.1')
        build_time = 0.1
    end
    buildingTable:SetVal("BuildTime", build_time)

    local attack_range = unitTable["AttackRange"] or 0
    buildingTable:SetVal("AttackRange", attack_range)

    local pathing_size = unitTable["BlockPathingSize"]
    if not pathing_size then
        BuildingHelper:print('Warning: Unit ' .. unitName .. ' does not have a BlockPathingSize KeyValue. Defaulting to 0')
        pathing_size = 0
    end
    buildingTable:SetVal("BlockPathingSize", pathing_size)

    -- Pedestal Model
    local pedestal_model = GetUnitKV(unitName, "PedestalModel")
    if pedestal_model then
        buildingTable:SetVal("PedestalModel", pedestal_model)
    end

    -- Pedestal Scale
    local pedestal_scale = GetUnitKV(unitName, "PedestalModelScale")
    if pedestal_scale then
        buildingTable:SetVal("PedestalModelScale", pedestal_scale)
    end

    -- Pedestal Offset
    local pedestal_offset = GetUnitKV(unitName, "PedestalOffset")
    if pedestal_offset then
        buildingTable:SetVal("PedestalOffset", pedestal_offset)
    end

    -- If the construction requires certain grid type, store it
    local requires = unitTable["Requires"]
    if not requires then
        requires = "Buildable"
    end
    buildingTable:SetVal("Requires", string.upper(requires))

    local prevents = unitTable["Prevents"]
    if prevents then
        buildingTable:SetVal("Prevents", string.upper(prevents))
    end

    local castRange = buildingTable:GetVal("AbilityCastRange", "number")
    if not castRange then
        castRange = 200
    end
    buildingTable:SetVal("AbilityCastRange", castRange)

    local fMaxScale = buildingTable:GetVal("MaxScale", "float")
    if not fMaxScale then
        -- If no MaxScale is defined, check the Units "ModelScale" KeyValue. Otherwise just default to 1
        fMaxScale = GetUnitKV(unitName).ModelScale or 1
    end
    buildingTable:SetVal("MaxScale", fMaxScale)

    local fModelRotation = buildingTable:GetVal("ModelRotation", "float")
    if not fModelRotation then
        -- If no defined, check the Units KeyValue. Otherwise just default to 0
        fModelRotation = GetUnitKV(unitName).ModelRotation or 0
    end
    buildingTable:SetVal("ModelRotation", fModelRotation)
    DebugPrint("Super unit name - " ..unitName)
    local requiresrepair = GetUnitKV(unitName).RequiresRepair or 0
    buildingTable:SetVal("RequiresRepair",requiresrepair)

    local consumebuilder = GetUnitKV(unitName).ConsumesBuilder or 0
    buildingTable:SetVal("ConsumesBuilder",consumebuilder)

    local builderinside = GetUnitKV(unitName).BuilderInside or 0
    buildingTable:SetVal("BuilderInside",builderinside)

    return buildingTable
end

function BuildingHelper:OrderBuildingConstruction(builder, ability, position)
    ExecuteOrderFromTable({UnitIndex = builder:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_STOP, Queue = false}) 
    Build({caster=builder, ability=ability})
    BuildingHelper:AddToQueue(builder, position, false)
end

--[[
    PlaceBuilding
    * Places a new building on full health and returns the handle. 
    * Places grid nav blockers
    * Skips the construction phase and doesn't require a builder, this is most important to place the "base" buildings for the players when the game starts.
    * Make sure the position is valid before calling this in code.
]]--
function BuildingHelper:PlaceBuilding(player, name, location, construction_size, pathing_size, angle)
    construction_size = construction_size or BuildingHelper:GetConstructionSize(name)
    pathing_size = pathing_size or BuildingHelper:GetBlockPathingSize(name)
    BuildingHelper:SnapToGrid(construction_size, location)
    local playerID = type(player)=="number" and player or player.GetPlayerID() and player:GetPlayerID() --accept pass player ID or player Handle
    local player = playerID and PlayerResource:GetPlayer(playerID)
    local hero = playerID and PlayerResource:GetSelectedHeroEntity(playerID)
    local teamNumber = hero and hero:GetTeamNumber() or DOTA_TEAM_NEUTRALS
    BuildingHelper:print("PlaceBuilding for playerID ".. playerID)
    -- Spawn point obstructions before placing the building
    local gridNavBlockers = BuildingHelper:BlockGridSquares(construction_size, pathing_size, location)

    -- Adjust the model position z
    local model_offset = GetUnitKV(name, "ModelOffset") or 0
    local model_location = Vector(location.x, location.y, location.z + model_offset)

    -- Spawn the building
    local building = CreateUnitByName(name, model_location, false, hero, player, teamNumber)
    if PlayerResource:IsValidPlayerID(playerID) then building:SetControllableByPlayer(playerID, true) end
    if hero then building:SetOwner(hero) end
    building:AddNewModifier(building,nil,"modifier_phased",{})
    building:SetNeverMoveToClearSpace(true)
    building:SetAbsOrigin(model_location)
    building.construction_size = construction_size
    building.blockers = gridNavBlockers


    angle = angle or GetUnitKV(name, "ModelRotation") or 0
    if angle then building:SetAngles(0,-angle,0) end

    -- Disable turning. If DisableTurning unit KV setting is not defined, use the global setting
    BuildingHelper:AddModifierBuilding(building)



    -- Create pedestal
    local pedestal = GetUnitKV(name, "PedestalModel")
    if pedestal then
        BuildingHelper:CreatePedestalForBuilding(building, name, GetGroundPosition(location, nil), pedestal)
    end



    building.state = "complete"
    function building:IsUnderConstruction() return false end
    -- Return the created building
    return building
end

--[[
    UpgradeBuilding
    * Replaces a building by a new one by name, updating the necessary references and returning the new created unit
]]
function BuildingHelper:UpgradeBuilding(building, newName)
    local oldBuildingName = building:GetUnitName()
    BuildingHelper:print("Upgrading Building: "..oldBuildingName.." -> "..newName)
    local playerID = building:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    local position = building:GetAbsOrigin()
    local model_offset = GetUnitKV(newName, "ModelOffset") or 0
    local old_offset = GetUnitKV(oldBuildingName, "ModelOffset") or 0
    position.z = position.z + model_offset - old_offset
    local bPlayerCanControl = GetUnitKV(newName, "PlayerCanControl") or 0


    local newBuilding = CreateUnitByName(newName, position, false, nil, nil, building:GetTeamNumber())
    newBuilding:AddNewModifier(newBuilding,nil,"modifier_phased",{}) 
    if bPlayerCanControl == 1 then
        newBuilding:SetOwner(hero)
        newBuilding:SetControllableByPlayer(playerID, true)
    end
    if building:HasModifier("modifier_invulnerable") then
        newBuilding:AddNewModifier(nil,nil,"modifier_invulnerable",{})
    end
    if building:HasModifier("modifier_fountain_glyph") then
        local glyphModifier = building:FindModifierByName("modifier_fountain_glyph")
        if glyphModifier then
            local remainingTime = glyphModifier:GetRemainingTime()
            newBuilding:AddNewModifier(newBuilding,nil,"modifier_fountain_glyph",{duration=remainingTime})
        end
    end
    if building.minimapEntity then
        newBuilding.minimapEntity = building.minimapEntity
        newBuilding.minimapEntity.correspondingEntity = newBuilding
    end
    BuildingHelper:AddModifierBuilding(newBuilding)
    newBuilding.state = "complete"
    newBuilding:SetNeverMoveToClearSpace(true)
    newBuilding:SetAbsOrigin(position)
    PlayerResource:AddToSelection(playerID, newBuilding)
    PlayerResource:RemoveFromSelection(playerID,building)

    if building.attackers then
        for k,v in pairs(building.attackers) do
            if v and v == true then
                local attacker = EntIndexToHScript(k)
                if attacker.attackTarget and attacker.attackTarget == building:GetEntityIndex() then
                    attacker.attackTarget = newBuilding:GetEntityIndex()
                    newBuilding.attackers = {}
                    newBuilding.attackers[k] = true
                    attacker:MoveToTargetToAttack(newBuilding)
                end
            end
        end
    end
    newBuilding:AddNewModifier(nil, nil, "modifier_stunned", {})
    newBuilding.ancestors = building.ancestors
    newBuilding.constructionCompleted = true
    table.insert(newBuilding.ancestors,building:GetUnitName())
    for key,name in pairs(newBuilding.ancestors) do
        if hero.buildings[name] then
            hero.buildings[name] = hero.buildings[name] + 1
        else
            hero.buildings[name] = 1
        end
        DebugPrint(name .. " is set to " ..hero.buildings[name])
    end
    table.insert(hero.units,newBuilding)
    if hero.buildings[newBuilding:GetUnitName()] then
        hero.buildings[newBuilding:GetUnitName()] = hero.buildings[newBuilding:GetUnitName()] + 1
    else
        hero.buildings[newBuilding:GetUnitName()] = 1
    end

    local buildTime = GetUnitKV(newName, "BuildTime")
    local bScale = GetUnitKV(newName, "Scale") or 0
    local fTimeBuildingCompleted = GameRules:GetGameTime()+buildTime
    local fInitialModelScale = 0.1
    local fCurrentScale = fInitialModelScale
    local fMaxScale = GetUnitKV(newName, "ModelScale") or 1
    local fserverFrameRate = 1/30
    local fScaleInterval = (fMaxScale-fInitialModelScale) / (buildTime / fserverFrameRate)
    -- Update visuals
    local angles = GetUnitKV(newName, "ModelRotation") or -building:GetAngles().y
    newBuilding:SetAngles(0, -angles, 0)

    -- Disable turning. If DisableTurning unit KV setting is not defined, use the global setting
    local disableTurning = GetUnitKV(newName, "DisableTurning")
    if not disableTurning then
        if BuildingHelper.Settings["DISABLE_BUILDING_TURNING"] then
            newBuilding:AddNewModifier(newBuilding, nil, "modifier_disable_turning", {})
        end
    elseif disableTurning == 1 then
        newBuilding:AddNewModifier(newBuilding, nil, "modifier_disable_turning", {})
    end
    
    local pedestalName = GetUnitKV(newName, "PedestalModel")
    if pedestalName then
        BuildingHelper:CreatePedestalForBuilding(newBuilding, newName, GetGroundPosition(position, nil), pedestalName)
    end    

    newBuilding:SetHealth(newBuilding:GetMaxHealth() - building:GetHealthDeficit())

    -- Kill the old building
    building:AddEffects(EF_NODRAW) --Hide it, so that it's still accessible after this script
    building.upgraded = true --Skips visual effects
    building:ForceKill(true) --This will call RemoveBuilding

    -- Block the grid
    newBuilding.construction_size = BuildingHelper:GetConstructionSize(newName)
    if not string.match(newBuilding:GetUnitName(),"troll_hut") then
        newBuilding.blockers = BuildingHelper:BlockGridSquares(newBuilding.construction_size, BuildingHelper:GetBlockPathingSize(newName), position)
    end

    if bScale == 1 then
        bScaling = true
        newBuilding.updateScaleTimer = Timers:CreateTimer(function()
            if IsValidEntity(newBuilding) and newBuilding:IsAlive() then
                local timesUp = GameRules:GetGameTime() >= fTimeBuildingCompleted
                if not timesUp then
                    if bScaling then
                        if fCurrentScale < fMaxScale then
                            fCurrentScale = fCurrentScale+fScaleInterval
                            newBuilding:SetModelScale(fCurrentScale)
                        else
                            newBuilding:SetModelScale(fMaxScale)
                            bScaling = false
                        end
                    end
                else
                    
                    BuildingHelper:print("Scale was off by: "..(fMaxScale - fCurrentScale))
                    newBuilding:SetModelScale(fMaxScale)
                    return
                end
            else
                -- not valid ent
                return
            end
            
            return fserverFrameRate
        end)
    end


    Timers:CreateTimer(buildTime,function()
        newBuilding:RemoveModifierByName("modifier_stunned")
        if not string.match(newBuilding:GetUnitName(),"troll_hut") then
            local item = CreateItem("item_building_destroy", nil, nil)
            newBuilding:AddItem(item)
        end
    end)

    if building.units_repairing then
        for _,builder in pairs(building.units_repairing) do
            builder.repair_target = newBuilding
        end
    end
    newBuilding.units_repairing = building.units_repairing
    building.upgraded_to = newBuilding

    return newBuilding
end

--[[
    RemoveBuilding
    * Removes a building, removing it from the gridnav, with an optional parameter to skip particle effects
]]--
function BuildingHelper:RemoveBuilding(building, bSkipEffects)
    BuildingHelper:print("Removing Building: "..building:GetUnitName())

    -- Don't show the destruction effects when specified or killed to due UpgradeBuilding
    if not bSkipEffects and building.upgraded ~= true then
        local particleName = GetUnitKV(building:GetUnitName(), "DestructionEffect")
        if particleName then
            local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, building)
            ParticleManager:SetParticleControlEnt(particle, 0, building, PATTACH_POINT_FOLLOW, "attach_origin", building:GetAbsOrigin(), true)
        end

        if building.fireEffectParticle then
            ParticleManager:DestroyParticle(building.fireEffectParticle, false)
            ParticleManager:ReleaseParticleIndex(building.fireEffectParticle)
        end
    end

    if building.prop then
        UTIL_Remove(building.prop)
    end

    if building.minimapEntity then
        building.minimapEntity.correspondingEntity = "dead"
    end

    BuildingHelper:FreeGridSquares(BuildingHelper:GetConstructionSize(building), building:GetAbsOrigin())

    if not building.blockers then 
        return 
    end

    for k, v in pairs(building.blockers) do
        UTIL_Remove(v)
    end
    Timers:CreateTimer(10,function()
        UTIL_Remove(building)
    end)
end

--[[
      StartBuilding
      * Creates the building and starts the construction process
]]--
function BuildingHelper:StartBuilding(builder)
    local playerID = builder:GetMainControllingPlayer()
    local work = builder.work
    local callbacks = work.callbacks
    local building = work.entity -- The building entity
    local unitName = work.name
    local location = work.location
    local player = PlayerResource:GetPlayer(playerID)
    local playersHero = PlayerResource:GetSelectedHeroEntity(playerID)
    local buildingTable = work.buildingTable
    local construction_size = buildingTable:GetVal("ConstructionSize", "number")
    local pathing_size = buildingTable:GetVal("BlockPathingSize", "number")

    -- Check gridnav and cancel if invalid
    if not BuildingHelper:ValidPosition(construction_size, location, builder, callbacks) or playersHero.disabledBuildings[building:GetUnitName()] then
        
        -- Remove the model particle and Advance Queue
        BuildingHelper:AdvanceQueue(builder)
        BuildingHelper:ClearWorkParticles(work)

        -- Remove pedestal
        BuildingHelper:RemoveEntity(work.entity.prop)

        -- Building canceled, refund resources
        work.refund = true
        callbacks.onConstructionCancelled(work)
        return
    end

    BuildingHelper:print("Initializing Building Entity: "..unitName.." at "..VectorString(location))

    -- Mark this work in progress, skip refund if cancelled as the building is already placed
    work.inProgress = true

    -- Spawn point obstructions before placing the building
    local gridNavBlockers = BuildingHelper:BlockGridSquares(construction_size, pathing_size, location)

    -- For overriden ghosts we need to create another unit
    if building:GetUnitName() ~= unitName then
        building = CreateUnitByName(unitName, location, false, playersHero, player, builder:GetTeam())
        building:SetNeverMoveToClearSpace(true)
    else
        building:RemoveModifierByName("modifier_out_of_world")
        building:RemoveEffects(EF_NODRAW)
    end

    -- Make pedestal
    local pedestal = GetUnitKV(unitName, "PedestalModel")
    if pedestal then
        BuildingHelper:CreatePedestalForBuilding(building, unitName, location, pedestal)
    end

    -- Initialize the building
    local model_offset = GetUnitKV(unitName, "ModelOffset") or 0
    location.z = location.z + model_offset
    building:SetAbsOrigin(location)
    building.blockers = gridNavBlockers
    building.construction_size = construction_size
    building.buildingTable = buildingTable
    building.state = "building"
    building.builder = builder
    function building:IsUnderConstruction() return true end

    -- Adjust the Model Orientation
    local yaw = buildingTable:GetVal("ModelRotation", "float")
    building:SetAngles(0, -yaw, 0)

    BuildingHelper:AddModifierBuilding(building)

    -- Prevent regen messing with the building spawn hp gain
    local regen = building:GetBaseHealthRegen()
    building:SetBaseHealthRegen(0)

    ------------------------------------------------------------------
    -- Build Behaviours
    --  RequiresRepair: If set to 1 it will place the building and not update its health nor send the OnConstructionCompleted callback until its fully healed
    --  BuilderInside: Puts the builder unselectable/invulnerable/nohealthbar inside the building in construction
    --  ConsumesBuilder: Kills the builder after the construction is done
    local bRequiresRepair = buildingTable:GetVal("RequiresRepair", "bool")
    local bBuilderInside = buildingTable:GetVal("BuilderInside", "bool")
    local bConsumesBuilder = buildingTable:GetVal("ConsumesBuilder", "bool")
    -------------------------------------------------------------------

    -- whether the building is controllable or not
    local bPlayerCanControl = GetUnitKV(building:GetUnitName(),"PlayerCanControl")
    if bPlayerCanControl then
        building:SetControllableByPlayer(playerID, true)
        building:SetOwner(playersHero)
    end

    -- Start construction
    if callbacks.onConstructionStarted then
        callbacks.onConstructionStarted(building)
    end

    -- buildTime can be overriden in the construction start callback
    local buildTime = buildingTable:GetVal("BuildTime", "float")
    building.buildTime = buildTime
    if building.overrideBuildTime then buildTime = building.overrideBuildTime end

    local startTime = GameRules:GetGameTime()
    local fTimeBuildingCompleted = startTime+buildTime -- the gametime when the building should be completed

    -- Dota server updates at 30 frames per second
    local fserverFrameRate = 1/30

    -- Max and Initial Health factor
    local fMaxHealth = building:GetMaxHealth()
    local fInitialHealthFactor = BuildingHelper.Settings["INITIAL_HEALTH_FACTOR"]
    local nInitialHealth = math.floor(fInitialHealthFactor * (fMaxHealth))
    local fUpdateHealthInterval = math.max(fserverFrameRate, buildTime / math.floor(fMaxHealth-nInitialHealth)) -- health tick interval
    building:SetHealth(nInitialHealth)

    local bScale = buildingTable:GetVal("Scale", "bool") -- whether we should scale the building.
    local fInitialModelScale = 0.2 -- initial size
    local fMaxScale = building.overrideMaxScale or buildingTable:GetVal("MaxScale", "float") or 1 -- the amount to scale to
    local fScaleInterval = (fMaxScale-fInitialModelScale) / (buildTime / fserverFrameRate) -- scale to add every frame, distributed by build time
    local fCurrentScale = fInitialModelScale -- start the building at the initial model scale
    local bScaling = false -- Keep tracking if we're currently model scaling.
    
    -- Set initial scale
    if bScale then
        building:SetModelScale(fCurrentScale)
        bScaling = true
    end

    -- Put the builder invulnerable inside the building in construction
    if bBuilderInside then
        BuildingHelper:HideBuilder(builder, location, building)
    end

    -- Health Update Timer and Behaviors
    if not bRequiresRepair then

        if not bBuilderInside then
            -- Advance Queue
            BuildingHelper:AdvanceQueue(builder)
        end

        local fAddedHealth = 0
        local nHealthInterval = fMaxHealth / (buildTime / fserverFrameRate)
        local fSmallHealthInterval = nHealthInterval - math.floor(nHealthInterval) -- just the floating point component
        nHealthInterval = math.floor(nHealthInterval)
        local fHPAdjustment = 0

        building.updateHealthTimer = Timers:CreateTimer(function()
            if IsValidEntity(building) and building:IsAlive() then
                local timesUp = GameRules:GetGameTime() >= fTimeBuildingCompleted or building:GetHealth() == building:GetMaxHealth()
                if not timesUp then
                    -- Use +1 every frame or float adjustment
                    local hpGain = 0
                    if fUpdateHealthInterval <= fserverFrameRate then
                        fHPAdjustment = fHPAdjustment + fSmallHealthInterval
                        if fHPAdjustment > 1 then
                            hpGain = nHealthInterval + 1
                            fHPAdjustment = fHPAdjustment - 1
                        else
                            hpGain = nHealthInterval
                        end
                    else
                        hpGain = 1
                    end

                    -- Fasten up
                    if GameRules.WarpTen then
                        hpGain = hpGain * 42
                    end

                    if hpGain > 0 then
                        fAddedHealth = fAddedHealth + hpGain
                        building:SetHealth(building:GetHealth() + hpGain)
                        local fModelScale = (buildTime - fTimeBuildingCompleted + GameRules:GetGameTime())/buildTime * (GetUnitKV(building:GetUnitName(),"ModelScale") or 1)
                        DebugPrint(fModelScale)
                        building:SetModelScale(fModelScale)
                    end                    
                else
                    building:SetHealth(building:GetHealth() + fMaxHealth - fAddedHealth - nInitialHealth) -- round up the last little bit
                    BuildingHelper:print("Finished "..building:GetUnitName().." in "..math.floor(GameRules:GetGameTime()-startTime).." seconds. HP was off by "..fMaxHealth - fAddedHealth - nInitialHealth)

                    -- completion: timesUp is true
                    if callbacks.onConstructionCompleted then
                        building.constructionCompleted = true
                        building.state = "complete"
                        building.builder = builder
                        callbacks.onConstructionCompleted(building)
                        function building:IsUnderConstruction() return false end
                    end

                    -- Eject Builder
                    if bBuilderInside then
                    
                        -- Consume Builder
                        if bConsumesBuilder then
                            builder:ForceKill(true)
                        else
                            BuildingHelper:ShowBuilder(builder)
                        end

                        -- Advance Queue
                        BuildingHelper:AdvanceQueue(builder)
                    end
                
                    return
                end
            else
                -- Building destroyed

                -- Eject Builder
                if bBuilderInside then
                    builder:RemoveModifierByName("modifier_builder_hidden")
                    builder:RemoveNoDraw()
                end

                -- Advance Queue
                BuildingHelper:AdvanceQueue(builder)

                return nil
            end
            return fUpdateHealthInterval
        end)    
    else
        -- The building will have to be assisted through a repair ability
        local repair_ability = BuildingHelper:GetRepairAbility(builder)
        if repair_ability then
            self:print("Building "..building:GetUnitName().." will be constructed using RepairAbility")
            building.repair_distance = (builder:GetAbsOrigin() - building:GetAbsOrigin()):Length2D() -- To instantly start repairing
            building.callbacks = callbacks
            BuildingHelper:StartRepair(builder, building)
        else
            self:print("Error, couldn't find \"RepairAbility\" of "..builder:GetUnitName())
        end
    end

    --[[ Scale Update Timer
    if bScale then
        building.updateScaleTimer = Timers:CreateTimer(function()
            if IsValidEntity(building) and building:IsAlive() then
                local timesUp = GameRules:GetGameTime() >= fTimeBuildingCompleted
                if not timesUp then
                    if bScaling then
                        if fCurrentScale < fMaxScale then
                            fCurrentScale = fCurrentScale+fScaleInterval
                            building:SetModelScale(fCurrentScale)
                        else
                            building:SetModelScale(fMaxScale)
                            bScaling = false
                        end
                    end
                else
                    
                    BuildingHelper:print("Scale was off by: "..(fMaxScale - fCurrentScale))
                    building:SetModelScale(fMaxScale)
                    return
                end
            else
                -- not valid ent
                return
            end
            
            return fserverFrameRate
        end)
    end]]

    -- OnBelowHalfHealth timer
    building.onBelowHalfHealthProc = false
    building.healthChecker = Timers:CreateTimer(.2, function()
        local fireEffect = GetUnitKV(unitName, "FireEffect")
        local attachPoint = GetUnitKV(unitName, "AttachPoint")

        if IsValidEntity(building) and building:IsAlive() then
            local health_percentage = building:GetHealthPercent() * 0.01
            local belowThreshold = health_percentage < BuildingHelper.Settings["FIRE_EFFECT_FACTOR"]
            if belowThreshold and not building.onBelowHalfHealthProc and building.state == "complete" then
                if fireEffect then
                    -- Fire particle
                    if attachPoint then
                        building.fireEffectParticle = ParticleManager:CreateParticle(fireEffect, PATTACH_CUSTOMORIGIN_FOLLOW, building)
                        ParticleManager:SetParticleControlEnt(building.fireEffectParticle, 0, building, PATTACH_POINT_FOLLOW, attachPoint, building:GetAbsOrigin(), true)
                    else
                        building.fireEffectParticle = ParticleManager:CreateParticle(fireEffect, PATTACH_ABSORIGIN_FOLLOW, building)
                    end
                end
            
                callbacks.onBelowHalfHealth(building)
                building.onBelowHalfHealthProc = true
            elseif not belowThreshold and building.onBelowHalfHealthProc and building.state == "complete" then
                if fireEffect then
                    ParticleManager:DestroyParticle(building.fireEffectParticle, false)
                    ParticleManager:ReleaseParticleIndex(building.fireEffectParticle)
                end

                callbacks.onAboveHalfHealth(building)
                building.onBelowHalfHealthProc = false
            end
        else
            return nil
        end
        return .2
    end)

    -- Remove the work particles
    BuildingHelper:ClearWorkParticles(work)
end

function CDOTA_BaseNPC:IsUnderConstruction()
    return not(self.constructionCompleted) or false
end

     --[[
      StartRepair
      * Starts the repair process when the builder is on range of the target
]]--
function BuildingHelper:StartRepair(builder, target)
    local work = builder.work
    local underConstruction = IsCustomBuilding(target) and target:IsUnderConstruction() or false -- For RequiresRepair building behaviour
    
    -- Check target and cancel if invalid
    local repair_ability = BuildingHelper:GetRepairAbility(builder)
    if underConstruction and repair_ability and not repair_ability:GetKeyValue("CanAssistConstruction") then
        self:print("The Repair Ability "..repair_ability:GetAbilityName().." can't be used to assist construction! Cancelling")

        -- Advance Queue
        BuildingHelper:AdvanceQueue(builder)

        BuildingHelper:OnRepairCancelled(builder, target)
        return
    end

    -- External repair callback
    self:OnRepairStarted(builder, target)

    -- Initialize builder list
    target.units_repairing = target.units_repairing or {}
    table.insert(target.units_repairing, builder)
    builder.repair_target = target

    builder:Stop()
    builder:SetForwardVector((target:GetAbsOrigin() - builder:GetAbsOrigin()):Normalized())

    local buildTime = target.buildTime or target:GetKeyValue("BuildTime")
    local costRatio = repair_ability and repair_ability:GetKeyValue("RepairCostRatio") or BuildingHelper.Settings.REPAIR_SETTINGS["RepairCostRatio"]
    local timeRatio = repair_ability and repair_ability:GetKeyValue("RepairTimeRatio") or BuildingHelper.Settings.REPAIR_SETTINGS["RepairTimeRatio"]
    local powerBuildCost = repair_ability and repair_ability:GetKeyValue("PowerbuildCost") or BuildingHelper.Settings.REPAIR_SETTINGS["PowerbuildCost"]
    local powerBuildRate = repair_ability and repair_ability:GetKeyValue("PowerbuildRate") or BuildingHelper.Settings.REPAIR_SETTINGS["PowerbuildRate"]

    -- C++ -> Lua Double nonsense
    function correctFloat(f) return tonumber(string.format("%.4f", f)) end
    timeRatio = correctFloat(timeRatio)
    costRatio = correctFloat(costRatio)
    powerBuildCost = correctFloat(powerBuildCost)
    powerBuildRate = correctFloat(powerBuildRate)

    local fserverFrameRate = 1/30
    local fAddedHealth = 0
    local fHPAdjustment = 0

    local repairing = {}
    for k,v in pairs(target.units_repairing) do
        if IsValidEntity(v) and v:IsAlive() then
            table.insert(repairing, v)
        end
    end
    target.units_repairing = repairing

    builder.state = "repairing"
    builder.lastRepairPosition = builder:GetAbsOrigin()
    builder:AddNewModifier(builder, repair_ability, "modifier_builder_repairing", {})
    target:AddNewModifier(target, repair_ability, "modifier_repairing", {})
    target:SetModifierStackCount("modifier_repairing", target, getTableCount(target.units_repairing))

    -- If its an unfinished building, keep track of how much does it require to mark as finished
    if underConstruction and not target.missingHealthToComplete then
        target.missingHealthToComplete = target:GetHealthDeficit()
    end

    -- Repair Dynamic Tick
    if not target.repairTimer then
        target.repairTimer = Timers:CreateTimer(function()
            local builderCount = 0
            for k,v in pairs(target.units_repairing) do
                if IsValidEntity(v) and v:IsAlive() then builderCount = builderCount + 1 end
            end

            if not IsValidEntity(target) or not target:IsAlive() then
                if target and target.units_repairing and not target.upgraded then
                    self:CancelRepair(target)
                    return
                end

                -- Redirect in case of upgrade
                if target.upgraded and target.units_repairing then
                    target = target.upgraded_to
                    if not IsValidEntity(repair_ability) then
                        repair_ability = target.units_repairing[1]:GetRepairAbility()
                    end
                    if not IsValidEntity(repair_ability) then
                        self:print("Something went wrong, couldn't get a RepairAbility on the first repairing unit")
                    else
                        target:AddNewModifier(target, repair_ability, "modifier_repairing", {})
                    end
                end
            end

            target:SetModifierStackCount("modifier_repairing", target, builderCount)
            if builderCount == 0 then
                self:CancelRepair(target)
                return
            end



            -- Builders must be stopped and close to the target to count and heal hitpoints
            builderCount = BuildingHelper:GetNumBuildersRepairing(target)
            if builderCount == 0 then return fserverFrameRate end

            if underConstruction then
                local nextTick = buildTime/target:GetMaxHealth()
                local hpGain = 0

                -- Calculate the HP to be gained on this tick
                if nextTick > fserverFrameRate then
                    hpGain = 1
                else
                    local nHealthInterval = target:GetMaxHealth() / (buildTime / fserverFrameRate)
                    local fSmallHealthInterval = nHealthInterval - math.floor(nHealthInterval) --floating point component
                    nHealthInterval = math.floor(nHealthInterval)

                    -- How much HP do we add this frame?
                    fHPAdjustment = fHPAdjustment + fSmallHealthInterval
                    if fHPAdjustment > 1 then
                        fHPAdjustment = fHPAdjustment - 1
                        hpGain = nHealthInterval + 1
                    elseif nHealthInterval > 0 then
                        hpGain = nHealthInterval
                    end

                    nextTick = fserverFrameRate
                end                
                if hpGain > 0 and target.missingHealthToComplete then
                    target.missingHealthToComplete = target.missingHealthToComplete - hpGain
                    target:SetHealth(target:GetHealth() + hpGain)
                    local fModelScale = (target:GetMaxHealth() - target.missingHealthToComplete)/target:GetMaxHealth() * (GetUnitKV(target:GetUnitName(),"ModelScale") or 1)
                    target:SetModelScale(fModelScale)


                end

                local health_deficit = underConstruction and target.missingHealthToComplete or target:GetHealthDeficit()
                if health_deficit <= 0 then
                    -- Finished repair-construction
                    target.missingHealthToComplete = nil
                    self:CancelRepair(target)

                    if IsCustomBuilding(target) and target.callbacks and target.callbacks.onConstructionCompleted then
                        target.constructionCompleted = true
                        work.refund = false
                        function target:IsUnderConstruction() return false end
                        target.state = "complete"
                        target.callbacks.onConstructionCompleted(target)
                    end

                    self:OnRepairFinished(builder, target)
                    target.units_repairing = {}
                    return
                end

                return nextTick
            else
                local hpGain = 0
                for _,uBuilder in pairs(target.units_repairing) do
                    local bIsFixedRepair = BuildingHelper:IsFixedRepair(uBuilder)
                    local repairSpeed = BuildingHelper:GetRepairSpeed(uBuilder)
                    hpGain = hpGain + (bIsFixedRepair==1 and repairSpeed or target:GetMaxHealth() * repairSpeed/100)
                end
                local nextTick = 1/hpGain
                if nextTick > fserverFrameRate then
                    hpGain = 1
                else
                    hpGain = hpGain * fserverFrameRate
                    nextTick = fserverFrameRate
                end

                if hpGain > 0 and not target:HasModifier("modifier_disable_repair") then
                    target:SetHealth(target:GetHealth() + hpGain)
                end

                local health_deficit = underConstruction and target.missingHealthToComplete or target:GetHealthDeficit()
                if health_deficit <= 0 then
                    -- Finished repair-construction
                    target.missingHealthToComplete = nil
                    self:CancelRepair(target)

                    if IsCustomBuilding(target) and target.callbacks and target.callbacks.onConstructionCompleted then
                        target.constructionCompleted = true
                        work.refund = false
                        function target:IsUnderConstruction() return false end
                        target.state = "complete"
                        target.callbacks.onConstructionCompleted(target)
                    end

                    self:OnRepairFinished(builder, target)
                    target.units_repairing = {}
                    return
                end

                return nextTick
            end
        end)
    end
end

function BuildingHelper:GetNumBuildersRepairing(target)
    if not target.units_repairing then return 0 end

    local targetPos = target:GetAbsOrigin()
    local numReparing = 0
    for _,unit in pairs(target.units_repairing) do
        if IsValidEntity(unit) then
            local currentPos = unit:GetAbsOrigin()
            if not unit.lastRepairPosition then
                unit.lastRepairPosition = currentPos
                unit.state = "repairing"
                numReparing = numReparing + 1
            else
                local changedPosition = (unit.lastRepairPosition-currentPos):Length2D() > 1
                if changedPosition or (targetPos-currentPos):Length2D() > (unit.repairRange or unit:GetFollowRange(target)) then
                    unit.state = "moving_to_repair"
                    unit:MoveToNPC(target)
                else
                    unit.state = "repairing"
                    numReparing = numReparing + 1
                end
                unit.lastRepairPosition = currentPos
            end
        end
    end
    return numReparing
end

function BuildingHelper:CancelRepair(building)
    building.repairTimer = nil
    if building.units_repairing == nil then return end
    for k,v in pairs(building.units_repairing) do
        if IsValidEntity(v) and v:IsAlive() then
            v:RemoveModifierByName("modifier_builder_repairing")
            local repair_ability = BuildingHelper:GetRepairAbility(v)
            if repair_ability and repair_ability:GetToggleState() then
                repair_ability:ToggleAbility()
            end
            v.state = "idle"
            if IsValidEntity(building) then
                self:OnRepairCancelled(v, building)
            end
            BuildingHelper:AdvanceQueue(v)
        end
    end
    building.units_repairing = {}
    if IsValidEntity(building) then
        building:RemoveModifierByName("modifier_repairing")
        self:print("Repair of "..building:GetUnitName().." fully cancelled")
    else
        self:print("Building removed during the repair process")
    end
end



--[[
      BlockGridSquares
      * Blocks a square of certain construction and pathing size at a location on the server grid
      * construction_size: square of grid points to block from construction
      * pathing_size: square of pathing obstructions that will be spawned 
]]--
function BuildingHelper:BlockGridSquares(construction_size, pathing_size, location)
    BuildingHelper:RemoveGridType(construction_size, location, "BUILDABLE")
    BuildingHelper:AddGridType(construction_size, location, "BLOCKED")

    return BuildingHelper:BlockPSO(pathing_size, location)
end

-- Spawns a square of point_simple_obstruction entities at a location
function BuildingHelper:BlockPSO(size, location)
    if size == 0 then return end

    local pos = Vector(location.x, location.y, location.z)
    BuildingHelper:SnapToGrid(size, pos)

    local gridNavBlockers = {}
    if size % 2 == 1 then
        for x = pos.x - (size-2) * 32, pos.x + (size-2) * 32, 64 do
            for y = pos.y - (size-2) * 32, pos.y + (size-2) * 32, 64 do
                local blockerLocation = Vector(x, y, pos.z)
                local ent = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = blockerLocation})
                table.insert(gridNavBlockers, ent)
            end
        end
    else
        local len = size * 32 - 64
        if len == 0 then
            local ent = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = pos})
            table.insert(gridNavBlockers, ent)
        else
            for x = pos.x - len, pos.x + len, 128 do
                for y = pos.y - len, pos.y + len, 128 do
                    local blockerLocation = Vector(x, y, pos.z)
                    local ent = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = blockerLocation})
                    table.insert(gridNavBlockers, ent)
                end
            end
        end
    end

    return gridNavBlockers
end

-- Clears out an area for construction
function BuildingHelper:FreeGridSquares(construction_size, location)
    BuildingHelper:RemoveGridType(construction_size, location, "BLOCKED")
    BuildingHelper:AddGridType(construction_size, location, "BUILDABLE")
end

function BuildingHelper:NewGridType(grid_type)
    grid_type = string.upper(grid_type)
    BuildingHelper.GridTypes[grid_type] = BuildingHelper.NextGridValue
    BuildingHelper.NextGridValue = BuildingHelper.NextGridValue * 2
    CustomNetTables:SetTableValue("building_settings", "grid_types", BuildingHelper.GridTypes)
end

-- Adds a grid_type to a square of size at centered at a location
function BuildingHelper:AddGridType(size, location, grid_type, shape)
    -- If it doesn't exist, add it
    grid_type = string.upper(grid_type)
    if not BuildingHelper.GridTypes[grid_type] then
        BuildingHelper:NewGridType(grid_type)
    end

    if shape == "radius" then
        BuildingHelper:SetGridTypeRadius(size, location, grid_type, "add")
    else
        BuildingHelper:SetGridType(size, location, grid_type, "add")
    end
end

-- Removes grid_type from every cell of a square around the location
function BuildingHelper:RemoveGridType(size, location, grid_type, shape)
    if shape == "radius" then
        BuildingHelper:SetGridTypeRadius(size, location, grid_type, "remove")
    else
        BuildingHelper:SetGridType(size, location, grid_type, "remove")
    end
end

-- Central function used to add, remove or override multiple grid squares at once
function BuildingHelper:SetGridType(size, location, grid_type, option)
    if not size or size == 0 then return end

    local originX = GridNav:WorldToGridPosX(location.x)
    local originY = GridNav:WorldToGridPosY(location.y)
    local halfSize = math.floor(size/2)
    local boundX1 = originX + halfSize
    local boundX2 = originX - halfSize
    local boundY1 = originY + halfSize
    local boundY2 = originY - halfSize

    local lowerBoundX = math.min(boundX1, boundX2)
    local upperBoundX = math.max(boundX1, boundX2)
    local lowerBoundY = math.min(boundY1, boundY2)
    local upperBoundY = math.max(boundY1, boundY2)

    -- Adjust even size
    if (size % 2) == 0 then
        upperBoundX = upperBoundX-1
        upperBoundY = upperBoundY-1
    end

    -- Adjust to upper case
    grid_type = string.upper(grid_type)

    -- Default by omission is to override the old value
    if not option then
        for y = lowerBoundY, upperBoundY do
            for x = lowerBoundX, upperBoundX do
                BuildingHelper.Grid[y][x] = BuildingHelper.GridTypes[grid_type]
            end
        end

    elseif option == "add" then
        for y = lowerBoundY, upperBoundY do
            for x = lowerBoundX, upperBoundX do
                -- Only add if it doesn't have it yet
                local hasGridType = BuildingHelper:CellHasGridType(x,y,grid_type)
                if not hasGridType then
                    BuildingHelper.Grid[y][x] = BuildingHelper.Grid[y][x] + BuildingHelper.GridTypes[grid_type]
                end
            end
        end

    elseif option == "remove" then
        for y = lowerBoundY, upperBoundY do
            for x = lowerBoundX, upperBoundX do
                -- Only remove if it has it
                local hasGridType = BuildingHelper:CellHasGridType(x,y,grid_type)
                if hasGridType then
                    BuildingHelper.Grid[y][x] = BuildingHelper.Grid[y][x] - BuildingHelper.GridTypes[grid_type]
                end
            end
        end
    end     
end

-- Alternative with radius
function BuildingHelper:SetGridTypeRadius(radius, location, grid_type, option)
    if not radius or radius == 0 then return end

    -- Adjust radius to size
    local size = (radius - (radius%32))/32

    local originX = GridNav:WorldToGridPosX(location.x)
    local originY = GridNav:WorldToGridPosY(location.y)
    local halfSize = math.floor(size/2)
    local boundX1 = originX + halfSize
    local boundX2 = originX - halfSize
    local boundY1 = originY + halfSize
    local boundY2 = originY - halfSize

    local lowerBoundX = math.min(boundX1, boundX2)
    local upperBoundX = math.max(boundX1, boundX2)
    local lowerBoundY = math.min(boundY1, boundY2)
    local upperBoundY = math.max(boundY1, boundY2)

    -- Adjust even size
    if (size % 2) == 0 then
        upperBoundX = upperBoundX-1
        upperBoundY = upperBoundY-1
    end

    -- Adjust to upper case
    grid_type = string.upper(grid_type)

    -- Default by omission is to override the old value
    if not option then
        for y = lowerBoundY, upperBoundY do
            for x = lowerBoundX, upperBoundX do
                local current_pos = Vector(GridNav:GridPosToWorldCenterX(x), GridNav:GridPosToWorldCenterY(y), 0)
                local distance = (current_pos - location):Length2D()
                if distance <= radius then
                    BuildingHelper.Grid[y][x] = BuildingHelper.GridTypes[grid_type]
                end
            end
        end

    elseif option == "add" then
        for y = lowerBoundY, upperBoundY do
            for x = lowerBoundX, upperBoundX do
                -- Only add if it doesn't have it yet
                local hasGridType = BuildingHelper:CellHasGridType(x,y,grid_type)
                if not hasGridType then
                    local current_pos = Vector(GridNav:GridPosToWorldCenterX(x), GridNav:GridPosToWorldCenterY(y), 0)
                    local distance = (current_pos - location):Length2D()
                    if distance <= radius then
                        BuildingHelper.Grid[y][x] = BuildingHelper.Grid[y][x] + BuildingHelper.GridTypes[grid_type]
                    end
                end
            end
        end

    elseif option == "remove" then
         for y = lowerBoundY, upperBoundY do
            for x = lowerBoundX, upperBoundX do
                -- Only remove if it has it
                local hasGridType = BuildingHelper:CellHasGridType(x,y,grid_type)
                if hasGridType then
                    local current_pos = Vector(GridNav:GridPosToWorldCenterX(x), GridNav:GridPosToWorldCenterY(y), 0)
                    local distance = (current_pos - location):Length2D()
                    if distance <= radius then
                        BuildingHelper.Grid[y][x] = BuildingHelper.Grid[y][x] - BuildingHelper.GridTypes[grid_type]
                    end
                end
            end
        end
    end     
end

-- Returns a string with each of the grid types of the cell, mostly to debug
function BuildingHelper:GetCellGridTypes(x,y)
    local s = ""
    for grid_string,value in pairs(BuildingHelper.GridTypes) do
        local hasGridType = BuildingHelper:CellHasGridType(x,y,grid_string)
        if hasGridType then
            s = s..grid_string.." "
        end
    end
    return s
end

-- Checks if the cell has a certain grid type by name
function BuildingHelper:CellHasGridType(x, y, grid_type)
    if BuildingHelper.GridTypes[grid_type] then
        return bit.band(BuildingHelper.Grid[y][x], BuildingHelper.GridTypes[grid_type]) ~= 0
    end
end

--[[
      ValidPosition
      * Checks GridNav square of certain size at a location
      * Sends onConstructionFailed if invalid
]]--
function BuildingHelper:ValidPosition(size, location, unit, callbacks)
    local bBlocked

    -- Check for special requirement
    local playerTable = BuildingHelper:GetPlayerTable(unit:GetPlayerOwnerID())
    local buildingName = playerTable.activeBuilding
    if unit.work then buildingName = unit.work.name end
    local buildingTable = buildingName and GetUnitKV(buildingName)
    local requires = buildingTable and buildingTable["Requires"]
    local prevents = buildingTable and buildingTable["Prevents"]

    if requires then
        bBlocked = not BuildingHelper:AreaMeetsCriteria(size, location, requires, "all")
    else
        bBlocked = BuildingHelper:IsAreaBlocked(size, location)
    end

    if prevents then
        bBlocked = bBlocked or BuildingHelper:AreaMeetsCriteria(size, location, prevents, "one")
    end

    if bBlocked then
        if callbacks.onConstructionFailed then
            callbacks.onConstructionFailed()
            return false
        end
    end

    -- Check enemy units blocking the area
    local construction_radius = size * 64
    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
    local enemies = FindUnitsInRadius(unit:GetTeamNumber(), location, nil, construction_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
    for _,enemy in pairs(enemies) do
        local origin = enemy:GetAbsOrigin()
        if not IsCustomBuilding(enemy) and BuildingHelper:EnemyIsInsideBuildingArea(enemy:GetAbsOrigin(), location, size) then
            if callbacks.onConstructionFailed then
                callbacks.onConstructionFailed()
                return false
            end
        end      
     end

    return true
end

function BuildingHelper:GetBounds(point, len)
    local bounds = {}
    local X1 = point.x + len
    local X2 = point.x - len
    local Y1 = point.y + len
    local Y2 = point.y - len
    bounds.Min = {x=math.min(X1, X2),y=math.min(Y1, Y2)}
    bounds.Max = {x=math.max(X1, X2),y=math.max(Y1, Y2)}
    return bounds
end

function BuildingHelper:EnemyIsInsideBuildingArea(enemy_location, building_location, size)
    local bBounds = BuildingHelper:GetBounds(building_location, size * 32)
    
    -- Enemy covers 2x2 squares
    BuildingHelper:SnapToGrid(2, enemy_location)
    local eBounds = BuildingHelper:GetBounds(enemy_location, 64)

    local function between(num, lower, upper)
        return num < upper and num > lower
    end

    local betweenX = between(eBounds.Min.x, bBounds.Min.x, bBounds.Max.x) or between(eBounds.Max.x, bBounds.Min.x, bBounds.Max.x) or between(bBounds.Min.x, eBounds.Min.x, eBounds.Max.x) or between(bBounds.Max.x, eBounds.Min.x, eBounds.Max.x) or between(enemy_location.x,bBounds.Min.x,bBounds.Max.x) or between(building_location.x,eBounds.Min.x,eBounds.Max.x)
    local betweenY = between(eBounds.Min.y, bBounds.Min.y, bBounds.Max.y) or between(eBounds.Max.y, bBounds.Min.y, bBounds.Max.y) or between(bBounds.Min.y, eBounds.Min.y, eBounds.Max.y) or between(bBounds.Max.y, eBounds.Min.y, eBounds.Max.y) or between(enemy_location.y,bBounds.Min.y,bBounds.Max.y) or between(building_location.y,eBounds.Min.y,eBounds.Max.y)

    return betweenX and betweenY
end



-- If not all squares are buildable, the area is blocked
function BuildingHelper:IsAreaBlocked(size, location)
    return BuildingHelper:AreaMeetsCriteria(size, location, "BLOCKED", "one")
end

-- Checks that all squares meet each of the passed grid_type criteria (can be multiple, split by spaces)
function BuildingHelper:AreaMeetsCriteria(size, location, grid_type, option)
    local originX = GridNav:WorldToGridPosX(location.x)
    local originY = GridNav:WorldToGridPosY(location.y)
    local halfSize = math.floor(size/2)
    local boundX1 = originX + halfSize
    local boundX2 = originX - halfSize
    local boundY1 = originY + halfSize
    local boundY2 = originY - halfSize

    local lowerBoundX = math.min(boundX1, boundX2)
    local upperBoundX = math.max(boundX1, boundX2)
    local lowerBoundY = math.min(boundY1, boundY2)
    local upperBoundY = math.max(boundY1, boundY2)

    -- Adjust even size
    if (size % 2) == 0 then
        upperBoundX = upperBoundX-1
        upperBoundY = upperBoundY-1
    end

    -- Default by omission is to check if all the cells meet the criteria
    if not option or option == "all" then
        for y = lowerBoundY, upperBoundY do
            for x = lowerBoundX, upperBoundX do
                local grid_types = split(grid_type, " ")
                for k,v in pairs(grid_types) do
                    local t = string.upper(v)
                    local hasGridType = BuildingHelper:CellHasGridType(x,y,t)
                    if not hasGridType then
                        return false
                    end
                end
            end
        end
        return true -- all cells have the grid types

    -- When searching for one block, stop at the first grid point found with every type
    elseif option == "one" then
        for y = lowerBoundY, upperBoundY do
            for x = lowerBoundX, upperBoundX do
                local grid_types = split(grid_type, " ")
                local hasGridType = true
                for k,v in pairs(grid_types) do
                    local t = string.upper(v)
                    hasGridType = hasGridType and BuildingHelper:CellHasGridType(x,y,t)
                end

                if hasGridType then
                    return true
                end
            end
        end
        return false -- no cells meet the criteria
    end
end


--[[
    AddToQueue
    * Adds a location to the builders work queue
    * bQueued will be true if the command was done with shift pressed
    * If bQueued is false, the queue is cleared and this building is put on top
]]--
function BuildingHelper:AddToQueue(builder, location, bQueued)
    local playerID = builder:GetMainControllingPlayer()
    local player = PlayerResource:GetPlayer(playerID)
    local playerTable = BuildingHelper:GetPlayerTable(playerID)
    local buildingName = playerTable.activeBuilding
    local buildingTable = playerTable.activeBuildingTable
    local fMaxScale = buildingTable:GetVal("MaxScale", "float")
    local size = buildingTable:GetVal("ConstructionSize", "number")
    local pathing_size = buildingTable:GetVal("BlockGridNavSize", "number")
    local callbacks = playerTable.activeCallbacks
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)

    --[[if hero.disabledBuildings[buildingName] == true then
        return
    end]]
    BuildingHelper:SnapToGrid(size, location)

    -- Check gridnav
    if not BuildingHelper:ValidPosition(size, location, builder, callbacks) then
        return
    end

    -- External pre construction checks
    if callbacks.onPreConstruction then
        local result = callbacks.onPreConstruction(location)
        if result == false then
            return
        end
    end

    BuildingHelper:print("AddToQueue "..builder:GetUnitName().." "..builder:GetEntityIndex().." -> location "..VectorString(location))
    
    -- Make the new work entry
    local work = {["location"] = location, ["name"] = buildingName, ["buildingTable"] = buildingTable, ["callbacks"] = callbacks}

    -- Position chosen is initially valid, send callback to spend gold
    callbacks.onBuildingPosChosen(location)


    -- Self placement doesn't make ghost particles on the placement area
    if builder:GetUnitName() == buildingName then
        -- Never queued
        BuildingHelper:ClearQueue(builder)
        table.insert(builder.buildingQueue, work)

        BuildingHelper:AdvanceQueue(builder)
        BuildingHelper:print("Starting self placement of "..buildingName)

    else
        -- Adjust the model position z
        local model_offset = GetUnitKV(buildingName, "ModelOffset") or GetUnitKV(buildingName, "ModelGhostOffset") or 0
        local model_location = Vector(location.x, location.y, location.z + model_offset)

        -- npc_dota_creature doesn't render cosmetics on the particle ghost, use hero names instead
        local overrideGhost = buildingTable:GetVal("OverrideBuildingGhost", "string")
        local unitName = overrideGhost or buildingName
        local entity
        if overrideGhost then
            -- Use a hero dummy to project the queue particles
            entity = BuildingHelper:GetOrCreateDummy(unitName)
        else
            -- Create the building entity that will be used to start construction and project the queue particles
            entity = CreateUnitByName(unitName, model_location, false, nil, nil, builder:GetTeam())
            entity:SetNeverMoveToClearSpace(true)
            function entity:IsUnderConstruction() return true end
        end
        entity:AddEffects(EF_NODRAW)
        entity:AddNewModifier(entity, nil, "modifier_out_of_world", {})
        work.entity = entity

        local modelParticle = ParticleManager:CreateParticleForPlayer("particles/buildinghelper/ghost_model.vpcf", PATTACH_CUSTOMORIGIN, nil, player)
        ParticleManager:SetParticleControl(modelParticle, 0, model_location)
        ParticleManager:SetParticleControlEnt(modelParticle, 1, entity, 1, "attach_hitloc", entity:GetAbsOrigin(), true) -- Model attach          
        ParticleManager:SetParticleControl(modelParticle, 3, Vector(BuildingHelper.Settings["MODEL_ALPHA"],0,0)) -- Alpha
        ParticleManager:SetParticleControl(modelParticle, 4, Vector(fMaxScale,0,0)) -- Scale
        work.particleIndex = modelParticle

        local color = BuildingHelper.Settings["RECOLOR_BUILDING_PLACED"] and Vector(0,255,0) or Vector(255,255,255)
        ParticleManager:SetParticleControl(modelParticle, 2, color) -- Color

        -- Create pedestal for particles
        local pedestal = buildingTable:GetVal("PedestalModel")
        if pedestal then
            local prop = BuildingHelper:GetOrCreateProp(pedestal)
            local scale = buildingTable:GetVal("PedestalModelScale", "float") or entity:GetModelScale()
            local offset = buildingTable:GetVal("PedestalOffset", "float") or 0
            local offset_location = Vector(location.x, location.y, location.z + offset)

            prop:AddEffects(EF_NODRAW)
            prop.pedestalParticle = ParticleManager:CreateParticleForPlayer("particles/buildinghelper/ghost_model.vpcf", PATTACH_CUSTOMORIGIN, nil, player)
            ParticleManager:SetParticleControl(prop.pedestalParticle, 0, offset_location)
            ParticleManager:SetParticleControlEnt(prop.pedestalParticle, 1, prop, 1, "attach_hitloc", prop:GetAbsOrigin(), true) -- Model attach
            ParticleManager:SetParticleControl(prop.pedestalParticle, 2, color) -- Color
            ParticleManager:SetParticleControl(prop.pedestalParticle, 3, Vector(BuildingHelper.Settings["MODEL_ALPHA"],0,0)) -- Alpha
            ParticleManager:SetParticleControl(prop.pedestalParticle, 4, Vector(scale,0,0)) -- Scale
            work.propParticleIndex = prop.pedestalParticle
        end

        -- Adjust the Model Orientation
        local yaw = buildingTable:GetVal("ModelRotation", "float")
        entity:SetAngles(0, -yaw, 0)

        -- If the ability wasn't queued, override the building queue
        if not bQueued then
            BuildingHelper:ClearQueue(builder)
        end
        builder.buildingQueue = builder.buildingQueue or {}
        -- Add this to the builder queue
        table.insert(builder.buildingQueue, work)

        -- If the builder doesn't have a current work, start the queue
        -- Extra check for builder-inside behaviour, those abilities are always queued
        if builder.work == nil and not builder:HasModifier("modifier_builder_hidden") and not (builder.state == "repairing" or builder.state == "moving_to_repair") then
            builder.work = builder.buildingQueue[1]
            BuildingHelper:AdvanceQueue(builder)
            BuildingHelper:print("Builder doesn't have work to do, start right away")
        else
            BuildingHelper:print("Work was queued, builder already has work to do")
            BuildingHelper:PrintQueue(builder)
        end
    end
end


--[[
    AddRepairToQueue
    * Adds a repair to the builders work queue
    * bQueued will be true if the command was done with shift pressed
    * If bQueued is false, the queue is cleared and this repair is put on top
]]--
function BuildingHelper:AddRepairToQueue(builder, building, bQueued)
    -- External pre repair checks
    local bResult = self:OnPreRepair(builder, building)
    if bResult == false then return end

    local playerID = builder:GetMainControllingPlayer()
    local player = PlayerResource:GetPlayer(playerID)
    local playerTable = BuildingHelper:GetPlayerTable(playerID)
    local buildingName = building:GetUnitName()
    local buildingTable = playerTable.activeBuildingTable
    local callbacks = playerTable.activeCallbacks

    BuildingHelper:print("AddRepairToQueue "..builder:GetUnitName().." "..builder:GetEntityIndex().." -> building "..building:GetUnitName())
    
    -- Make the new work entry
    local work = {["building"] = building, ["name"] = buildingName, ["buildingTable"] = buildingTable, ["callbacks"] = callbacks}
    work.repair = true
    -- If the ability wasn't queued, override the building queue
    if not bQueued then
        BuildingHelper:ClearQueue(builder)
    end

    -- Add this to the builder queue
    table.insert(builder.buildingQueue, work)

    -- If the builder doesn't have a current work, start the queue
    -- Extra check for builder-inside behaviour, those abilities are always queued
    if builder.work == nil and not builder:HasModifier("modifier_builder_hidden") and not (builder.state == "repairing" or builder.state == "moving_to_repair") then
        builder.work = builder.buildingQueue[1]
        BuildingHelper:print("Builder doesn't have work to do, start moving to repair right away")
        BuildingHelper:AdvanceQueue(builder)
    else
        BuildingHelper:print("Repair Work was queued, builder already has work to do")
        BuildingHelper:PrintQueue(builder)
    end
end


--[[
      AdvanceQueue
      * Processes an item of the builders work queue
]]--
function BuildingHelper:AdvanceQueue(builder)
    if (builder.move_to_build_timer) then Timers:RemoveTimer(builder.move_to_build_timer) end

    if builder.buildingQueue and #builder.buildingQueue > 0 then
        BuildingHelper:PrintQueue(builder)

        local work = builder.buildingQueue[1]
        table.remove(builder.buildingQueue, 1) --Pop

        if work.building then
            -- Repair Queued
            if not IsValidEntity(work.building) or not work.building:IsAlive() then
                self:print("Queued Repair "..work.name.." but it was removed, continue with the queue")
                self:AdvanceQueue(builder)                
            else
                local building = work.building
                local callbacks = work.callbacks
                local castRange = builder:GetFollowRange(building)
                if building.repair_distance then castRange = math.max(building.repair_distance, castRange) end
                builder.work = work
                builder.repair_target = building
                builder.state = "moving_to_repair"

                self:print("AdvanceQueue: Repair "..work.name.." "..work.building:GetEntityIndex())

                -- Move towards the building until close range
                -- TODO: The Cast. Multi Order via either Right Click or Repair Ability
                ExecuteOrderFromTable({UnitIndex = builder:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET, TargetIndex = building:GetEntityIndex(), Queue = false}) 
                builder.move_to_build_timer = Timers:CreateTimer(function()
                    if not IsValidEntity(builder) or not builder:IsAlive() then return end -- End if killed
                    if not IsValidEntity(building) or not building:IsAlive() then return end -- End if killed
                    
                    local distance = (building:GetAbsOrigin() - builder:GetAbsOrigin()):Length()
                    if distance > castRange then
                        return 0.03
                    else
                        self:print("Reached building, start the Repair process!")
                        --builder:Stop()
                        
                        builder.repairRange = castRange
                        BuildingHelper:StartRepair(builder, building)
                        return
                    end
                end)
            end
        else
            -- Construction Queued
            local buildingTable = work.buildingTable
            local castRange = buildingTable:GetVal("AbilityCastRange", "number")
            local callbacks = work.callbacks
            local location = work.location
            builder.work = work

            -- Move towards the point at cast range
            builder:MoveToPosition(location)
            builder.move_to_build_timer = Timers:CreateTimer(0.03, function()
                builder:MoveToPosition(location)
                if not IsValidEntity(builder) or not builder:IsAlive() then return end
                builder.state = "moving_to_build"

                local distance = (location - builder:GetAbsOrigin()):Length2D()
                if distance > castRange then
                    return 0.03
                else
                    builder:Stop()
                    
                    -- Self placement goes directly to the OnConstructionStarted callback
                    if work.name == builder:GetUnitName() then
                        local callbacks = work.callbacks
                        if callbacks.onConstructionStarted then
                            callbacks.onConstructionStarted(builder)
                        end

                    else
                        BuildingHelper:StartBuilding(builder)
                    end
                    return
                end
            end)
        end
    else
        -- Set the builder work to nil to accept next work directly
        BuildingHelper:print("Builder "..builder:GetUnitName().." "..builder:GetEntityIndex().." finished its building Queue")
        builder.state = "idle"
        builder.repair_target = nil
        builder.work = nil
    end
end

--[[
    ClearQueue
    * Clear the build queue, the player right clicked
]]--
function BuildingHelper:ClearQueue(builder)

    local work = builder.work
    builder.work = nil
    builder.state = "idle"

    BuildingHelper:StopGhost(builder)

    -- Clear movement
    if builder.move_to_build_timer then Timers:RemoveTimer(builder.move_to_build_timer) end

    -- Clear repair
    if builder.repair_target then
        local target = builder.repair_target
        local index = getIndexTable(target.units_repairing, builder)
        if index then
            table.remove(target.units_repairing, index)
            self:print("Builder stopped repairing, currently "..getTableCount(target.units_repairing).." left.")
        end
        builder.repair_target = nil
        self:OnRepairCancelled(builder, target)
    end

    local repair_ability = self:GetRepairAbility(builder)
    if repair_ability then
        if repair_ability:GetToggleState() then repair_ability:ToggleAbility() end
        builder:RemoveModifierByName("modifier_builder_repairing")
    end

    -- Skip if there's nothing to clear
    if not builder.buildingQueue or (not work and #builder.buildingQueue == 0) then
        return
    end

    BuildingHelper:print("ClearQueue "..builder:GetUnitName().." "..builder:GetEntityIndex())

    -- Main work  
    if work then
        BuildingHelper:ClearWorkParticles(work)
        if work.entity then BuildingHelper:RemoveEntity(work.entity.prop) end

        -- Only refund work that hasn't been placed yet
        if not work.inProgress and not work.repair then
            BuildingHelper:RemoveEntity(work.entity)
            work.refund = true
        end

        if work.name and work.callbacks and work.callbacks.onConstructionCancelled then
            work.callbacks.onConstructionCancelled(work)
        end
    end

    -- Queued work
    while #builder.buildingQueue > 0 do
        work = builder.buildingQueue[1]
        work.refund = true --Refund this
        BuildingHelper:ClearWorkParticles(work)
        if work.entity then
            BuildingHelper:RemoveEntity(work.entity.prop)
            BuildingHelper:RemoveEntity(work.entity)
        end
        table.remove(builder.buildingQueue, 1)

        if work.name and work.callbacks.onConstructionCancelled then
            work.callbacks.onConstructionCancelled(work)
        end
    end
end

-- Remove the entity if it was not marked as a bh dummy
function BuildingHelper:RemoveEntity(ent)
    if ent and not ent.BHDUMMY then
        UTIL_Remove(ent)
    end
end

function BuildingHelper:ClearWorkParticles(work)
    if work.particleIndex then 
        ParticleManager:DestroyParticle(work.particleIndex, true)
        ParticleManager:ReleaseParticleIndex(work.particleIndex)
    end
    if work.propParticleIndex then 
        ParticleManager:DestroyParticle(work.propParticleIndex, true)
        ParticleManager:ReleaseParticleIndex(work.propParticleIndex)
    end
end

--[[
    StopGhost
    * Stop panorama ghost
]]--
function BuildingHelper:StopGhost(builder)
    local player = builder:GetPlayerOwner()
    
    CustomGameEventManager:Send_ServerToPlayer(player, "building_helper_end", {})
end

--[[
    PrintQueue
    * Shows the current queued work for this builder
]]--
function BuildingHelper:PrintQueue(builder)
    BuildingHelper:print("Builder Queue of "..builder:GetUnitName().. " "..builder:GetEntityIndex())
    local buildingQueue = builder.buildingQueue
    for k,v in pairs(buildingQueue) do
        if buildingQueue[k]["location"] then
            BuildingHelper:print(" #"..k..": "..buildingQueue[k]["name"].." at "..VectorString(buildingQueue[k]["location"]))
        elseif buildingQueue[k]["building"] then
            BuildingHelper:print(" #"..k..": ".." repair "..buildingQueue[k]["name"])
        end
    end
    BuildingHelper:print("------------------------------------")
end

-- Toggles fast building/repairing cheat
function BuildingHelper:WarpTen(bEnabled)
    if bEnabled == nil then -- Toggle
        GameRules.WarpTen = not GameRules.WarpTen
    else
        GameRules.WarpTen = bEnabled
    end
end

function BuildingHelper:SnapToGrid(size, location)
    if size % 2 ~= 0 then
        location.x = BuildingHelper:SnapToGrid32(location.x)
        location.y = BuildingHelper:SnapToGrid32(location.y)
    else
        location.x = BuildingHelper:SnapToGrid64(location.x)
        location.y = BuildingHelper:SnapToGrid64(location.y)
    end
end

function BuildingHelper:SnapToGrid64(coord)
    return 64*math.floor(0.5+coord/64)
end

function BuildingHelper:SnapToGrid32(coord)
    return 32+64*math.floor(coord/64)
end

function BuildingHelper:print(...)
    if BuildingHelper.Settings["TESTING"] then
        print('[BH] '.. ...)
    end
end

function BuildingHelper:GetPlayerTable(playerID)
    if not BuildingHelper.Players[playerID] then
        BuildingHelper.Players[playerID] = {}
    end

    return BuildingHelper.Players[playerID]
end

-- Creates an out of world dummy at map origin and stores it, reducing load from creating units
function BuildingHelper:GetOrCreateDummy(unitName)
    if BuildingHelper.Dummies[unitName] then
        return BuildingHelper.Dummies[unitName]
    else
        BuildingHelper:print("AddBuilding "..unitName)
        local mgd = CreateUnitByName(unitName, Vector(0,0,0), false, nil, nil, 0)
        mgd:AddEffects(EF_NODRAW)
        mgd:AddNewModifier(mgd, nil, "modifier_out_of_world", {})
        BuildingHelper.Dummies[unitName] = mgd
        mgd.BHDUMMY = true -- Skip removing this entity
        return mgd
    end
end

function BuildingHelper:GetOrCreateProp(propName)
    if BuildingHelper.Dummies[propName] then
        return BuildingHelper.Dummies[propName]
    else
        local prop = SpawnEntityFromTableSynchronous("prop_dynamic", {model = propName})
        prop:AddEffects(EF_NODRAW)
        BuildingHelper.Dummies[propName] = prop
        prop.BHDUMMY = true -- Skip removing this entity
        return prop
    end
end

function BuildingHelper:CreatePedestalForBuilding(entity, buildingName, location, pedestalName)
    local offset = GetUnitKV(buildingName, "PedestalOffset") or 0
    local prop = SpawnEntityFromTableSynchronous("prop_dynamic", {model = pedestalName})
    local scale = GetUnitKV(buildingName, "PedestalModelScale") or entity:GetModelScale()
    local offset_location = Vector(location.x, location.y, location.z + offset)
    prop:SetModelScale(scale)
    prop:SetAbsOrigin(offset_location)
    entity.prop = prop -- Store the pedestal prop
    return prop
end

-- Retrieves the handle of the ability marked as "RepairAbility" on the unit key values
function BuildingHelper:GetRepairAbility(unit)
    local unitName = unit:GetUnitName()
    local abilityName = GetUnitKV(unitName, "RepairAbility")
    if abilityName then
        local ability = unit:FindAbilityByName(abilityName)
        if ability then
            return ability
        end
    end
end

function BuildingHelper:GetRepairSpeed(unit)
    local unitName = unit:GetUnitName()
    local repairSpeed = GetUnitKV(unitName,"RepairSpeed")
    if repairSpeed then
        return repairSpeed
    end
end

function BuildingHelper:IsFixedRepair(unit)
    local unitName = unit:GetUnitName()
    local isFixedRepair = GetUnitKV(unitName,"FixedRepair")
    if isFixedRepair then
        return isFixedRepair
    end
end

function BuildingHelper:GetConstructionSize(unit)
    local unitTable = (type(unit) == "table") and GetUnitKV(unit:GetUnitName()) or GetUnitKV(unit)
    return unitTable["ConstructionSize"]
end

function BuildingHelper:GetBlockPathingSize(unit)
    local unitTable = (type(unit) == "table") and GetUnitKV(unit:GetUnitName()) or GetUnitKV(unit)
    return unitTable["BlockPathingSize"]
end

function BuildingHelper:HideBuilder(unit, location, building)
    unit:AddNewModifier(unit, nil, "modifier_builder_hidden", {})
    unit.entrance_to_build = unit:GetAbsOrigin()

    local location_builder = Vector(location.x, location.y, location.z - 200)
    building.builder_inside = unit
    unit:AddNoDraw()

    Timers:CreateTimer(function()
        unit:SetAbsOrigin(location_builder)
    end)
end

function BuildingHelper:ShowBuilder(unit)
    unit:RemoveModifierByName("modifier_builder_hidden")
    FindClearSpaceForUnit(unit, unit.entrance_to_build, true)
    unit:RemoveNoDraw()
end

-- Find the closest position of construction_size, within maxDistance
function BuildingHelper:FindClosestEmptyPositionNearby(location, construction_size, maxDistance)
    local originX = GridNav:WorldToGridPosX(location.x)
    local originY = GridNav:WorldToGridPosY(location.y)

    local boundX1 = originX + math.floor(maxDistance/64)
    local boundX2 = originX - math.floor(maxDistance/64)
    local boundY1 = originY + math.floor(maxDistance/64)
    local boundY2 = originY - math.floor(maxDistance/64)

    local lowerBoundX = math.min(boundX1, boundX2)
    local upperBoundX = math.max(boundX1, boundX2)
    local lowerBoundY = math.min(boundY1, boundY2)
    local upperBoundY = math.max(boundY1, boundY2)

    -- Restrict to the map edges
    lowerBoundX = math.max(lowerBoundX, -BuildingHelper.squareX/2+1)
    upperBoundX = math.min(upperBoundX, BuildingHelper.squareX/2-1)
    lowerBoundY = math.max(lowerBoundY, -BuildingHelper.squareY/2+1)
    upperBoundY = math.min(upperBoundY, BuildingHelper.squareY/2-1)

    -- Adjust even size
    if (construction_size % 2) == 0 then
        upperBoundX = upperBoundX-1
        upperBoundY = upperBoundY-1
    end

    local towerPos = nil
    local closestDistance = maxDistance

    for x = lowerBoundX, upperBoundX do
        for y = lowerBoundY, upperBoundY do
            if BuildingHelper:CellHasGridType(x,y,"BUILDABLE") then
                local pos = GetGroundPosition(Vector(GridNav:GridPosToWorldCenterX(x), GridNav:GridPosToWorldCenterY(y), 0), nil)
                BuildingHelper:SnapToGrid(construction_size, pos)
                if BuildingHelper:MeetsHeightCondition(pos) and not BuildingHelper:IsAreaBlocked(construction_size, pos) then
                    local distance = (pos - location):Length2D()
                    if distance < closestDistance then
                        towerPos = pos
                        closestDistance = distance
                    end
                end
            end
        end
    end
    if towerPos then
        BuildingHelper:SnapToGrid(construction_size, towerPos)
    end
    return towerPos
end

-- Used to find if a position is insde the trigger entity bounds
function BuildingHelper:IsInsideEntityBounds(entity, location)
    local origin = entity:GetAbsOrigin()
    local bounds = entity:GetBounds()
    local min = bounds.Mins
    local max = bounds.Maxs
    local X = location.x
    local Y = location.y
    local minX = min.x + origin.x
    local minY = min.y + origin.y
    local maxX = max.x + origin.x
    local maxY = max.y + origin.y
    local betweenX = X >= minX and X <= maxX
    local betweenY = Y >= minY and Y <= maxY

    return betweenX and betweenY
end

function BuildingHelper:IsInsideEntityConstructionArea(entity, location)
    local origin = entity:GetAbsOrigin()
    local constructionSize = GetUnitKV(entity:GetUnitName(), "ConstructionSize")
    if constructionSize == nil then
        return false
    else 
    end
    local X = location.x
    local Y = location.y
    local minX = origin.x - (constructionSize/2*64)
    local minY = origin.y - (constructionSize/2*64)
    local maxX = origin.x + (constructionSize/2*64)
    local maxY = origin.y + (constructionSize/2*64)
    local betweenX = X >= minX and X <= maxX
    local betweenY = Y >= minY and Y <= maxY

    return betweenX and betweenY
end

-- In case a height restriction was defined, checks if the location passes the height test
function BuildingHelper:MeetsHeightCondition(location)
    if BuildingHelper.Settings["HEIGHT_RESTRICTION"] and BuildingHelper.Settings["HEIGHT_RESTRICTION"] ~= "" then
        return location.z >= BuildingHelper.Settings["HEIGHT_RESTRICTION"]
    else
        return true
    end
end

-- A BuildingHelper ability is identified by the "Building" key.
function IsBuildingAbility(ability)
    if not IsValidEntity(ability) then
        return
    end

    local ability_name = ability:GetAbilityName()
    return GetKeyValue(ability_name, "Building")
end

-- Builders are stored in a nettable in addition to the builder label
function IsBuilder(unit)
    local table = CustomNetTables:GetTableValue("builders", tostring(unit:GetEntityIndex()))
    return unit:GetUnitLabel() == "builder" or (table and (table["IsBuilder"] == 1)) or unit:HasAbility("repair") or false
end

function CDOTA_BaseNPC:GetFollowRange(target)
    return self:GetHullRadius() + target:GetHullRadius() + 100
end

function IsLumberHarvester(unit)
    return unit:HasAbility("gather_lumber_8") or unit:HasAbility("gather_lumber_4") or unit:HasAbility("gather_lumber_2") or unit:HasAbility("gather_lumber_1")
end

function IsCustomBuilding(unit)
    return unit:HasModifier("modifier_building")
end

function BuildingHelper:AddModifierBuilding(building)
    local magicImmune = BuildingHelper.Settings["MAGIC_IMMUNE_BUILDINGS"]
    local deniable = BuildingHelper.Settings["DENIABLE_BUILDINGS"]
    local disableTurning = GetUnitKV(name, "DisableTurning") == 1 or BuildingHelper.Settings["DISABLE_BUILDING_TURNING"]
    building:AddNewModifier(building, nil, "modifier_building", {disable_turning = disableTurning, magic_immune = magicImmune, deniable = deniable})
end

function PrintGridCoords(pos)
    print('('..string.format("%.1f", pos.x)..','..string.format("%.1f", pos.y)..') = ['.. GridNav:WorldToGridPosX(pos.x)..','..GridNav:WorldToGridPosY(pos.y)..']')
end

function VectorString(v)
    return '[' .. math.floor(v.x) .. ', ' .. math.floor(v.y) .. ', ' .. math.floor(v.z) .. ']'
end

function StringStartsWith(fullstring, substring)
    local strlen = string.len(substring)
    local first_characters = string.sub(fullstring, 1 , strlen)
    return (first_characters == substring)
end

function tobool(s)
    return s==true or s=="true" or s=="1" or s==1
end

function split(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
end

function getTableCount(t)
    local n = 0
    for _ in pairs( t ) do
        n = n + 1
    end
    return n
end

function getIndexTable(list, element)
    if list == nil then return false end
    for k,v in pairs(list) do if v == element then return k end end
end

function DrawGridSquare(x, y, color)
    local pos = Vector(GridNav:GridPosToWorldCenterX(x), GridNav:GridPosToWorldCenterY(y), 0)
    BuildingHelper:SnapToGrid(1, pos)
    pos = GetGroundPosition(pos, nil)
        
    local particle = ParticleManager:CreateParticle("particles/buildinghelper/square_overlay.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, pos)
    ParticleManager:SetParticleControl(particle, 1, Vector(32,0,0))
    ParticleManager:SetParticleControl(particle, 2, color)
    ParticleManager:SetParticleControl(particle, 3, Vector(90,0,0))

    Timers:CreateTimer(0.5, function() 
        ParticleManager:DestroyParticle(particle, true)
        ParticleManager:ReleaseParticleIndex(particle)

    end)
end

if not BuildingHelper.Players then BuildingHelper:Init() end