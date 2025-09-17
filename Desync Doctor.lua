-- DeSync Doctor Script™ Copyright© 2025

--[[] -- Coded By Candy
WE HAVE TAKEN OVER░ \☻/\☻/
░░░░░░░░░░░░░░░░░░░▌░ ▌
░░░░░░░░░░░░░░░░░░ / \░ / \
░░░░░░░░░░░░░░░░░███████ ]▄▄▄▄▄▄▄▄▄-----------●
░░░░░░░░░░░░▂▄▅█████████▅▄▃▂
░░░░░░░░░░░I███████████████████].
]]

util.keep_running()
util.require_no_lag("natives-1663599433")

local DeSync_Doctor_Root = menu.my_root()
local MOD_TAG = "[DeSync Doctor] "

local function my_ped() return players.user_ped() end
local function my_vehicle(ped)
    ped = ped or my_ped()
    if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
        return PED.GET_VEHICLE_PED_IS_IN(ped, false)
    end
    return 0
end

local function request_control(ent, timeout_ms)
    if ent == 0 or not ENTITY.DOES_ENTITY_EXIST(ent) then return false end
    if NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(ent) then return true end
    local deadline = util.current_time_millis() + (timeout_ms or 750)
    while util.current_time_millis() < deadline do
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ent)
        if NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(ent) then return true end
        util.yield_once()
    end
    return NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(ent)
end

local function nudge_entity(ent, up_only)
    if ent == 0 or not ENTITY.DOES_ENTITY_EXIST(ent) then return end
    if not request_control(ent, 600) then return false end
    local coords = ENTITY.GET_ENTITY_COORDS(ent, false)
    local dz = up_only and 0.15 or 0.03
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(ent, coords.x + 0.03, coords.y - 0.03, coords.z + dz, false, false, true)
    util.yield(60)
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(ent, coords.x, coords.y, coords.z, false, false, true)
    return true
end

local function snap_ped_to_ground(ped)
    ped = ped or my_ped()
    if ped == 0 then return false end
    request_control(ped, 450)
    local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
    local success, gz = util.get_ground_z(pos.x, pos.y, pos.z)
    if success then
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(ped, pos.x, pos.y, gz + 0.05, false, false, true)
    end
    PED.RESET_PED_RAGDOLL_TIMER(ped)
    TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
    return true
end

local function stabilise_vehicle(veh)
    if veh == 0 or not ENTITY.DOES_ENTITY_EXIST(veh) then return false end
    if not request_control(veh, 900) then return false end
    ENTITY.SET_ENTITY_VELOCITY(veh, 0,0,0)
    VEHICLE.SET_VEHICLE_FIXED(veh)
    VEHICLE.SET_VEHICLE_ENGINE_ON(veh, true, true, true)
    VEHICLE.SET_VEHICLE_ON_GROUND_PROPERLY(veh)
    ENTITY.FREEZE_ENTITY_POSITION(veh, true)
    util.yield(90)
    ENTITY.FREEZE_ENTITY_POSITION(veh, false)
    nudge_entity(veh, true)
    return true
end

local function reseat_driver()
    local ped = my_ped()
    local veh = my_vehicle(ped)
    if veh == 0 then return log("Not in a vehicle.") end
    if not request_control(veh, 900) then return log("Couldn't control vehicle.") end
    TASK.TASK_WARP_PED_INTO_VEHICLE(ped, veh, -1)
end

local function one_shot_resync()
    local ped = my_ped()
    if ped == 0 then return end
    request_control(ped, 500)
    ENTITY.FREEZE_ENTITY_POSITION(ped, true)
    util.yield(120)
    ENTITY.FREEZE_ENTITY_POSITION(ped, false)
    nudge_entity(ped, true)
    snap_ped_to_ground(ped)
end

local function respawn_here(invuln_ms)
    local ped = my_ped()
    if ped == 0 then return end
    local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
    local heading = ENTITY.GET_ENTITY_HEADING(ped)
    NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(
        pos.x, pos.y, pos.z,
        heading,
        invuln_ms or 1000,
        false,  -- unk1
        false,  -- unk2
        0,      -- unk3
        0       -- unk4
    )
    snap_ped_to_ground(ped)
end

local function safe_resync()
    local ped = my_ped()
    if ped == 0 then return end
    ENTITY.FREEZE_ENTITY_POSITION(ped, true)
    util.yield(150)
    ENTITY.FREEZE_ENTITY_POSITION(ped, false)
    snap_ped_to_ground(ped)
    nudge_entity(ped)
    local veh = my_vehicle(ped)
    if veh ~= 0 then stabilise_vehicle(veh) end
end

local whitelist, blacklist = {}, {}
local function is_allowed(pid)
    if blacklist[pid] then return false end
    if next(whitelist) ~= nil then return whitelist[pid] ~= nil end
    return true
end

local ping_cfg = {enabled=false, radius=60.0, interval=2500}
local sweep_cfg = {enabled=false, radius=60.0, interval=3000}
local stuck_cfg = {enabled=false, min_height=6.0, vel_threshold=0.2, interval=900, last=0}
local parachute_cfg = {enabled=false, max_height=120.0}

util.create_tick_handler(function()
    if stuck_cfg.enabled then
        local now = util.current_time_millis()
        if now - stuck_cfg.last >= stuck_cfg.interval then
            stuck_cfg.last = now
            local ped = my_ped()
            if ped ~= 0 and ENTITY.GET_ENTITY_HEIGHT_ABOVE_GROUND(ped) > stuck_cfg.min_height then
                local vel = ENTITY.GET_ENTITY_VELOCITY(ped)
                if math.abs(vel.z) < stuck_cfg.vel_threshold then
                    snap_ped_to_ground(ped)
                end
            end
        end
    end
    return true
end)

util.create_tick_handler(function()
    if parachute_cfg.enabled then
        local ped = my_ped()
        if ped ~= 0 then
            local above = ENTITY.GET_ENTITY_HEIGHT_ABOVE_GROUND(ped)
            if above > 0 and above < parachute_cfg.max_height then
                if PED.IS_PED_FALLING(ped) or PED.IS_PED_IN_PARACHUTE_FREE_FALL(ped) then
                    if above <= 10.0 then snap_ped_to_ground(ped) log("Parachute snap.") end
                end
            end
        end
    end
    return true
end)

local last_ping, last_sweep = 0,0
util.create_tick_handler(function()
    local now = util.current_time_millis()
    if ping_cfg.enabled and now - last_ping >= ping_cfg.interval then
        last_ping = now
        for _, pid in ipairs(players.list(true,true)) do
            if is_allowed(pid) then
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
                if veh ~= 0 and request_control(veh, 200) then nudge_entity(veh, true) end
            end
        end
    end
    if sweep_cfg.enabled and now - last_sweep >= sweep_cfg.interval then
        last_sweep = now
        for _, v in ipairs(entities.get_all_vehicles_as_handles()) do NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(v) end
    end
    return true
end)

menu.action(DeSync_Doctor_Root, "One-shot Resync", {}, "", one_shot_resync)
menu.action(DeSync_Doctor_Root, "Safe Resync Profile", {}, "Freeze+Snap+Nudge+VehStabilise", safe_resync)
menu.action(DeSync_Doctor_Root, "Respawn Here", {}, "", function() respawn_here(1200) end)
menu.action(DeSync_Doctor_Root, "Re-seat Driver", {}, "", reseat_driver)
menu.action(DeSync_Doctor_Root, "Snap to Ground", {}, "", snap_ped_to_ground)

menu.toggle(DeSync_Doctor_Root, "Stuck Mid-Air Fix", {}, "", function(s) stuck_cfg.enabled = s end)
menu.toggle(DeSync_Doctor_Root, "Parachute Snap", {}, "", function(s) parachute_cfg.enabled = s end)
menu.toggle(DeSync_Doctor_Root, "Vehicle Pings", {}, "", function(s) ping_cfg.enabled = s end)
menu.slider(DeSync_Doctor_Root, "Ping Radius", {}, "", 10,200,ping_cfg.radius,5,function(v) ping_cfg.radius=v end)
menu.slider(DeSync_Doctor_Root, "Ping Interval", {}, "", 500,10000,ping_cfg.interval,100,function(v) ping_cfg.interval=v end)
menu.toggle(DeSync_Doctor_Root, "Keepalive Sweep", {}, "", function(s) sweep_cfg.enabled = s end)

local wl = menu.list(DeSync_Doctor_Root, "Whitelist", {""}, "For pings.")
local bl = menu.list(DeSync_Doctor_Root, "Blacklist", {""}, "For pings.")
for _, pid in ipairs(players.list(true,true)) do
    local name = players.get_name(pid)
    wl:toggle(name, {}, "", function(state) whitelist[pid] = state or nil end, whitelist[pid]~=nil)
    bl:toggle(name, {}, "", function(state) blacklist[pid] = state or nil end, blacklist[pid]~=nil)
end