-- Addict Menu™ Copyright© 2026

--[[] -- Coded By James 🕷
____________$_______________$___________
__________$$_________________$$_________
_________$$___________________$$________
________$$_____________________$$_______
________$$_____________________$$_______
________$$_____________________$$_______
_________$$___________________$$________
_____$$__$$___________________$$__$$____
____$$___$$___________________$$___$$___
___$$_____$$_________________$$_____$$__
___$_______$$$_____________$$$_______$__
___$$_______$$$___________$$$_______$$__
___$$$_______$$$__$$$$$__$$$_______$$$__
____$$$$$$____$$$$$$$$$$$$$___$$$$$$$___
_________$$$$$$$$$$$$$$$$$$$$$$_________
____$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$____
___$$$_$$$$$$$$$$$$$$$$$$$$$$$$$$_$$$___
__$$$_________$$$$$$$$$$$$_________$$$__
_$$_________$$$$$$$$$$$$$$$$$________$$_
_$$_____$$$$$$$$$$$$$$$$$$$$$$$$_____$$_
$$_____$$$__$$$$$$$$$$$$$$$$__$$$_____$$
_$$____$$___$$$$$$$__$$$$$$$___$$____$$_
__$____$$___$$$$$$$__$$$$$$$___$$____$__
___$___$$___$$$$$$$$$$$$$$$$___$$___$___
____$__$$____$$$$$$$$$$$$$$____$$__$____
_______$$_____$$$$$$$$$$$$_____$$_______
_______$$_______$$$$$$$$_______$$_______
________$$____________________$$________
]]

-- Credits 🧐🔽🔽🔽
local Credits_To = {
    "Fivesense",
    "Tencerr",
    "Lumia",
}
-- Credits 🧐🔼🔼🔼

Citizen.CreateThread(function()
    while true do
        reportEvent = nil
        reportEvent2 = nil
        Citizen.Wait(500)
    end
end)

local my_version = "V0.1"
local CONTROL_OPEN_DEFAULT = 178  -- DELETE Key

local control_names = {
    [288] = "F1",
    [289] = "F2",
    [290] = "F3",
    [291] = "F4",
    [292] = "F5",
    [293] = "F6",
    [294] = "F7",
    [295] = "F8",
    [296] = "F9",
    [297] = "F10",
    [298] = "F11",
    [299] = "F12",
    [200] = "ESC",
    [37] = "TAB",
    [191] = "ENTER",
    [177] = "BACKSPACE",
    [178] = "DELETE",
    [212] = "HOME",
    [213] = "END",
    [244] = "M",
    [249] = "N",
    [121] = "INSERT",
    -- Add more as needed
}

local function control_name(control)
    return control_names[control] or ("Control " .. control)
end

local function notify_push(title, msg, opts)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(title .. "~n~" .. msg)
    DrawNotification(false, false)
end

-- Config saved locally via FiveM KVP (persists between sessions, no server needed)
-- save_config and load_config are defined after cfg_snapshot/apply_loaded below

local cfg = {
    open_key = CONTROL_OPEN_DEFAULT,
    overlay_enabled = true,

    window = {
        x = 636.0, y = 60.0,
        w = 920.0, h = 460.0,
        rounding = 10.0,
    },

    particles = {
        enabled = true,
        count = 60,
        speed = 55.0,
        connect = false,  -- Disabled because lines are hard to draw without rotation
        connect_dist = 120.0,
    },

    theme = {
        text =      { r=255, g=255, b=255, a=220 },
        background = { r=15,  g=15,  b=15,  a=210 },
        header =    { r=25,  g=25,  b=25,  a=235 },
        particles = { r=255, g=255, b=255, a=120 },
    },

    -- Font index used by get_text_width and draw_text (0-8)
    -- 0=Default  1=Subtitle  2=Menu  4=WastedTitle  5=Pricedown  7=LemonMilk
    font = 7,
    scroll_speed = 10.0,
}

local state = {
    open = false,
    inPlayerList = false,

    dragging = false,
    drag_off_x = 0.0,
    drag_off_y = 0.0,

    active_tab = 1,
    tabs = { "Self", "Players", "Vehicle", "Weapon", "Misc", "World", "Settings" },

    last_tick = 0,
    particles = {},

    ui = {
        active_slider = nil,
        settings_scroll = 0.0,
        settings_content_h = 0.0,
        settings_dragging = false,
        settings_drag_last_y = 0.0,
        scrollbar_dragging = false,
        scrollbar_drag_offset = 0.0,
        player_sb_dragging = false,
        player_sb_offset = 0.0,
        vehicle_scroll = 0.0,
        vehicle_sb_dragging = false,
        vehicle_sb_offset = 0.0,
        vsel_scroll = 0.0,
        vsel_sb_dragging = false,
        vsel_sb_offset = 0.0,
        wheel_accum = 0.0,
        binding_open_key = false,
        bind_flash_t = 0.0,
        prev_control_down = {},
        settings_area = { x=0.0, y=0.0, w=0.0, h=0.0 },
        player_scroll = 0.0,
    },

    sel = 1,
    scroll = 0
}

local Menu = {
    ["Self"] = {
        "Freecam",
        "Radial Menu",
        "Godmode","No Ragdoll","No Criticals","Invisibility",
        "Super Run","Super Jump","Super Strength","Infinite Stamina","Noclip",
        "Teleport To Waypoint","Teleport To Coords",
        "Heal & Armour","Wanted Level 0","Wanted Level 5","Refill Ammo",
    },
    ["Players"] = {
        "Teleport To Player (on selected)","Spectate Player (toggle) (on selected)",
        "Cage Selected Player (on selected)",
        "Pull All Peds (to selected)","Pull All Vehicles (to selected)","Pull All Props (to selected)","HELL MODE (on selected)",
        "Vortex Player (on selected)","Franklin Swarm (on selected)","Trip Player (on selected)","Crash Player (on selected)","Spawn Cargoplane (on selected)","Spawn Rumpo2 (on selected)","Spawn Cerberus (on selected)","Spawn Dump (on selected)","Spawn Adder (on selected)","Vehicle Rain (on selected)",
    },
    ["Vehicle"] = {
        "Repair Vehicle","Flip Vehicle","Vehicle Godmode (toggle)",
        "Boost Vehicle","Max Speed","Clean Vehicle",
        "Lock Vehicle","Unlock Vehicle",
        "Teleport All Vehicles",
        "Delete Current Vehicle",
        "Loop Vehicle (toggle)",
        "Open/Close Hood",
        "Steal Engine",
        "Steal All 4 Tyres",
        "Steal All 4 Wheels",
        "Drop Parts",
        "Delete Broken Parts",
    },
    ["VehicleSelected"] = {
        "Teleport Into Selected",
        "Teleport Vehicle To Me",
        "Repair Selected",
        "Flip Selected",
        "Godmode Selected",
        "Max Speed Selected",
        "Boost Selected",
        "Clean Selected",
        "Pop Tyres",
        "Remove Wheels",
        "Explode Selected",
        "Delete Selected",
    },
    ["Weapon"] = {
        "Give All Weapons","Unlimited Ammo (toggle)","Refill Ammo",
        "Remove All Weapons","Explosive Bullets (toggle)","Fire Bullets (toggle)",
    },
    ["Misc"] = {
        "Player Blips (toggle)","No Rain (toggle)","Always Bright (toggle)",
        "Rainbow Menu (toggle)",
        "Clear Area Peds","Clear Area Vehicles",
        "Time: Midnight","Time: Noon",
        "Weather: Clear","Weather: Thunder","Low Gravity (toggle)",
        "Meteor Shower","Lightning Storm","Force Field",
        "Teleport","Time Warp","Random Weapon Drop","Heal Player",
        "Give Weapon","Spawn Animal","Weather Cycle","Change Time",
        "Explode Nearby Vehicles","Pull All Animals","Explosion Loop",
        "Low Gravity (WG)","Chaos Physics","Flying Cars",
        "Random Vehicle Spawn","Dimension Shift",
        "Super Speed","Night Vision","Thermal Vision",
        "Tornado","Hurricane","Vehicle Teleport","Vehicle Spawn Wave",
        "Ped Teleport","Ped Spawn Wave",
        "New Vehicle 2",
        "Random Ped Spawn","Ultra Fast Ped Spawn","Mega Ped Spawn",
        "Random Explosions","Firework Loop",
        "Mass Ped Knockup","Sticky Bomb Rain","Confetti Rain","Laser Show",
        "Clone Me","Clone Army","Freeze Peds (toggle)","Launch Peds","Ragdoll Loop (toggle)",
    },
    ["World"] = {
        "Random Teleport",
        "Entity Throttler (toggle)",
        "Clear Area",
        "Freeze Time (toggle)","Slow Motion (toggle)","Clear Weather",
        "Storm Weather","Low Gravity (WC)","Earthquake (toggle)",
        "Tornado (WC)","Hurricane (WC)","Weather Cycle (toggle)","Change Time (toggle)",
        "Ped Markers (toggle)","Vehicle Markers (toggle)",
        "Distance Text (toggle)","Snap Lines (toggle)",
        "Radius +","Radius -","Clear Visuals",
        "ESP (toggle)",
    },
    ["Player List"] = {},
}

local feat = {
    godmode=false, noragdoll=false, nocriticals=false,
    invisible=false, superrun=false, superjump=false,
    stamina=false, vehgod=false,
    playerblips=false, norain=false, alwaysbright=false,
    esp=false, rainbow=false, spectate=false,
    vortex = false,
    freecam = false,
    radialMenu = false,
    entityThrottler = false,
    franklinSwarm = false,
}

local freecam = {
    mode = 1,
    modes = {
        "Teleport",
        "Fast and Furious",
        "Vehicle Spawner",
        "Entity Deleter",
        "Particle Spawner",
        "Ped Spawner",
        "Animal Spawner",
        "Prop Spawner",
        "Map Fucker",
        "Tree Spawner",
        "Look Around",
        "Freeze Entity",
        "Terrorist Attack",
        "CrashHim",
        "Trip Player",
    },
}
local freecam_cam = nil
local freecam_ready = false

-- Radial menu state
local radialMenu_open    = false
local radialMenu_hovered = 0
local radialMenu_target  = nil
local radialMenu_frozen  = {}  -- tracks frozen entity handles for toggle
local radialMenu_openRot = nil -- camera rotation snapshot when menu opened
local radialKey_held     = false  -- set by G key RegisterKeyMapping

local clearArea_radius = 500.0   -- max distance, always clears everything in range

-- ── Universal network-control helper ─────────────────────────────────────────
-- Requests ownership of any networked entity and waits up to `timeout` frames.
-- Returns true if we have control (or entity is local-only), false on timeout.
local function net_ctrl(ent, timeout)
    if not DoesEntityExist(ent) then return false end
    if not NetworkGetEntityIsNetworked(ent) then return true end
    NetworkRequestControlOfEntity(ent)
    local t = 0; timeout = timeout or 40
    while not NetworkHasControlOfEntity(ent) and t < timeout do
        Citizen.Wait(0); t = t + 1
    end
    return NetworkHasControlOfEntity(ent)
end

local radial_slices = {
    -- Slice 1: TOP        — Steal Vehicle
    { label = "Steal Vehicle",  color = {r=50,  g=140, b=255} },
    -- Slice 2: TOP-RIGHT  — Launch Up
    { label = "Launch Up",      color = {r=255, g=200, b=40}  },
    -- Slice 3: BOT-RIGHT  — Explode
    { label = "Explode",        color = {r=255, g=60,  b=40}  },
    -- Slice 4: BOTTOM     — Freeze Entity
    { label = "Freeze Entity",  color = {r=40,  g=200, b=220} },
    -- Slice 5: BOT-LEFT   — Delete Entity
    { label = "Delete Entity", color = {r=180, g=60,  b=255} },
    -- Slice 6: TOP-LEFT   — Ragdoll
    { label = "Ragdoll",        color = {r=255, g=120, b=40}  },
}

local vortex_target = nil
local noclipActive = false
local noclip_ready = false
local lowgrav = false
local unlimitedAmmo = false
local bulletFlags = {explosive=false, fire=false}
local selPlayer = nil
local selVehicle = nil
local selAllPlayers = false  -- when true, one-shot actions apply to every player
local loopVehSpawn = false
local Chaos = {meteors=false,hell=false,lightning=false,forcefield=false,
                 timewarp=false,explosionloop=false,dimensionshift=false}
local Visuals = {peds=false,vehicles=false,text=false,lines=false,radius=60.0,
                 nightvision=false,thermalvision=false}
local Powers = {stamina=false,superjump=false,fastrun=false,noragdoll=false,
                 god=false,invis=false,superstrength=false,superspeed=false}
local World = {freeze=false,slowmo=false,lowgrav=false,earthquake=false,
                 tornado=false,hurricane=false,weathercycle=false,changetime=false}
local PedCtrl = {freeze=false,ragdoll=false}
local spectateCam = nil
local specPos = nil
local specRot = nil
local specDistance = 5.0

local blipMap = {}

local function GetToggle(label)
    local map = {
        ["Godmode"] = function() return feat.godmode end,
        ["No Ragdoll"] = function() return feat.noragdoll end,
        ["No Criticals"] = function() return feat.nocriticals end,
        ["Invisibility"] = function() return feat.invisible end,
        ["Super Run"] = function() return feat.superrun end,
        ["Super Jump"] = function() return feat.superjump end,
        ["Infinite Stamina"] = function() return feat.stamina end,
        ["Noclip"] = function() return noclipActive end,
        ["Vehicle Godmode (toggle)"] = function() return feat.vehgod end,
        ["Player Blips (toggle)"] = function() return feat.playerblips end,
        ["No Rain (toggle)"] = function() return feat.norain end,
        ["Always Bright (toggle)"] = function() return feat.alwaysbright end,
        ["ESP (toggle)"] = function() return feat.esp end,
        ["Entity Throttler (toggle)"] = function() return feat.entityThrottler end,
        ["Rainbow Menu (toggle)"] = function() return feat.rainbow end,
        ["Explosive Bullets (toggle)"] = function() return bulletFlags.explosive end,
        ["Fire Bullets (toggle)"] = function() return bulletFlags.fire end,
        ["Unlimited Ammo (toggle)"] = function() return unlimitedAmmo end,
        ["Low Gravity (toggle)"] = function() return lowgrav end,
        ["Loop Vehicle (toggle)"] = function() return loopVehSpawn end,
        ["Meteor Shower"] = function() return Chaos.meteors end,
        ["Lightning Storm"] = function() return Chaos.lightning end,
        ["Force Field"] = function() return Chaos.forcefield end,
        ["Time Warp"] = function() return Chaos.timewarp end,
        ["Explosion Loop"] = function() return Chaos.explosionloop end,
        ["Dimension Shift"] = function() return Chaos.dimensionshift end,
        ["Weather Cycle"] = function() return World.weathercycle end,
        ["Change Time"] = function() return World.changetime end,
        ["Ped Markers (toggle)"] = function() return Visuals.peds end,
        ["Vehicle Markers (toggle)"] = function() return Visuals.vehicles end,
        ["Distance Text (toggle)"] = function() return Visuals.text end,
        ["Snap Lines (toggle)"] = function() return Visuals.lines end,
        ["Freeze Time (toggle)"] = function() return World.freeze end,
        ["Slow Motion (toggle)"] = function() return World.slowmo end,
        ["Low Gravity (WC)"] = function() return World.lowgrav end,
        ["Earthquake (toggle)"] = function() return World.earthquake end,
        ["Tornado (WC)"] = function() return World.tornado end,
        ["Hurricane (WC)"] = function() return World.hurricane end,
        ["Weather Cycle (toggle)"] = function() return World.weathercycle end,
        ["Change Time (toggle)"] = function() return World.changetime end,
        ["Freeze Peds (toggle)"] = function() return PedCtrl.freeze end,
        ["Ragdoll Loop (toggle)"] = function() return PedCtrl.ragdoll end,
        ["Night Vision"] = function() return Visuals.nightvision end,
        ["Thermal Vision"] = function() return Visuals.thermalvision end,
        ["Low Gravity (WG)"] = function() return World.lowgrav end,
        ["Super Strength"] = function() return Powers.superstrength end,
        ["Super Speed"] = function() return Powers.superspeed end,
        ["Tornado"] = function() return World.tornado end,
        ["Hurricane"] = function() return World.hurricane end,
        ["Spectate Player (toggle)"] = function() return feat.spectate end,
        ["Vortex Player (on selected)"] = function() return feat.vortex end,
        ["Franklin Swarm (on selected)"]   = function() return feat.franklinSwarm end,
        ["Freecam"] = function() return feat.freecam end,
        ["Radial Menu"] = function() return feat.radialMenu end,
    }
    local fn = map[label]
    return fn and fn() or nil
end

local function clamp(n, a, b)
    if n < a then return a end
    if n > b then return b end
    return n
end

local function to_int255(v)
    return clamp(math.floor((v or 0) + 0.5), 0, 255)
end

-- Forward declarations so cfg_snapshot/apply_loaded are visible everywhere
local cfg_snapshot
local apply_loaded

cfg_snapshot = function()
    return {
        open_key = cfg.open_key,
        overlay_enabled = cfg.overlay_enabled,

        window = {
            x = cfg.window.x, y = cfg.window.y,
            w = cfg.window.w, h = cfg.window.h,
            rounding = 10.0,  -- Ignored in FiveM
        },

        particles = {
            enabled = cfg.particles.enabled,
            count = cfg.particles.count,
            speed = cfg.particles.speed,
            connect = cfg.particles.connect,
            connect_dist = cfg.particles.connect_dist,
        },

        theme = {
            text =      { r=cfg.theme.text.r, g=cfg.theme.text.g, b=cfg.theme.text.b, a=cfg.theme.text.a },
            background = { r=cfg.theme.background.r, g=cfg.theme.background.g, b=cfg.theme.background.b, a=cfg.theme.background.a },
            header =    { r=cfg.theme.header.r, g=cfg.theme.header.g, b=cfg.theme.header.b, a=cfg.theme.header.a },
            particles = { r=cfg.theme.particles.r, g=cfg.theme.particles.g, b=cfg.theme.particles.b, a=cfg.theme.particles.a },
        },
        font = cfg.font,
    }
end

apply_loaded = function(tbl)
    if type(tbl) ~= "table" then return false end

    if type(tbl.open_key) == "number" then cfg.open_key = clamp(math.floor(tbl.open_key + 0.5), 0, 359) end

    if type(tbl.window) == "table" then
        if type(tbl.window.x) == "number" then cfg.window.x = tbl.window.x end
        if type(tbl.window.y) == "number" then cfg.window.y = tbl.window.y end
        if type(tbl.window.w) == "number" then cfg.window.w = tbl.window.w end
        if type(tbl.window.h) == "number" then cfg.window.h = tbl.window.h end
        if type(tbl.window.rounding) == "number" then cfg.window.rounding = tbl.window.rounding end
    end

    if type(tbl.particles) == "table" then
        if type(tbl.particles.enabled) == "boolean" then cfg.particles.enabled = tbl.particles.enabled end
        if type(tbl.particles.count) == "number" then cfg.particles.count = tbl.particles.count end
        if type(tbl.particles.speed) == "number" then cfg.particles.speed = tbl.particles.speed end
        if type(tbl.particles.connect) == "boolean" then cfg.particles.connect = tbl.particles.connect end
        if type(tbl.particles.connect_dist) == "number" then cfg.particles.connect_dist = tbl.particles.connect_dist end
    end

    if type(tbl.font) == "number" then cfg.font = clamp(math.floor(tbl.font + 0.5), 0, 8) end

    if type(tbl.theme) == "table" then
        local function apply_rgba(dst, src)
            if type(src) ~= "table" then return end
            if type(src.r) == "number" then dst.r = clamp(math.floor(src.r + 0.5), 0, 255) end
            if type(src.g) == "number" then dst.g = clamp(math.floor(src.g + 0.5), 0, 255) end
            if type(src.b) == "number" then dst.b = clamp(math.floor(src.b + 0.5), 0, 255) end
            if type(src.a) == "number" then dst.a = clamp(math.floor(src.a + 0.5), 0, 255) end
        end
        apply_rgba(cfg.theme.text, tbl.theme.text)
        apply_rgba(cfg.theme.background, tbl.theme.background)
        apply_rgba(cfg.theme.header, tbl.theme.header)
        apply_rgba(cfg.theme.particles, tbl.theme.particles)
    end

    return true
end

-- Config saved locally via FiveM KVP (persists between sessions, no server needed)
local function save_config()
    local payload = json.encode(cfg_snapshot())
    SetResourceKvp("Addict_config", payload)
    notify_push("Addict", "~p~Config saved")
    return true
end

local function load_config()
    local data = GetResourceKvpString("Addict_config")
    if not data or #data == 0 then
        notify_push("Addict", "~r~No saved config found")
        return false
    end
    local tbl = json.decode(data)
    if not tbl then
        notify_push("Addict", "~r~Config invalid")
        return false
    end
    if apply_loaded(tbl) then
        notify_push("Addict", "~p~Config loaded")
        return true
    end
    notify_push("Addict", "~r~Config failed to apply")
    return false
end

local function reset_particles()
    state.particles = {}
    local count = clamp(cfg.particles.count, 0, 200)

    for i = 1, count do
        state.particles[i] = {
            x = GetRandomFloatInRange(cfg.window.x, cfg.window.x + cfg.window.w),
            y = GetRandomFloatInRange(cfg.window.y, cfg.window.y + cfg.window.h),
            vx = GetRandomFloatInRange(-1.0, 1.0),
            vy = GetRandomFloatInRange(-1.0, 1.0),
            r = GetRandomFloatInRange(1.2, 2.6),
        }
    end
end

local function key_just_pressed(control)
    return IsControlJustPressed(0, control)
end

local function hit(posx, posy, w, h, m_x, m_y)
    return m_x > posx and m_x < posx + w and m_y > posy and m_y < posy + h
end

local function draw_rect(x, y, w, h, col, screen_w, screen_h)
    local center_x = (x + w / 2) / screen_w
    local center_y = (y + h / 2) / screen_h
    local fw = w / screen_w
    local fh = h / screen_h
    DrawRect(center_x, center_y, fw, fh, to_int255(col.r), to_int255(col.g), to_int255(col.b), to_int255(col.a))
end

local function draw_circle(x, y, r, col, screen_w, screen_h)
    -- Approximate with square
    draw_rect(x - r, y - r, r * 2, r * 2, col, screen_w, screen_h)
end

local function get_text_width(str, scale, screen_w)
    SetTextFont(cfg.font)
    SetTextScale(scale * 0.3, scale * 0.3)
    BeginTextCommandGetWidth("STRING")
    AddTextComponentString(str)
    return EndTextCommandGetWidth(true) * screen_w
end

local function draw_text(str, x, y, scale, col, screen_w, screen_h, clip_min_y, clip_max_y)
    if clip_min_y and clip_max_y then
        if y < clip_min_y or y > clip_max_y then return end
    end
    SetTextFont(cfg.font)
    SetTextScale(scale * 0.3, scale * 0.3)  -- Adjust scale as needed
    SetTextColour(to_int255(col.r), to_int255(col.g), to_int255(col.b), to_int255(col.a))
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(str)
    EndTextCommandDisplayText(x / screen_w, y / screen_h)
end

local function draw_text_right(str, x, y, w, scale, col, screen_w, screen_h, clip_min_y, clip_max_y)
    if clip_min_y and clip_max_y then
        if y < clip_min_y or y > clip_max_y then return end
    end
    SetTextFont(cfg.font)
    SetTextScale(scale * 0.3, scale * 0.3)
    SetTextColour(to_int255(col.r), to_int255(col.g), to_int255(col.b), to_int255(col.a))
    SetTextOutline()
    SetTextJustification(2)  -- 2 = right align
    SetTextWrap(x / screen_w, (x + w) / screen_w)
    SetTextEntry("STRING")
    AddTextComponentString(str)
    EndTextCommandDisplayText(x / screen_w, y / screen_h)
end


local function button(id, label, x, y, w, h, m_x, m_y, screen_w, screen_h, clip_min_y, clip_max_y)
    if clip_min_y and clip_max_y then
        if y < clip_min_y or y > clip_max_y then return false end
    end
    local lmb_just_pressed = IsControlJustPressed(2, 237)

    -- Box sized to fit the text with horizontal padding
    local pad = 20.0
    local tw = get_text_width(label, 0.90, screen_w)
    local bw = tw + pad * 2
    -- Clamp so it never exceeds the passed-in max width
    if bw > w then bw = w end

    local hovered = hit(x, y, bw, h, m_x, m_y)
    local btn_col = hovered and {r=255,g=255,b=255,a=26} or {r=255,g=255,b=255,a=18}
    draw_rect(x, y, bw, h, btn_col, screen_w, screen_h)

    draw_text(label, x + pad, y + (h * 0.5 - 9.0), 0.90, cfg.theme.text, screen_w, screen_h, clip_min_y, clip_max_y)

    if hovered and lmb_just_pressed then
        return true
    end
    return false
end

local function slider_rgba(id, label, x, y, w, h, value, vmin, vmax, m_x, m_y, screen_w, screen_h, clip_min_y, clip_max_y)
    if clip_min_y and clip_max_y then
        if y - 23 < clip_min_y or y > clip_max_y then return value end
    end
    local lmb_just_pressed = IsControlJustPressed(2, 237)
    local lmb_pressed = IsControlPressed(2, 237)

    local bar_h = h
    local r = bar_h * 0.5
    local pad = 10.0

    draw_text(label, x, y - 23.0, 0.90, cfg.theme.text, screen_w, screen_h, clip_min_y, clip_max_y)

    draw_rect(x, y, w, bar_h, {r=255, g=255, b=255, a=20}, screen_w, screen_h)

    local t = 0.0
    if vmax ~= vmin then t = (value - vmin) / (vmax - vmin) end
    t = clamp(t, 0.0, 1.0)

    local knob_x = x + r + (w - r*2.0) * t
    local knob_y = y + r

    draw_rect(x, y, (knob_x - x), bar_h, {r=255, g=255, b=255, a=35}, screen_w, screen_h)

    draw_circle(knob_x, knob_y, r * 0.78, {r=255, g=255, b=255, a=170}, screen_w, screen_h)

    local hovered = hit(x, y, w, bar_h, m_x, m_y)

    if lmb_just_pressed and hovered then
        state.ui.active_slider = id
    end

    if state.ui.active_slider == id then
        if lmb_pressed then
            local px = clamp(m_x, x + r, x + w - r)
            local nt = (px - (x + r)) / (w - r*2.0)
            local nv = vmin + (vmax - vmin) * nt
            return nv
        else
            state.ui.active_slider = nil
        end
    end

    local read = string.format("%d", math.floor(value + 0.5))
    draw_text(read, x + w + pad, y - 2.0, 0.85, cfg.theme.text, screen_w, screen_h, clip_min_y, clip_max_y)

    return value
end

local function update_drag(screen_w, screen_h, m_x, m_y)
    local lmb_just_pressed = IsControlJustPressed(2, 237)
    local lmb_pressed = IsControlPressed(2, 237)

    local header_h = 34.0

    if lmb_just_pressed and hit(cfg.window.x, cfg.window.y, cfg.window.w, header_h, m_x, m_y) then
        state.dragging = true
        state.drag_off_x = m_x - cfg.window.x
        state.drag_off_y = m_y - cfg.window.y
    end

    if state.dragging then
        if lmb_pressed then
            cfg.window.x = m_x - state.drag_off_x
            cfg.window.y = m_y - state.drag_off_y
        else
            state.dragging = false
        end
    end
end

local function draw_tabbar(x, y, w, h, m_x, m_y, screen_w, screen_h)
    local lmb_just_pressed = IsControlJustPressed(2, 237)

    local btn_w = 120.0
    local gap = 8.0
    local cur_x = x

    for i = 1, #state.tabs do
        local name = state.tabs[i]
        local active = (state.active_tab == i)

        local tab_col = active and {r=70,g=70,b=70,a=210} or {r=45,g=45,b=45,a=170}
        draw_rect(cur_x, y, btn_w, h, tab_col, screen_w, screen_h)

        local text_col = active and {r=to_int255(cfg.theme.text.r), g=to_int255(cfg.theme.text.g), b=to_int255(cfg.theme.text.b), a=235}
                              or {r=to_int255(cfg.theme.text.r), g=to_int255(cfg.theme.text.g), b=to_int255(cfg.theme.text.b), a=180}
        local text_w = get_text_width(name, 0.95, screen_w)
        draw_text(name, cur_x + (btn_w - text_w) / 2, y + (h / 2 - 12.0), 0.95, text_col, screen_w, screen_h)

        if lmb_just_pressed and hit(cur_x, y, btn_w, h, m_x, m_y) then
            state.active_tab = i
            state.ui.settings_scroll = 0.0
            state.ui.wheel_accum = 0.0
            state.ui.settings_dragging = false
            state.ui.scrollbar_dragging = false
            state.ui.binding_open_key = false
            state.inPlayerList = false
            state.ui.vehicle_scroll = 0.0
            state.ui.vehicle_sb_dragging = false
            state.ui.vsel_scroll = 0.0
            state.ui.vsel_sb_dragging = false
            state.sel = 1
            state.scroll = 0
        end

        cur_x = cur_x + btn_w + gap
        if cur_x > (x + w - btn_w) then break end
    end
end

local function draw_scrollbar(area_x, area_y, area_w, area_h, scroll, content_h, m_x, m_y, screen_w, screen_h)
    if content_h <= area_h + 0.5 then
        state.ui.scrollbar_dragging = false
        return scroll
    end

    local lmb_just_pressed = IsControlJustPressed(2, 237)
    local lmb_pressed = IsControlPressed(2, 237)

    local track_w = 10.0
    local pad = 6.0

    local tx = area_x + area_w - track_w - pad
    local ty = area_y + pad
    local th = area_h - pad*2.0

    draw_rect(tx, ty, track_w, th, {r=255,g=255,b=255,a=18}, screen_w, screen_h)

    local max_scroll = content_h - area_h
    local ratio = area_h / content_h
    local thumb_h = clamp(th * ratio, 22.0, th)

    local t = clamp(scroll / max_scroll, 0.0, 1.0)
    local thumb_y = ty + (th - thumb_h) * t

    draw_rect(tx, thumb_y, track_w, thumb_h, {r=255,g=255,b=255,a=60}, screen_w, screen_h)

    local over_thumb = hit(tx, thumb_y, track_w, thumb_h, m_x, m_y)
    local over_track = hit(tx, ty, track_w, th, m_x, m_y)

    if lmb_just_pressed and over_thumb then
        state.ui.scrollbar_dragging = true
        state.ui.scrollbar_drag_offset = (m_y - thumb_y)
    end

    if lmb_just_pressed and (not over_thumb) and over_track then
        local click_y = clamp(m_y - (thumb_h * 0.5), ty, ty + th - thumb_h)
        local nt = (click_y - ty) / (th - thumb_h)
        scroll = nt * max_scroll
    end

    if state.ui.scrollbar_dragging then
        if lmb_pressed then
            local new_thumb_y = clamp(m_y - state.ui.scrollbar_drag_offset, ty, ty + th - thumb_h)
            local nt = (new_thumb_y - ty) / (th - thumb_h)
            scroll = nt * max_scroll
        else
            state.ui.scrollbar_dragging = false
        end
    end

    return clamp(scroll, 0.0, max_scroll)
end

local function draw_settings_panel(area_x, area_y, area_w, area_h, dt, m_x, m_y, screen_w, screen_h)
    local col = cfg.theme.text
    local lmb_just_pressed = IsControlJustPressed(2, 237)
    local lmb_pressed = IsControlPressed(2, 237)
    local hovered_area = hit(area_x, area_y, area_w, area_h, m_x, m_y)
    state.ui.settings_area.x = area_x
    state.ui.settings_area.y = area_y
    state.ui.settings_area.w = area_w
    state.ui.settings_area.h = area_h

    if hovered_area and (not state.ui.scrollbar_dragging) and (state.ui.active_slider == nil) then
        local w = state.ui.wheel_accum
        if w ~= 0.0 then
            state.ui.settings_scroll = state.ui.settings_scroll + (w * cfg.scroll_speed * 6.0)
            state.ui.wheel_accum = 0.0
        end
    else
        state.ui.wheel_accum = 0.0
    end

    if lmb_just_pressed and hovered_area and (state.ui.active_slider == nil) and (not state.ui.scrollbar_dragging) then
        state.ui.settings_dragging = true
        state.ui.settings_drag_last_y = m_y
    end

    if state.ui.settings_dragging then
        if lmb_pressed then
            local dy = (m_y - state.ui.settings_drag_last_y)
            state.ui.settings_drag_last_y = m_y
            state.ui.settings_scroll = state.ui.settings_scroll - dy
        else
            state.ui.settings_dragging = false
        end
    end

    local scroll = state.ui.settings_scroll
    local x = area_x + 2.0
    local y = area_y + 2.0 - scroll

    local clip_min_y = area_y
    local clip_max_y = area_y + area_h

    if y >= clip_min_y and y <= clip_max_y then
        draw_text("Settings", x, y, 1.05, col, screen_w, screen_h)
    end
    y = y + 36.0

    if y >= clip_min_y and y <= clip_max_y then
        draw_text("Hotkeys", x, y, 0.95, col, screen_w, screen_h)
    end
    y = y + 26.0

    if y >= clip_min_y and y <= clip_max_y then
        local key_label = "Open Key: " .. control_name(cfg.open_key)
        draw_text(key_label, x, y, 0.90, col, screen_w, screen_h)
    end
    y = y + 22.0

    local bx = x
    local by = y
    local bw = math.min(260.0, area_w - 90.0)
    local bh = 28.0

    local bind_text = state.ui.binding_open_key and "Press a key..." or "Bind Open Key"
    if button("bind_open_key", bind_text, bx, by, bw, bh, m_x, m_y, screen_w, screen_h, clip_min_y, clip_max_y) then
        state.ui.binding_open_key = true
        state.ui.active_slider = nil
        state.ui.scrollbar_dragging = false
        state.ui.settings_dragging = false
        state.ui.prev_control_down = {}
    end

    if state.ui.binding_open_key then
        state.ui.bind_flash_t = (state.ui.bind_flash_t or 0.0) + dt
        local a = (math.floor(state.ui.bind_flash_t * 4.0) % 2 == 0) and 220 or 120
        local flash_col = {r=255,g=255,b=255,a=a}
        if by + 5.0 >= clip_min_y and by + 5.0 <= clip_max_y then
            draw_text("Press any key to set menu open key", bx + bw + 14.0, by + 5.0, 0.85, flash_col, screen_w, screen_h)
        end
    else
        state.ui.bind_flash_t = 0.0
    end

    y = y + 40.0

    if y >= clip_min_y and y <= clip_max_y then
        draw_text("Config", x, y, 0.95, col, screen_w, screen_h)
    end
    y = y + 26.0

    local bw2 = math.min(180.0, area_w - 90.0)
    if button("save_cfg", "Save Config", x, y, bw2, bh, m_x, m_y, screen_w, screen_h, clip_min_y, clip_max_y) then
        save_config()
    end
    if button("load_cfg", "Load Config", x + bw2 + 10.0, y, bw2, bh, m_x, m_y, screen_w, screen_h, clip_min_y, clip_max_y) then
        load_config()
    end

    y = y + 52.0

    -- Font selector
    local font_names = {
        [0]="0 - Default",  [1]="1 - Subtitle",  [2]="2 - Menu",
        [3]="3 - Thin",     [4]="4 - Wasted",    [5]="5 - Pricedown",
        [6]="6 - Bank",     [7]="7 - Lemon Milk", [8]="8 - Invited",
    }
    local fw = math.min(360.0, area_w - 90.0)
    local new_font = slider_rgba("font_idx", "Font Index", x, y, fw, 14.0,
        cfg.font, 0, 8, m_x, m_y, screen_w, screen_h, clip_min_y, clip_max_y)
    cfg.font = math.floor(clamp(new_font + 0.5, 0, 8))
    y = y + 34.0

    local sw = math.min(360.0, area_w - 90.0)
    local sh_p = 14.0

    cfg.particles.count = math.floor(clamp(
        slider_rgba("part_count", "Particle Count", x, y, sw, sh_p, cfg.particles.count, 0, 200, m_x, m_y, screen_w, screen_h, clip_min_y, clip_max_y)
    + 0.5, 0, 200))
    y = y + 48.0

    cfg.particles.speed = slider_rgba("part_speed", "Particle Speed", x, y, sw, sh_p, cfg.particles.speed, 1.0, 300.0, m_x, m_y, screen_w, screen_h, clip_min_y, clip_max_y)
    y = y + 32.0

    -- Particles toggle button
    local ptbtn_label = cfg.particles.enabled and "Disable Particles" or "Enable Particles"
    local ptbtn_col = cfg.particles.enabled and {r=180,g=40,b=40,a=180} or {r=40,g=160,b=40,a=180}
    local ptbtn_w = math.min(220.0, area_w - 20.0)
    if y >= clip_min_y and y <= clip_max_y then
        draw_rect(x, y, ptbtn_w, 26.0, ptbtn_col, screen_w, screen_h)
        draw_text(ptbtn_label, x + 24.0, y + 2.0, 0.90, {r=255,g=255,b=255,a=230}, screen_w, screen_h, clip_min_y, clip_max_y)
        if IsControlJustPressed(2, 237) and hit(x, y, ptbtn_w, 26.0, m_x, m_y) then
            cfg.particles.enabled = not cfg.particles.enabled
            reset_particles()
        end
    end
    y = y + 36.0

    if y >= clip_min_y and y <= clip_max_y then
        draw_text("UI Colours", x, y, 1.00, col, screen_w, screen_h)
    end
    y = y + 34.0

    local sh = 14.0
    local gap = 34.0

    local function group(title, t)
        if y >= clip_min_y and y <= clip_max_y then
            draw_text(title, x, y, 0.95, col, screen_w, screen_h)
        end
        y = y + 50.0

        t.r = slider_rgba(title.."_r", "Red",   x, y, sw, sh, t.r, 0, 255, m_x, m_y, screen_w, screen_h, clip_min_y, clip_max_y); y = y + gap
        t.g = slider_rgba(title.."_g", "Green", x, y, sw, sh, t.g, 0, 255, m_x, m_y, screen_w, screen_h, clip_min_y, clip_max_y); y = y + gap
        t.b = slider_rgba(title.."_b", "Blue",  x, y, sw, sh, t.b, 0, 255, m_x, m_y, screen_w, screen_h, clip_min_y, clip_max_y); y = y + gap
        t.a = slider_rgba(title.."_a", "Alpha", x, y, sw, sh, t.a, 0, 255, m_x, m_y, screen_w, screen_h, clip_min_y, clip_max_y); y = y + (gap + 12.0)
    end

    group("Text", cfg.theme.text)
    group("Background", cfg.theme.background)
    group("Header", cfg.theme.header)
    group("Particles", cfg.theme.particles)

    y = y + 16.0
    local rw = math.min(380.0, area_w - 20.0)
    if button("reset_defaults", "Reset to Default", x, y, rw, bh, m_x, m_y, screen_w, screen_h, clip_min_y, clip_max_y) then
        cfg.particles.enabled    = true
        cfg.particles.count      = 60
        cfg.particles.speed      = 55.0
        cfg.particles.connect    = false
        cfg.particles.connect_dist = 120.0
        cfg.theme.text           = { r=255, g=255, b=255, a=220 }
        cfg.theme.background     = { r=15,  g=15,  b=15,  a=210 }
        cfg.theme.header         = { r=25,  g=25,  b=25,  a=235 }
        cfg.theme.particles      = { r=255, g=255, b=255, a=120 }
        cfg.font                 = 7
        cfg.scroll_speed         = 10.0
        reset_particles()
        notify_push("Addict", "~p~Settings reset to default")
    end
    y = y + bh + 8.0

    local content_h = (y + scroll) - area_y + 10.0
    state.ui.settings_content_h = content_h

    local max_scroll = math.max(0.0, content_h - area_h)
    state.ui.settings_scroll = clamp(state.ui.settings_scroll, 0.0, max_scroll)

    state.ui.settings_scroll = draw_scrollbar(area_x, area_y, area_w, area_h, state.ui.settings_scroll, content_h, m_x, m_y, screen_w, screen_h)
end

-- Forward declarations so draw_menu_panel can call helpers defined later
-- ── Steal Car Parts state ────────────────────────────────────────────────────
local spawnedParts    = {}
local ENGINE_HASH     = GetHashKey("prop_car_engine_01")
local WHEEL_HASH      = GetHashKey("prop_wheel_01")
local TYRE_HASH       = GetHashKey("prop_wheel_tyre")
local CARRY_BONE_ID   = 57005  -- right hand

local BROKEN_PART_HASHES = {
    GetHashKey("prop_wheel_01"), GetHashKey("prop_wheel_02"),
    GetHashKey("prop_wheel_03"), GetHashKey("prop_wheel_04"),
    GetHashKey("prop_wheel_tyre"), GetHashKey("prop_door_01"),
    GetHashKey("prop_bumper_01"), GetHashKey("prop_bumper_02"),
}

local function getClosestVehicleNearby(maxDist)
    local p   = PlayerPedId()
    local pos = GetEntityCoords(p)
    local best, bestDist = nil, maxDist or 8.0
    local iter, veh = FindFirstVehicle()
    local found = true
    while found do
        if DoesEntityExist(veh) and veh ~= GetVehiclePedIsIn(p, false) then
            local d = #(GetEntityCoords(veh) - pos)
            if d < bestDist then best = veh; bestDist = d end
        end
        found, veh = FindNextVehicle(iter)
    end
    EndFindVehicle(iter)
    return best
end

local function loadCarryAnim(p)
    local dict = "anim@heists@box_carry@"
    RequestAnimDict(dict)
    local t = 0
    while not HasAnimDictLoaded(dict) and t < 100 do Citizen.Wait(0); t = t + 1 end
    TaskPlayAnim(p, dict, "idle", 8.0, -8.0, -1, 49, 0, false, false, false)
end

local function loadAndSpawnObject(hash, coords)
    RequestModel(hash)
    local t = 0
    while not HasModelLoaded(hash) and t < 100 do Citizen.Wait(0); t = t + 1 end
    local obj = CreateObject(hash, coords.x, coords.y, coords.z, true, true, false)
    SetModelAsNoLongerNeeded(hash)
    -- Request network control of the newly spawned object
    NetworkRequestControlOfEntity(obj)
    local tw = 0
    while not NetworkHasControlOfEntity(obj) and tw < 20 do Citizen.Wait(0); tw = tw + 1 end
    return obj
end

local Activate
local GetPlayerList

-- ─── Radial Menu helpers ─────────────────────────────────────────────────────

-- Draws a true 3D wireframe bounding box around an entity using world-space DrawLine.
local function draw_3d_box(ent, r, g, b, a)
    if not DoesEntityExist(ent) then return end
    r = r or 180; g = g or 255; b = b or 100; a = a or 220

    local model = GetEntityModel(ent)
    local mn, mx = GetModelDimensions(model)
    local pos = GetEntityCoords(ent)
    local heading = math.rad(GetEntityHeading(ent))
    local cos_h = math.cos(heading)
    local sin_h = math.sin(heading)

    -- Rotate a local offset by entity heading and add world position
    local function corner(lx, ly, lz)
        return vector3(
            pos.x + cos_h * lx - sin_h * ly,
            pos.y + sin_h * lx + cos_h * ly,
            pos.z + lz
        )
    end

    local c = {
        corner(mn.x, mn.y, mn.z),
        corner(mx.x, mn.y, mn.z),
        corner(mx.x, mx.y, mn.z),
        corner(mn.x, mx.y, mn.z),
        corner(mn.x, mn.y, mx.z),
        corner(mx.x, mn.y, mx.z),
        corner(mx.x, mx.y, mx.z),
        corner(mn.x, mx.y, mx.z),
    }

    local function ln(a2, b2)
        DrawLine(c[a2].x,c[a2].y,c[a2].z, c[b2].x,c[b2].y,c[b2].z, r,g,b,a)
    end

    ln(1,2); ln(2,3); ln(3,4); ln(4,1)  -- bottom
    ln(5,6); ln(6,7); ln(7,8); ln(8,5)  -- top
    ln(1,5); ln(2,6); ln(3,7); ln(4,8)  -- verticals
end

-- Returns true if screen-space offset (px, py) from center falls within the
-- 60° wedge centered on slice_angle (radians, screen-coord convention y-down).
local function in_wedge(px, py, slice_angle)
    local half = math.pi / 6.0   -- 30° half-width per slice
    local rx = math.cos(slice_angle - half)
    local ry = math.sin(slice_angle - half)
    local lx = math.cos(slice_angle + half)
    local ly = math.sin(slice_angle + half)
    -- In screen-coord CW winding: inside = right-boundary cross > 0 AND left-boundary cross < 0
    return (rx * py - ry * px) > 0 and (lx * py - ly * px) < 0
end

local function ExecuteRadialAction(slice_idx, target)
    if not DoesEntityExist(target) then return end
    local p = PlayerPedId()

    if slice_idx == 1 then
        -- ── STEAL VEHICLE ──────────────────────────────────────────────────
        -- Find the vehicle the target is in, or the nearest vehicle to the target
        local veh = GetVehiclePedIsIn(target, false)
        if not DoesEntityExist(veh) then
            -- target might itself be a vehicle, or we search nearby
            if GetEntityType(target) == 2 then   -- 2 = vehicle
                veh = target
            else
                local pos = GetEntityCoords(target)
                local h, e = FindFirstVehicle(); local ok2; local best_d = 50.0
                repeat
                    if DoesEntityExist(e) then
                        local d = #(pos - GetEntityCoords(e))
                        if d < best_d then best_d = d; veh = e end
                    end
                    ok2, e = FindNextVehicle(h)
                until not ok2
                EndFindVehicle(h)
            end
        end
        if DoesEntityExist(veh) then
            SetPedIntoVehicle(p, veh, -1)   -- -1 = driver seat
            notify_push("Addict", "~p~Stolen vehicle!")
        else
            notify_push("Addict", "~r~No vehicle in range")
        end

    elseif slice_idx == 2 then
        -- ── LAUNCH UP ──────────────────────────────────────────────────────
        local vel = GetEntityVelocity(target)
        SetEntityVelocity(target, vel.x, vel.y, 85.0)
        notify_push("Addict", "~p~Launched skyward!")

    elseif slice_idx == 3 then
        -- ── EXPLODE ────────────────────────────────────────────────────────
        local pos = GetEntityCoords(target)
        AddExplosion(pos.x, pos.y, pos.z, 2, 15.0, true, false, 2.0)
        notify_push("Addict", "~r~Boom!")

    elseif slice_idx == 4 then
        -- ── FREEZE ENTITY (toggle) ─────────────────────────────────────────
        local key = NetworkGetNetworkIdFromEntity(target)
        if radialMenu_frozen[key] then
            FreezeEntityPosition(target, false)
            radialMenu_frozen[key] = nil
            notify_push("Addict", "~p~Entity unfrozen")
        else
            FreezeEntityPosition(target, true)
            radialMenu_frozen[key] = true
            notify_push("Addict", "~p~Entity frozen")
        end

    elseif slice_idx == 5 then
        -- ── DELETE ENTITY ─────────────────────────────────────────────────
        Citizen.CreateThread(function()
            if not DoesEntityExist(target) then
                notify_push("Addict", "~r~Entity no longer exists"); return
            end
            if NetworkGetEntityIsNetworked(target) then
                NetworkRequestControlOfEntity(target)
                local t = 0
                while not NetworkHasControlOfEntity(target) and t < 40 do
                    Citizen.Wait(0); t = t + 1
                end
                if not NetworkHasControlOfEntity(target) then
                    notify_push("Addict", "~r~Could not get control"); return
                end
            end
            SetEntityAsMissionEntity(target, false, true)
            local etype = GetEntityType(target)
            DeleteEntity(target)
            local label = etype == 1 and "Ped" or etype == 2 and "Vehicle" or "Object"
            notify_push("Addict", "~p~" .. label .. " deleted!")
        end)

    elseif slice_idx == 6 then
        -- ── RAGDOLL / SPIN-OUT ────────────────────────────────────────────
        if GetEntityType(target) == 1 then
            SetPedToRagdoll(target, 6000, 6000, 0, false, false, false)
            notify_push("Addict", "~p~Ragdolled!")
        else
            -- Vehicles / objects: wild angular force
            ApplyForceToEntity(target, 1,
                math.random(-4,4), math.random(-4,4), 8.0,
                math.random(-3,3), math.random(-3,3), math.random(-3,3),
                false, false, true, true, false)
            notify_push("Addict", "~p~Spin-out applied!")
        end
    end
end

-- Draws the 6-slice pizza radial menu centred on screen.
-- cam_dx / cam_dy are yaw / pitch deltas (degrees) from the snapshot rotation.
-- Positive cam_dx = looked right, positive cam_dy = looked up.
local function draw_radial_menu(screen_w, screen_h, cam_dx, cam_dy)
    local cx = screen_w  * 0.5
    local cy = screen_h  * 0.5
    local outer_r = math.min(screen_w, screen_h) * 0.145
    local inner_r = outer_r * 0.22
    local label_r  = outer_r * 0.63

    -- ── Determine hovered slice from camera aim delta ─────────────────────
    local scale = outer_r / 5.0
    local px   = -cam_dx * scale
    local py   = -cam_dy * scale
    local dist = math.sqrt(px*px + py*py)

    if dist > inner_r then
        local angle   = math.atan2(py, px)
        local shifted = angle + math.pi * 0.5
        if shifted < 0 then shifted = shifted + math.pi * 2.0 end
        local idx = math.floor(shifted / (math.pi / 3.0)) + 1
        radialMenu_hovered = (idx > 6) and 1 or idx
    else
        radialMenu_hovered = 0
    end

    -- (no background fill — fully transparent ring)

    -- ── Outer ring dots (white) ───────────────────────────────────────────
    for s = 0, 47 do
        local a  = math.pi * 2 * s / 48
        local rpx = cx + math.cos(a) * outer_r
        local rpy = cy + math.sin(a) * outer_r
        draw_rect(rpx - 2, rpy - 2, 4, 4, {r=200, g=200, b=200, a=160}, screen_w, screen_h)
    end

    -- ── Divider lines (white dots) ────────────────────────────────────────
    for i = 0, 5 do
        local div_a = math.pi * (-2.0/3.0 + i / 3.0)
        for s = 1, 11 do
            local t  = s / 12.0
            local r  = inner_r + (outer_r - inner_r) * t
            local dpx = cx + math.cos(div_a) * r
            local dpy = cy + math.sin(div_a) * r
            draw_rect(dpx - 1.5, dpy - 1.5, 3, 3, {r=180, g=180, b=180, a=160}, screen_w, screen_h)
        end
    end

    -- ── Slice labels — text only, no colour boxes ─────────────────────────
    for i = 1, 6 do
        local sa  = math.pi * (-0.5 + (i - 1) / 3.0)
        local sx  = cx + math.cos(sa) * label_r
        local sy  = cy + math.sin(sa) * label_r
        local hov = (radialMenu_hovered == i)

        local tw = get_text_width(radial_slices[i].label, 0.78, screen_w)
        local bw = math.max(tw + 20.0, hov and 80.0 or 66.0)
        local bh = hov and 30.0  or 24.0
        -- Minimal dark backdrop only
        draw_rect(sx - bw*0.5, sy - bh*0.5, bw, bh,
            {r=0, g=0, b=0, a=hov and 200 or 140}, screen_w, screen_h)
        -- Thin white border on hovered
        if hov then
            local brd = 1.5
            draw_rect(sx - bw*0.5 - brd, sy - bh*0.5 - brd, bw + brd*2, brd, {r=255,g=255,b=255,a=200}, screen_w, screen_h)
            draw_rect(sx - bw*0.5 - brd, sy + bh*0.5,        bw + brd*2, brd, {r=255,g=255,b=255,a=200}, screen_w, screen_h)
            draw_rect(sx - bw*0.5 - brd, sy - bh*0.5 - brd,  brd, bh + brd*2, {r=255,g=255,b=255,a=200}, screen_w, screen_h)
            draw_rect(sx + bw*0.5,        sy - bh*0.5 - brd,  brd, bh + brd*2, {r=255,g=255,b=255,a=200}, screen_w, screen_h)
        end

        local txt_col = hov and {r=255,g=255,b=255,a=255} or {r=180,g=180,b=180,a=180}
        draw_text(radial_slices[i].label, sx - tw*0.5, sy - 9.0, 0.78, txt_col, screen_w, screen_h)
    end

    -- ── Centre label ──────────────────────────────────────────────────────
    if radialMenu_hovered > 0 then
        local lbl = radial_slices[radialMenu_hovered].label
        local tw  = get_text_width(lbl, 0.72, screen_w)
        draw_text(lbl, cx - tw*0.5, cy - 10.0, 0.72,
            {r=255,g=255,b=255,a=255}, screen_w, screen_h)
    else
        local lbl = "Look to select"
        local tw  = get_text_width(lbl, 0.65, screen_w)
        draw_text(lbl, cx - tw*0.5, cy - 9.0, 0.65,
            {r=140,g=140,b=140,a=160}, screen_w, screen_h)
    end

    -- ── Bottom hint ───────────────────────────────────────────────────────
    local hint = "Aim to select slice  |  Release [G] to activate"
    local htw  = get_text_width(hint, 0.63, screen_w)
    draw_text(hint, cx - htw*0.5, cy + outer_r * 1.14, 0.63,
        {r=140,g=140,b=140,a=140}, screen_w, screen_h)
end

local function draw_player_list_panel(area_x, area_y, area_w, area_h, m_x, m_y, screen_w, screen_h)
    local lmb_just_pressed = IsControlJustPressed(2, 237)
    local lmb_pressed      = IsControlPressed(2, 237)

    draw_text("Players", area_x + 6.0, area_y, 0.95, cfg.theme.text, screen_w, screen_h)

    -- ── Select All toggle button ──────────────────────────────────────────
    local sa_h = 24.0
    local sa_y = area_y + 22.0
    local sa_w = area_w - 2.0
    local sa_col = selAllPlayers and {r=255,g=200,b=50,a=160} or {r=60,g=60,b=60,a=140}
    draw_rect(area_x, sa_y, sa_w, sa_h, sa_col, screen_w, screen_h)
    local sa_label = selAllPlayers and "Deselect All" or "Select All"
    local sa_tw = get_text_width(sa_label, 0.85, screen_w)
    draw_text(sa_label, area_x + (sa_w - sa_tw) * 0.5, sa_y + 3.0, 0.85,
        {r=255, g=255, b=255, a=230}, screen_w, screen_h)
    if lmb_just_pressed and hit(area_x, sa_y, sa_w, sa_h, m_x, m_y) then
        selAllPlayers = not selAllPlayers
        if selAllPlayers then selPlayer = nil end
    end

    local list_y = area_y + 22.0 + sa_h + 4.0
    local list_h = area_h - (list_y - area_y) - 18.0
    local bh  = 28.0
    local gap = 4.0

    -- Scrollbar geometry
    local sb_w   = 8.0
    local sb_pad = 4.0
    local sb_x   = area_x + area_w - sb_w - sb_pad
    local sb_y   = list_y
    local sb_h   = list_h

    -- Usable item width (leave room for scrollbar)
    local item_w = area_w - sb_w - sb_pad * 2 - 2.0

    local others = {}
    local myPed  = PlayerPedId()
    local myPos  = GetEntityCoords(myPed)
    local list = GetPlayerList()
    for _, pid2 in ipairs(list) do
        if pid2 ~= PlayerId() then
            local ped2 = GetPlayerPed(pid2)
            local dist = DoesEntityExist(ped2) and #(GetEntityCoords(ped2) - myPos) or 99999
            table.insert(others, { pid=pid2, dist=dist })
        end
    end
    table.sort(others, function(a, b) return a.dist < b.dist end)

    local total_count  = #others
    local row_h        = bh + gap
    local content_h    = total_count * row_h
    local max_scroll   = math.max(0.0, content_h - list_h)

    -- Mouse wheel scroll when hovering list
    if hit(area_x, list_y, area_w, list_h, m_x, m_y) then
        if IsControlJustReleased(2, 241) then state.ui.player_scroll = state.ui.player_scroll - (row_h * cfg.scroll_speed * 0.5) end
        if IsControlJustReleased(2, 242) then state.ui.player_scroll = state.ui.player_scroll + (row_h * cfg.scroll_speed * 0.5) end
    end
    state.ui.player_scroll = clamp(state.ui.player_scroll, 0.0, max_scroll)

    -- Draw scrollbar only when content overflows
    if content_h > list_h + 0.5 then
        -- Track
        draw_rect(sb_x, sb_y, sb_w, sb_h, {r=255,g=255,b=255,a=18}, screen_w, screen_h)

        -- Thumb
        local ratio   = list_h / content_h
        local thumb_h = clamp(sb_h * ratio, 20.0, sb_h)
        local t       = clamp(state.ui.player_scroll / max_scroll, 0.0, 1.0)
        local thumb_y = sb_y + (sb_h - thumb_h) * t

        draw_rect(sb_x, thumb_y, sb_w, thumb_h, {r=255,g=255,b=255,a=80}, screen_w, screen_h)

        -- Drag thumb
        local over_thumb = hit(sb_x, thumb_y, sb_w, thumb_h, m_x, m_y)
        local over_track = hit(sb_x, sb_y,    sb_w, sb_h,    m_x, m_y)

        if lmb_just_pressed and over_thumb then
            state.ui.player_sb_dragging = true
            state.ui.player_sb_offset   = m_y - thumb_y
        end
        if lmb_just_pressed and (not over_thumb) and over_track then
            local click_y = clamp(m_y - thumb_h * 0.5, sb_y, sb_y + sb_h - thumb_h)
            state.ui.player_scroll = ((click_y - sb_y) / (sb_h - thumb_h)) * max_scroll
        end
        if state.ui.player_sb_dragging then
            if lmb_pressed then
                local new_thumb_y = clamp(m_y - state.ui.player_sb_offset, sb_y, sb_y + sb_h - thumb_h)
                state.ui.player_scroll = ((new_thumb_y - sb_y) / (sb_h - thumb_h)) * max_scroll
            else
                state.ui.player_sb_dragging = false
            end
        end

        state.ui.player_scroll = clamp(state.ui.player_scroll, 0.0, max_scroll)
    end

    -- Draw items
    local clip_min_y = list_y
    local clip_max_y = list_y + list_h
    local iy = list_y - state.ui.player_scroll

    if total_count == 0 then
        draw_text("No other players", area_x + 6.0, list_y + 6.0, 0.85, cfg.theme.text, screen_w, screen_h)
    else
        for _, entry in ipairs(others) do
            local pid2 = entry.pid
            if iy + bh >= clip_min_y and iy <= clip_max_y then
                local ok, name = pcall(GetPlayerName, pid2)
                local dist_str = entry.dist < 99999 and (math.floor(entry.dist) .. "m") or "?m"
                local is_sel   = selAllPlayers or (selPlayer == pid2)
                local bg_col   = is_sel and {r=255,g=220,b=80,a=28} or {r=255,g=255,b=255,a=14}
                local txt_col  = is_sel and {r=255,g=220,b=80,a=255} or cfg.theme.text

                draw_rect(area_x, iy, item_w, bh, bg_col, screen_w, screen_h)
                draw_text(ok and name or "Unknown", area_x + 8.0, iy + (bh * 0.5 - 9.0), 0.85, txt_col, screen_w, screen_h, clip_min_y, clip_max_y)
                draw_text_right(dist_str, area_x, iy + (bh * 0.5 - 9.0), item_w - 8.0, 0.85, txt_col, screen_w, screen_h, clip_min_y, clip_max_y)

                if lmb_just_pressed and hit(area_x, iy, item_w, bh, m_x, m_y)
                   and iy >= clip_min_y and iy + bh <= clip_max_y then
                    selAllPlayers = false
                    selPlayer = pid2
                    notify_push("Addict", "Selected: ~p~" .. (ok and name or "Unknown"))
                end
            end
            iy = iy + row_h
        end
    end

end

local selVehGod = false

local function draw_vehicle_selected_panel(area_x, area_y, area_w, area_h, m_x, m_y, screen_w, screen_h)
    local lmb_just_pressed = IsControlJustPressed(2, 237)
    local lmb_pressed      = IsControlPressed(2, 237)
    local items = Menu["VehicleSelected"]

    -- Title
    draw_text("Selected Vehicle", area_x + 6.0, area_y, 0.95, cfg.theme.text, screen_w, screen_h)

    local list_y = area_y + 22.0
    local list_h = area_h - 22.0

    local bh      = 28.0
    local gap     = 4.0
    local row_h   = bh + gap
    local sb_w    = 8.0
    local sb_pad  = 4.0
    local sb_x    = area_x + area_w - sb_w - sb_pad
    local sb_y    = list_y
    local sb_h    = list_h
    local item_w  = area_w - sb_w - sb_pad * 2 - 2.0

    local content_h = #items * row_h
    local max_scroll = math.max(0.0, content_h - list_h)

    -- Mouse wheel
    if hit(area_x, list_y, area_w, list_h, m_x, m_y) then
        if IsControlJustReleased(2, 241) then state.ui.vsel_scroll = state.ui.vsel_scroll - (row_h * cfg.scroll_speed * 0.5) end
        if IsControlJustReleased(2, 242) then state.ui.vsel_scroll = state.ui.vsel_scroll + (row_h * cfg.scroll_speed * 0.5) end
    end
    state.ui.vsel_scroll = clamp(state.ui.vsel_scroll, 0.0, max_scroll)

    -- Scrollbar
    if content_h > list_h + 0.5 then
        draw_rect(sb_x, sb_y, sb_w, sb_h, {r=255,g=255,b=255,a=18}, screen_w, screen_h)
        local ratio   = list_h / content_h
        local thumb_h = clamp(sb_h * ratio, 20.0, sb_h)
        local t       = clamp(state.ui.vsel_scroll / max_scroll, 0.0, 1.0)
        local thumb_y = sb_y + (sb_h - thumb_h) * t
        draw_rect(sb_x, thumb_y, sb_w, thumb_h, {r=255,g=255,b=255,a=80}, screen_w, screen_h)

        local over_thumb = hit(sb_x, thumb_y, sb_w, thumb_h, m_x, m_y)
        local over_track = hit(sb_x, sb_y, sb_w, sb_h, m_x, m_y)
        if lmb_just_pressed and over_thumb then
            state.ui.vsel_sb_dragging = true
            state.ui.vsel_sb_offset   = m_y - thumb_y
        end
        if lmb_just_pressed and (not over_thumb) and over_track then
            local click_y = clamp(m_y - thumb_h * 0.5, sb_y, sb_y + sb_h - thumb_h)
            state.ui.vsel_scroll = ((click_y - sb_y) / (sb_h - thumb_h)) * max_scroll
        end
        if state.ui.vsel_sb_dragging then
            if lmb_pressed then
                local new_thumb_y = clamp(m_y - state.ui.vsel_sb_offset, sb_y, sb_y + sb_h - thumb_h)
                state.ui.vsel_scroll = ((new_thumb_y - sb_y) / (sb_h - thumb_h)) * max_scroll
            else
                state.ui.vsel_sb_dragging = false
            end
        end
        state.ui.vsel_scroll = clamp(state.ui.vsel_scroll, 0.0, max_scroll)
    end

    -- Items
    local clip_min_y = list_y
    local clip_max_y = list_y + list_h
    local iy = list_y - state.ui.vsel_scroll

    for i, orig_label in ipairs(items) do
        local label = orig_label
        if orig_label == "Godmode Selected" then
            label = "Godmode Selected (" .. (selVehGod and "ON" or "OFF") .. ")"
        end
        if iy + bh >= clip_min_y and iy <= clip_max_y then
            if button("vsel_" .. i, label, area_x, iy, item_w, bh, m_x, m_y, screen_w, screen_h, clip_min_y, clip_max_y) then
                Activate("VehicleSelected", orig_label)
            end
        end
        iy = iy + row_h
    end
end

local function draw_vehicle_list_panel(area_x, area_y, area_w, area_h, m_x, m_y, screen_w, screen_h)
    local lmb_just_pressed = IsControlJustPressed(2, 237)
    local lmb_pressed      = IsControlPressed(2, 237)

    -- Title
    draw_text("Nearby Vehicles", area_x + 6.0, area_y, 0.95, cfg.theme.text, screen_w, screen_h)

    local list_y = area_y + 30.0
    local list_h = area_h - 30.0

    local bh  = 28.0
    local gap = 4.0

    -- Scrollbar geometry (mirrors player list)
    local sb_w   = 8.0
    local sb_pad = 4.0
    local sb_x   = area_x + area_w - sb_w - sb_pad
    local sb_y   = list_y
    local sb_h   = list_h
    local item_w = area_w - sb_w - sb_pad * 2 - 2.0

    -- ── Gather + sort nearby vehicles ────────────────────────────────────────
    local p  = PlayerPedId()
    local pc = GetEntityCoords(p)
    local vehicles = {}

    local vh, ve = FindFirstVehicle()
    local vok
    repeat
        if DoesEntityExist(ve) then
            local vpos = GetEntityCoords(ve)
            local dist = #(pc - vpos)
            if dist < 500.0 then
                local model       = GetEntityModel(ve)
                local displayName = GetDisplayNameFromVehicleModel(model) or "UNKNOWN"
                local plate       = GetVehicleNumberPlateText(ve) or ""
                local vclass      = GetVehicleClass(ve)
                table.insert(vehicles, {
                    handle = ve,
                    dist   = dist,
                    name   = displayName,
                    plate  = plate,
                    class  = vclass,
                    pos    = vpos,
                })
            end
        end
        vok, ve = FindNextVehicle(vh)
    until not vok
    EndFindVehicle(vh)

    -- Nearest first
    table.sort(vehicles, function(a, b) return a.dist < b.dist end)

    local total_count = #vehicles
    local row_h       = bh + gap
    local content_hv  = total_count * row_h
    local max_scroll  = math.max(0.0, content_hv - list_h)

    -- ── Mouse wheel scroll ────────────────────────────────────────────────────
    if hit(area_x, list_y, area_w, list_h, m_x, m_y) then
        if IsControlJustReleased(2, 241) then state.ui.vehicle_scroll = state.ui.vehicle_scroll - (row_h * cfg.scroll_speed * 0.5) end
        if IsControlJustReleased(2, 242) then state.ui.vehicle_scroll = state.ui.vehicle_scroll + (row_h * cfg.scroll_speed * 0.5) end
    end
    state.ui.vehicle_scroll = clamp(state.ui.vehicle_scroll, 0.0, max_scroll)

    -- ── Scrollbar ─────────────────────────────────────────────────────────────
    if content_hv > list_h + 0.5 then
        -- Track
        draw_rect(sb_x, sb_y, sb_w, sb_h, {r=255,g=255,b=255,a=18}, screen_w, screen_h)

        -- Thumb
        local ratio   = list_h / content_hv
        local thumb_h = clamp(sb_h * ratio, 20.0, sb_h)
        local t       = clamp(state.ui.vehicle_scroll / max_scroll, 0.0, 1.0)
        local thumb_y = sb_y + (sb_h - thumb_h) * t

        draw_rect(sb_x, thumb_y, sb_w, thumb_h, {r=255,g=255,b=255,a=80}, screen_w, screen_h)

        local over_thumb = hit(sb_x, thumb_y, sb_w, thumb_h, m_x, m_y)
        local over_track = hit(sb_x, sb_y,    sb_w, sb_h,    m_x, m_y)

        if lmb_just_pressed and over_thumb then
            state.ui.vehicle_sb_dragging = true
            state.ui.vehicle_sb_offset   = m_y - thumb_y
        end
        if lmb_just_pressed and (not over_thumb) and over_track then
            local click_y = clamp(m_y - thumb_h * 0.5, sb_y, sb_y + sb_h - thumb_h)
            state.ui.vehicle_scroll = ((click_y - sb_y) / (sb_h - thumb_h)) * max_scroll
        end
        if state.ui.vehicle_sb_dragging then
            if lmb_pressed then
                local new_thumb_y = clamp(m_y - state.ui.vehicle_sb_offset, sb_y, sb_y + sb_h - thumb_h)
                state.ui.vehicle_scroll = ((new_thumb_y - sb_y) / (sb_h - thumb_h)) * max_scroll
            else
                state.ui.vehicle_sb_dragging = false
            end
        end
        state.ui.vehicle_scroll = clamp(state.ui.vehicle_scroll, 0.0, max_scroll)
    end

    -- ── Draw list items ───────────────────────────────────────────────────────
    local clip_min_y = list_y
    local clip_max_y = list_y + list_h

    -- Subtle list background
    draw_rect(area_x, list_y, item_w + sb_w + sb_pad * 2, list_h, {r=0,g=0,b=0,a=25}, screen_w, screen_h)

    local iy = list_y - state.ui.vehicle_scroll

    if total_count == 0 then
        draw_text("No nearby vehicles", area_x + 6.0, list_y + 8.0, 0.85, {r=140,g=140,b=140,a=160}, screen_w, screen_h)
    else
        for _, vd in ipairs(vehicles) do
            if iy + bh >= clip_min_y and iy <= clip_max_y then
                local is_sel  = (selVehicle == vd.handle)
                local bg_col  = is_sel and {r=255,g=220,b=80,a=28}  or {r=255,g=255,b=255,a=14}
                local txt_col = is_sel and {r=255,g=220,b=80,a=255} or cfg.theme.text
                local dim_col = is_sel and {r=255,g=220,b=80,a=180} or {r=160,g=160,b=160,a=150}

                draw_rect(area_x, iy, item_w, bh, bg_col, screen_w, screen_h)

                -- Vehicle display name (left)
                draw_text(vd.name, area_x + 8.0, iy + (bh * 0.5 - 9.0), 0.85, txt_col, screen_w, screen_h, clip_min_y, clip_max_y)

                -- Distance (right-aligned)
                local dist_str = math.floor(vd.dist + 0.5) .. "m"
                local dw = get_text_width(dist_str, 0.78, screen_w)
                draw_text(dist_str, area_x + item_w - dw - 6.0, iy + (bh * 0.5 - 9.0), 0.78, dim_col, screen_w, screen_h, clip_min_y, clip_max_y)

                -- Click to select
                if lmb_just_pressed and hit(area_x, iy, item_w, bh, m_x, m_y)
                   and iy >= clip_min_y and iy + bh <= clip_max_y then
                    selVehicle = vd.handle
                    notify_push("Addict", "~p~Selected: " .. vd.name)
                end
            end
            iy = iy + row_h
        end
    end

end

local function draw_menu_panel(tab_name, area_x, area_y, area_w, area_h, dt, m_x, m_y, screen_w, screen_h)
    local items = Menu[tab_name]

    local lmb_just_pressed = IsControlJustPressed(2, 237)
    local lmb_pressed = IsControlPressed(2, 237)
    local hovered_area = hit(area_x, area_y, area_w, area_h, m_x, m_y)
    state.ui.settings_area.x = area_x
    state.ui.settings_area.y = area_y
    state.ui.settings_area.w = area_w
    state.ui.settings_area.h = area_h

    if hovered_area and (not state.ui.scrollbar_dragging) and (state.ui.active_slider == nil) then
        local w = state.ui.wheel_accum
        if w ~= 0.0 then
            state.ui.settings_scroll = state.ui.settings_scroll + (w * cfg.scroll_speed * 6.0)
            state.ui.wheel_accum = 0.0
        end
    else
        state.ui.wheel_accum = 0.0
    end

    if lmb_just_pressed and hovered_area and (state.ui.active_slider == nil) and (not state.ui.scrollbar_dragging) then
        state.ui.settings_dragging = true
        state.ui.settings_drag_last_y = m_y
    end

    if state.ui.settings_dragging then
        if lmb_pressed then
            local dy = (m_y - state.ui.settings_drag_last_y)
            state.ui.settings_drag_last_y = m_y
            state.ui.settings_scroll = state.ui.settings_scroll - dy
        else
            state.ui.settings_dragging = false
        end
    end

    local scroll = state.ui.settings_scroll
    local x = area_x + 2.0
    local y = area_y + 2.0 - scroll

    local clip_min_y = area_y
    local clip_max_y = area_y + area_h

    local bh = 28.0
    local gap = 4.0

    for i, orig_label in ipairs(items) do
        local label = orig_label
        local tog = GetToggle(label)
        if tog ~= nil then
            label = label .. " (" .. (tog and "ON" or "OFF") .. ")"
        end

        if button("item_" .. tab_name .. "_" .. i, label, x, y, area_w - 20.0, bh, m_x, m_y, screen_w, screen_h, clip_min_y, clip_max_y) then
            Activate(tab_name, orig_label)
        end
        y = y + bh + gap
    end

    local content_h = (y + scroll) - area_y + 10.0
    state.ui.settings_content_h = content_h

    local max_scroll = math.max(0.0, content_h - area_h)
    state.ui.settings_scroll = clamp(state.ui.settings_scroll, 0.0, max_scroll)

    state.ui.settings_scroll = draw_scrollbar(area_x, area_y, area_w, area_h, state.ui.settings_scroll, content_h, m_x, m_y, screen_w, screen_h)
end

local function draw_particles(dt, screen_w, screen_h)
    if not cfg.particles.enabled then return end

    local target = clamp(cfg.particles.count, 0, 200)
    if #state.particles ~= target then
        reset_particles()
    end

    local left   = cfg.window.x
    local top    = cfg.window.y
    local right  = cfg.window.x + cfg.window.w
    local bottom = cfg.window.y + cfg.window.h

    local speed = clamp(cfg.particles.speed, 0.0, 500.0)
    local connect_dist = clamp(cfg.particles.connect_dist, 10.0, 400.0)
    local connect_dist_sq = connect_dist * connect_dist

    local pcol = cfg.theme.particles
    local pr, pg, pb, pa = to_int255(pcol.r), to_int255(pcol.g), to_int255(pcol.b), to_int255(pcol.a)
    local dot_col = {r=pr, g=pg, b=pb, a=pa}

    for i = 1, #state.particles do
        local p = state.particles[i]

        p.x = p.x + (p.vx * speed * dt)
        p.y = p.y + (p.vy * speed * dt)

        if p.x < left then p.x = left; p.vx = -p.vx end
        if p.x > right then p.x = right; p.vx = -p.vx end
        if p.y < top then p.y = top; p.vy = -p.vy end
        if p.y > bottom then p.y = bottom; p.vy = -p.vy end

        draw_circle(p.x, p.y, p.r, dot_col, screen_w, screen_h)
    end

    -- Comment out connect because hard to implement without rotated rects
    -- if cfg.particles.connect then ...
end

-- ─── Spectator / Noclip Detection ────────────────────────────────────────────
local spectator_list  = {}
local spec_panel_x    = nil
local spec_panel_y    = nil
local spec_dragging   = false
local spec_drag_ox    = 0.0
local spec_drag_oy    = 0.0
local spec_particles  = {}

local function reset_spec_particles(px, py, pw, ph)
    spec_particles = {}
    local count = clamp(math.floor(cfg.particles.count / 4), 0, 15)
    for i = 1, count do
        spec_particles[i] = {
            x  = GetRandomFloatInRange(px, px + pw),
            y  = GetRandomFloatInRange(py, py + ph),
            vx = GetRandomFloatInRange(-1.0, 1.0),
            vy = GetRandomFloatInRange(-1.0, 1.0),
            r  = GetRandomFloatInRange(1.5, 3.0),
        }
    end
end

-- Skeleton bone connections: {boneA_id, boneB_id}
local SKEL_BONES = {
    {0x796e, 0x5af3},  -- head → neck
    {0x5af3, 0x9995},  -- neck → upper spine
    {0x9995, 0x9a30},  -- upper spine → lower spine
    {0x9a30, 0x9f13},  -- lower spine → pelvis
    -- left arm
    {0x9995, 0xfc6a},  -- upper spine → left shoulder
    {0xfc6a, 0x506e},  -- left shoulder → left elbow
    {0x506e, 0x9b61},  -- left elbow → left wrist
    -- right arm
    {0x9995, 0x9d4d},  -- upper spine → right shoulder
    {0x9d4d, 0xe86d},  -- right shoulder → right elbow
    {0xe86d, 0xdead},  -- right elbow → right wrist
    -- left leg
    {0x9f13, 0xca72},  -- pelvis → left hip
    {0xca72, 0x37f9},  -- left hip → left knee
    {0x37f9, 0x83c5},  -- left knee → left foot
    -- right leg
    {0x9f13, 0x3b65},  -- pelvis → right hip
    {0x3b65, 0xb3fe},  -- right hip → right knee
    {0xb3fe, 0x63b4},  -- right knee → right foot
}

local function draw_skeleton_esp(ped, r, g, b)
    if not DoesEntityExist(ped) then return end
    for _, pair in ipairs(SKEL_BONES) do
        local boneA = GetPedBoneCoords(ped, pair[1], 0, 0, 0)
        local boneB = GetPedBoneCoords(ped, pair[2], 0, 0, 0)
        if boneA and boneB then
            DrawLine(boneA.x, boneA.y, boneA.z, boneB.x, boneB.y, boneB.z, r, g, b, 255)
        end
    end
end

local function draw_spectator_hud(screen_w, screen_h, dt, m_x, m_y)
    local p  = PlayerPedId()
    local pc = GetEntityCoords(p)

    -- Collect + sort by distance
    local nearby = {}
    for _, entry in ipairs(spectator_list) do
        if DoesEntityExist(entry.ped) then
            local d = #(GetEntityCoords(entry.ped) - pc)
            table.insert(nearby, { pid=entry.pid, name=entry.name, ped=entry.ped, dist=d })
        end
    end
    table.sort(nearby, function(a, b) return a.dist < b.dist end)

    local panel_w = 300.0
    local row_h   = 22.0
    local pad     = 8.0
    local title_h = 26.0
    local panel_h = title_h + math.max(1, #nearby) * row_h + pad

    -- Live theme colours
    local bg   = cfg.theme.background
    local hdr  = cfg.theme.header
    local txt  = cfg.theme.text
    local pcol = cfg.theme.particles
    local pr   = to_int255(pcol.r);  local pg = to_int255(pcol.g);  local pb = to_int255(pcol.b)
    local tr   = to_int255(txt.r);   local tg = to_int255(txt.g);   local tb = to_int255(txt.b);  local ta = to_int255(txt.a)

    -- Default spawn position
    if spec_panel_x == nil then
        spec_panel_x = 288.0
        spec_panel_y = 60.0
    end

    local panel_x = spec_panel_x
    local panel_y = spec_panel_y

    -- Drag logic (menu open only)
    local lmb_pressed  = IsControlPressed(2, 237)
    local lmb_just     = IsControlJustPressed(2, 237)
    local lmb_released = IsControlJustReleased(2, 237)

    if state.open then
        local over_header = m_x >= panel_x and m_x <= panel_x + panel_w
                        and m_y >= panel_y and m_y <= panel_y + title_h
        if lmb_just and over_header then
            spec_dragging = true
            spec_drag_ox  = m_x - panel_x
            spec_drag_oy  = m_y - panel_y
        end
    end
    if lmb_released then spec_dragging = false end
    if spec_dragging and lmb_pressed then
        spec_panel_x = clamp(m_x - spec_drag_ox, 0, screen_w - panel_w)
        spec_panel_y = clamp(m_y - spec_drag_oy, 0, screen_h - panel_h)
        panel_x = spec_panel_x
        panel_y = spec_panel_y
    end

    -- Background
    draw_rect(panel_x, panel_y, panel_w, panel_h,
        {r=to_int255(bg.r), g=to_int255(bg.g), b=to_int255(bg.b), a=to_int255(bg.a)},
        screen_w, screen_h)

    -- Particles (synced to menu particle settings)
    if cfg.particles.enabled then
        local target = clamp(math.floor(cfg.particles.count / 4), 0, 15)
        if #spec_particles ~= target then
            reset_spec_particles(panel_x, panel_y, panel_w, panel_h)
        end
        local speed   = clamp(cfg.particles.speed, 0.0, 500.0)
        local dot_col = {r=pr, g=pg, b=pb, a=to_int255(pcol.a)}
        for _, sp in ipairs(spec_particles) do
            sp.x = sp.x + sp.vx * speed * dt
            sp.y = sp.y + sp.vy * speed * dt
            if sp.x < panel_x           then sp.x = panel_x;           sp.vx = -sp.vx end
            if sp.x > panel_x + panel_w then sp.x = panel_x + panel_w; sp.vx = -sp.vx end
            if sp.y < panel_y           then sp.y = panel_y;           sp.vy = -sp.vy end
            if sp.y > panel_y + panel_h then sp.y = panel_y + panel_h; sp.vy = -sp.vy end
            draw_circle(sp.x, sp.y, sp.r, dot_col, screen_w, screen_h)
        end
    else
        spec_particles = {}
    end

    -- Header bar
    draw_rect(panel_x, panel_y, panel_w, title_h,
        {r=to_int255(hdr.r), g=to_int255(hdr.g), b=to_int255(hdr.b), a=to_int255(hdr.a)},
        screen_w, screen_h)

    -- Hover highlight on header
    if state.open then
        local over_h = m_x >= panel_x and m_x <= panel_x + panel_w
                   and m_y >= panel_y and m_y <= panel_y + title_h
        if over_h or spec_dragging then
            draw_rect(panel_x, panel_y, panel_w, title_h, {r=255,g=255,b=255,a=12}, screen_w, screen_h)
        end
    end

    -- Title
    draw_text("SPECTATORS", panel_x + pad, panel_y + 5.0, 0.82, {r=tr,g=tg,b=tb,a=ta}, screen_w, screen_h)

    if #nearby == 0 then
        draw_text("None detected", panel_x + pad, panel_y + title_h + 2.0, 0.75,
            {r=tr,g=tg,b=tb,a=100}, screen_w, screen_h)
    else
        for i, entry in ipairs(nearby) do
            local ry = panel_y + title_h + (i - 1) * row_h
            draw_rect(panel_x, ry, 3.0, row_h - 2.0, {r=pr,g=pg,b=pb,a=200}, screen_w, screen_h)
            draw_text(entry.name, panel_x + pad + 2.0, ry + 3.0, 0.78, {r=tr,g=tg,b=tb,a=ta}, screen_w, screen_h)
            draw_text_right(math.floor(entry.dist) .. "m", panel_x, ry + 3.0, panel_w - pad, 0.78, {r=tr,g=tg,b=tb,a=ta}, screen_w, screen_h)
            if DoesEntityExist(entry.ped) then
                draw_skeleton_esp(entry.ped, pr, pg, pb)
            end
        end
    end
end

local function draw_overlay(dt, screen_w, screen_h)
    local x, y, w, h = cfg.window.x, cfg.window.y, cfg.window.w, cfg.window.h
    local header_h = 34.0
    local footer_h = 26.0

    draw_rect(x, y, w, h, cfg.theme.background, screen_w, screen_h)

    draw_particles(dt, screen_w, screen_h)

    local m_x = GetControlNormal(2, 239) * screen_w
    local m_y = GetControlNormal(2, 240) * screen_h

    draw_rect(x, y, w, header_h, cfg.theme.header, screen_w, screen_h)

    draw_text("Addict", x + 14.0, y + 8.0, 1.0, cfg.theme.text, screen_w, screen_h)

    -- Close button top-right of header
    local close_w = 26.0
    local close_h = 20.0
    local close_x = x + w - close_w - 6.0
    local close_y = y + (header_h - close_h) * 0.5
    local lmb_close = IsControlJustPressed(2, 237)
    local over_close = hit(close_x, close_y, close_w, close_h, m_x, m_y)
    draw_rect(close_x, close_y, close_w, close_h, over_close and {r=200,g=60,b=60,a=200} or {r=160,g=40,b=40,a=160}, screen_w, screen_h)
    local x_tw = get_text_width("X", 0.85, screen_w)
    local x_th = 18.0
    draw_text("X", close_x + (close_w - x_tw) * 0.5 + 1.5, close_y + (close_h - x_th) * 0.5 - 2.0, 0.85, {r=255,g=255,b=255,a=230}, screen_w, screen_h)
    if over_close and lmb_close then state.open = false end

    local tabbar_h = 34.0
    draw_tabbar(x + 14.0, y + header_h + 10.0, w - 28.0, tabbar_h, m_x, m_y, screen_w, screen_h)

    local tab_name = state.tabs[state.active_tab] or "Unknown"

    local content_x = x + 14.0
    local content_y = y + header_h + tabbar_h + 14.0
    local content_w = w - 28.0
    local content_h = (y + h - footer_h - 10.0) - content_y

    if tab_name == "Settings" then
        draw_settings_panel(content_x, content_y, content_w, content_h, dt, m_x, m_y, screen_w, screen_h)
    elseif tab_name == "Players" then
        local left_w = content_w * 0.58
        local right_w = content_w - left_w - 8.0
        local right_x = content_x + left_w + 8.0
        draw_menu_panel(tab_name, content_x, content_y, left_w, content_h, dt, m_x, m_y, screen_w, screen_h)
        draw_player_list_panel(right_x, content_y, right_w, content_h, m_x, m_y, screen_w, screen_h)
    elseif tab_name == "Vehicle" then
        local gap = 8.0
        local col_w = (content_w - gap * 2) / 3.0
        local mid_x = content_x + col_w + gap
        local right_x = mid_x + col_w + gap
        draw_menu_panel(tab_name, content_x, content_y, col_w, content_h, dt, m_x, m_y, screen_w, screen_h)
        draw_vehicle_selected_panel(mid_x, content_y, col_w, content_h, m_x, m_y, screen_w, screen_h)
        draw_vehicle_list_panel(right_x, content_y, col_w, content_h, m_x, m_y, screen_w, screen_h)
    else
        draw_menu_panel(tab_name, content_x, content_y, content_w, content_h, dt, m_x, m_y, screen_w, screen_h)
    end

    local ver_w = get_text_width(my_version, 0.9, screen_w)
    draw_text(my_version, x + w - ver_w - 14.0, y + h - footer_h + 1.9, 0.9, cfg.theme.text, screen_w, screen_h)
end

local function LoadModel(model)
    if not IsModelInCdimage(model) then return false end
    RequestModel(model); local t=0
    while not HasModelLoaded(model) and t<100 do Wait(50); t=t+1 end
    return HasModelLoaded(model)
end

local function SpawnVeh(model)
    local p=PlayerPedId(); local c=GetEntityCoords(p)
    if LoadModel(model) then
        local v=CreateVehicle(model,c.x,c.y,c.z+1,GetEntityHeading(p),true,false)
        SetVehicleOnGroundProperly(v); SetPedIntoVehicle(p,v,-1)
        SetEntityAsMissionEntity(v,true,true); SetModelAsNoLongerNeeded(model); notify_push("Addict", "~p~Vehicle Spawned")
    end
end

local function SpawnVehRaw(model)
    local p=PlayerPedId(); local c=GetEntityCoords(p)
    if LoadModel(model) then
        local v=CreateVehicle(model,c.x,c.y,c.z+1,GetEntityHeading(p),true,false)
        SetVehicleOnGroundProperly(v); SetEntityAsMissionEntity(v,true,true)
        SetModelAsNoLongerNeeded(model); return v
    end
end

local function SpawnVehAtCoords(model, coords, heading)
    if LoadModel(model) then
        local v=CreateVehicle(model,coords.x,coords.y,coords.z+1,heading or 0,true,false)
        SetVehicleOnGroundProperly(v); SetEntityAsMissionEntity(v,true,true)
        SetModelAsNoLongerNeeded(model); return v
    end
end

local function SpawnPed(model,x,y,z)
    if not IsModelInCdimage(model) then return end
    RequestModel(model); local t=0
    while not HasModelLoaded(model) and t<100 do Wait(50); t=t+1 end
    if HasModelLoaded(model) then
        local ped=CreatePed(4,model,x,y,z,0,true,true)
        SetModelAsNoLongerNeeded(model); return ped
    end
end

local function DrawText3D(x,y,z,text)
    local on,sx,sy=World3dToScreen2d(x,y,z)
    if on then SetTextScale(0.28,0.28); SetTextColour(255,255,255,200); SetTextEntry("STRING"); AddTextComponentString(text); DrawText(sx,sy) end
end

local function ApplyForceField(radius)
    local p=PlayerPedId(); local pc=GetEntityCoords(p)
    local h,e=FindFirstPed(); local ok
    repeat
        if DoesEntityExist(e) and e~=p then
            local pos=GetEntityCoords(e)
            if #(pc-pos)<radius then ApplyForceToEntity(e,1,pc.x-pos.x,pc.y-pos.y,pc.z-pos.z,0,0,0,true,true,true,true,false) end
        end; ok,e=FindNextPed(h)
    until not ok; EndFindPed(h)
    local h2,e2=FindFirstVehicle(); local ok2
    repeat
        if DoesEntityExist(e2) then
            local pos=GetEntityCoords(e2)
            if #(pc-pos)<radius then ApplyForceToEntity(e2,1,pc.x-pos.x,pc.y-pos.y,pc.z-pos.z,0,0,0,true,true,true,true,false) end
        end; ok2,e2=FindNextVehicle(h2)
    until not ok2; EndFindVehicle(h2)
end

GetPlayerList = function()
    local list={}; for i=0,128 do if NetworkIsPlayerActive(i) then table.insert(list,i) end end; return list
end

local function RotationToDirection(rotation)
    local adjustedRotation = vector3(math.rad(rotation.x), math.rad(rotation.y), math.rad(rotation.z))
    local direction = vector3(
        -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.sin(adjustedRotation.x)
    )
    return direction
end

local function HandleNoclip()
    local p=PlayerPedId()
    SetEntityCollision(p,false,false)
    FreezeEntityPosition(p,true)

    -- Kill any existing velocity and wait for all keys to be released
    if not noclip_ready then
        SetEntityVelocity(p,0,0,0)
        local anyHeld = IsControlPressed(0,32) or IsControlPressed(0,33)
                     or IsControlPressed(0,34) or IsControlPressed(0,9)
                     or IsControlPressed(0,22) or IsControlPressed(0,36)
                     or IsDisabledControlPressed(0,22) or IsDisabledControlPressed(0,32)
                     or IsDisabledControlPressed(0,33)
        if not anyHeld then noclip_ready = true end
        return
    end

    local speed=0.5; local fwd=GetEntityForwardVector(p)
    local right=vector3(fwd.y,-fwd.x,0); local up=vector3(0,0,1)
    local mv=vector3(0,0,0)
    if IsControlPressed(0,32) then mv=mv+fwd*speed end
    if IsControlPressed(0,33) then mv=mv-fwd*speed end
    if IsControlPressed(0,34) then mv=mv-right*speed end
    if IsControlPressed(0,9)  then mv=mv+right*speed end
    if IsControlPressed(0,22) then mv=mv+up*speed end
    if IsControlPressed(0,36) then mv=mv-up*speed end
    local pos=GetEntityCoords(p)
    SetEntityCoords(p,pos.x+mv.x,pos.y+mv.y,pos.z+mv.z,false,false,false,false)
    SetEntityHeading(p,GetGameplayCamRot(2).z)
end

local function UpdateBlips()
    for i=0,128 do
        if NetworkIsPlayerActive(i) and i~=PlayerId() then
            if not blipMap[i] then
                local blip=AddBlipForEntity(GetPlayerPed(i)); SetBlipAsShortRange(blip,false)
                local ok,name=pcall(GetPlayerName,i)
                BeginTextCommandSetBlipName("STRING"); AddTextComponentString(ok and name or "Player"); EndTextCommandSetBlipName(blip)
                blipMap[i]=blip
            end
        elseif blipMap[i] then RemoveBlip(blipMap[i]); blipMap[i]=nil end
    end
end

local function ClearBlips()
    for i,b in pairs(blipMap) do RemoveBlip(b); blipMap[i]=nil end
end

local function DrawESP()
    local p=PlayerPedId(); local pc=GetEntityCoords(p)
    for i=0,128 do
        if NetworkIsPlayerActive(i) and i~=PlayerId() then
            local ped=GetPlayerPed(i)
            if DoesEntityExist(ped) then
                local pos=GetEntityCoords(ped); local dist=#(pc-pos)
                local on,sx,sy=GetScreenCoordFromWorldCoord(pos.x,pos.y,pos.z+1)
                if on and dist<200 then
                    local ok,name=pcall(GetPlayerName,i)
                    SetTextScale(0.3,0.3); SetTextColour(180,60,255,255)
                    SetTextEntry("STRING"); AddTextComponentString((ok and name or "Player").." ["..math.floor(dist).."m]"); DrawText(sx-0.02,sy)
                end
            end
        end
    end
end

local function CrashPlayer(targetPed)
    -- Assuming a stub, as original definition is missing
    notify_push("Addict", "~r~Crash attempted, but function not implemented")
end

local function TripPlayer(targetPed)
    local targetPos = GetEntityCoords(targetPed, false)
    local TripObjects = {
        GetHashKey("prop_fnclink_05crnr1"), GetHashKey("xs_prop_hamburgher_wl"), GetHashKey("prop_ld_fireaxe"),
        GetHashKey("prop_gascyl_01a"), GetHashKey("prop_windmill_01"),
        0x34315488, 0x4F2526DA, 0x6A27FEB1, 0xC6899CDE, 0xD14B5BA3, 0xD769D2D0, 0xEF9B04F7,
        0xF2E1CB72, 0xFA74203C, 0xFCFA9E1B, 0xD9F4474C, 0x69D4F974, 0xCAFC1EC3, 0x79B41171,
        0xC07792D4, 0x781E451D, 0x762657C6, 0xC3C00861, 0x81FB3FF0, 0x45EF7804, 0xE764D794
    }
    local TripPeds = {
        GetHashKey("a_m_y_mexthug_01"), GetHashKey("csb_ramp_gang"), GetHashKey("ig_ramp_gang"),
        GetHashKey("s_m_y_hwaycop_01"), GetHashKey("s_m_m_paramedic_01"), GetHashKey("mp_m_fibsec_01")
    }
    local TripVehicles = {
        GetHashKey("ruiner2"), GetHashKey("phantom2"), GetHashKey("hauler2"),
        GetHashKey("technical2"), GetHashKey("boxville5"), GetHashKey("wastelander")
    }
    -- Object spam
    Citizen.CreateThread(function()
        for i = 1, 100 do
            for _, hash in ipairs(TripObjects) do
                RequestModel(hash)
                while not HasModelLoaded(hash) do Citizen.Wait(0) end
                local obj = CreateObject(hash, targetPos.x + math.random(-2,2), targetPos.y + math.random(-2,2), targetPos.z + math.random(-1,1), true, true, true)
                SetEntityAsMissionEntity(obj, true, true)
                SetEntityVisible(obj, true, false)
                SetEntityInvincible(obj, true)
                FreezeEntityPosition(obj, true)
                Citizen.Wait(5)
            end
        end
    end)
    -- Ped flood
    Citizen.CreateThread(function()
        for i = 1, 80 do
            for _, hash in ipairs(TripPeds) do
                RequestModel(hash)
                while not HasModelLoaded(hash) do Citizen.Wait(0) end
                local ped = CreatePed(26, hash, targetPos.x, targetPos.y, targetPos.z, 0.0, true, true)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityInvincible(ped, true)
                TaskWanderStandard(ped, 10.0, 10)
                Citizen.Wait(10)
            end
        end
    end)
    -- Vehicle flood
    Citizen.CreateThread(function()
        for i = 1, 50 do
            for _, hash in ipairs(TripVehicles) do
                RequestModel(hash)
                while not HasModelLoaded(hash) do Citizen.Wait(0) end
                local veh = CreateVehicle(hash, targetPos.x + math.random(-3,3), targetPos.y + math.random(-3,3), targetPos.z + 1.0, 0.0, true, true)
                SetEntityAsMissionEntity(veh, true, true)
                SetVehicleEngineOn(veh, true, true, false)
                SetEntityInvincible(veh, true)
                Citizen.Wait(15)
            end
        end
    end)
end

Activate = function(tab_name, it)
    local p = PlayerPedId(); local pid = PlayerId(); local c = GetEntityCoords(p)
    if tab_name == "Self" then
        if it=="Godmode" then feat.godmode=not feat.godmode; SetEntityInvincible(p,feat.godmode); notify_push("Addict", "Godmode "..(feat.godmode and "~p~ON" or "~r~OFF"))
        elseif it=="No Ragdoll" then feat.noragdoll=not feat.noragdoll; SetPedCanRagdoll(p,not feat.noragdoll); notify_push("Addict", "No Ragdoll "..(feat.noragdoll and "~p~ON" or "~r~OFF"))
        elseif it=="No Criticals" then feat.nocriticals=not feat.nocriticals; notify_push("Addict", "No Criticals "..(feat.nocriticals and "~p~ON" or "~r~OFF"))
        elseif it=="Invisibility" then feat.invisible=not feat.invisible; SetEntityVisible(p,not feat.invisible,false); SetEntityAlpha(p,feat.invisible and 0 or 255,false); notify_push("Addict", "Invisibility "..(feat.invisible and "~p~ON" or "~r~OFF"))
        elseif it=="Super Run" then feat.superrun=not feat.superrun; notify_push("Addict", "Super Run "..(feat.superrun and "~p~ON" or "~r~OFF"))
        elseif it=="Super Jump" then feat.superjump=not feat.superjump; notify_push("Addict", "Super Jump "..(feat.superjump and "~p~ON" or "~r~OFF"))
        elseif it=="Super Strength" then Powers.superstrength=not Powers.superstrength; notify_push("Addict", "Super Strength "..(Powers.superstrength and "~p~ON" or "~r~OFF"))
        elseif it=="Infinite Stamina" then feat.stamina=not feat.stamina; notify_push("Addict", "Stamina "..(feat.stamina and "~p~ON" or "~r~OFF"))
        elseif it=="Noclip" then
            noclipActive=not noclipActive
            noclip_ready=false
            if noclipActive then SetEntityVelocity(PlayerPedId(),0,0,0) end
            notify_push("Addict", "Noclip "..(noclipActive and "~p~ON" or "~r~OFF"))
        elseif it=="Teleport To Waypoint" then
            local blip=GetFirstBlipInfoId(8)
            if DoesBlipExist(blip) then local co=GetBlipInfoIdCoord(blip); local ok,gz=GetGroundZFor_3dCoord(co.x,co.y,1000,false); SetEntityCoords(p,co.x,co.y,ok and gz or co.z,false,false,false,true); notify_push("Addict", "~p~Teleported")
            else notify_push("Addict", "~r~No waypoint set") end
        elseif it=="Teleport To Coords" then
            DisplayOnscreenKeyboard(1,"FMMC_KEY_TIP1","","","","","",50)
            while UpdateOnscreenKeyboard()==0 do Wait(0) end
            local res=GetOnscreenKeyboardResult()
            if res then local coords={}; for v in res:gmatch("[^,]+") do table.insert(coords,tonumber(v)) end
                if #coords>=3 then SetEntityCoords(p,coords[1],coords[2],coords[3],false,false,false,true); notify_push("Addict", "~p~Teleported")
                else notify_push("Addict", "~r~Format: x,y,z") end end
        elseif it=="Heal & Armour" then SetEntityHealth(p,GetEntityMaxHealth(p)); SetPedArmour(p,100); notify_push("Addict", "~p~Healed")
        elseif it=="Wanted Level 0" then SetMaxWantedLevel(0); SetPlayerWantedLevel(pid,0,false); SetPlayerWantedLevelNow(pid,false); notify_push("Addict", "~p~Wanted cleared")
        elseif it=="Wanted Level 5" then SetMaxWantedLevel(5); SetPlayerWantedLevel(pid,5,false); SetPlayerWantedLevelNow(pid,false); notify_push("Addict", "~r~Wanted 5")
        elseif it=="Refill Ammo" then
            local weps={0x1B06D571,0x5EF9FEC4,0x13532244,0x83BF0278,0x9D61E50F,0xBFEFFF6D,0xC0A3098D,0xA2719263}
            for _,w in pairs(weps) do if HasPedGotWeapon(p,w,false) then SetPedAmmo(p,w,9999) end end; notify_push("Addict", "~p~Ammo refilled")
        elseif it=="Freecam" then
            feat.freecam = not feat.freecam
            notify_push("Addict", "Freecam "..(feat.freecam and "~p~ON" or "~r~OFF"))
        elseif it=="Radial Menu" then
            feat.radialMenu = not feat.radialMenu
            if not feat.radialMenu then
                radialMenu_open = false; radialMenu_hovered = 0; radialMenu_target = nil
            end
            notify_push("Addict", "Radial Menu "..(feat.radialMenu and "~p~ON  (hold [G] on entity)" or "~r~OFF"))
        end
    elseif tab_name == "Players" then
        -- When Select All is active, loop over every other player for one-shot actions.
        -- Toggle actions (spectate, vortex, swarm) are excluded.
        local toggleActions = {
            ["Spectate Player (toggle) (on selected)"] = true,
            ["Vortex Player (on selected)"]            = true,
            ["Franklin Swarm (on selected)"]           = true,
        }
        if selAllPlayers and not toggleActions[it] then
            local prevSel = selPlayer
            selAllPlayers = false  -- prevent infinite recursion
            for _, apid in ipairs(GetPlayerList()) do
                if apid ~= PlayerId() then
                    selPlayer = apid
                    Activate(tab_name, it)
                end
            end
            selPlayer     = prevSel
            selAllPlayers = true
            return
        end
        if it=="Teleport To Player (on selected)" then
            if not selPlayer then notify_push("Addict", "~r~Select a player first"); return end
            local ped=GetPlayerPed(selPlayer); if DoesEntityExist(ped) then local pos=GetEntityCoords(ped); SetEntityCoords(p,pos.x+1,pos.y+1,pos.z,false,false,false,true); notify_push("Addict", "~p~Teleported") end
        elseif it=="Spectate Player (toggle) (on selected)" then
            feat.spectate = not feat.spectate
            if feat.spectate then
                if not selPlayer then notify_push("Addict", "~r~Select a player first"); feat.spectate = false; return end
                local target = GetPlayerPed(selPlayer)
                if not DoesEntityExist(target) then feat.spectate = false; return end
                local targetPos = GetEntityCoords(target)
                local initialDir = GetEntityForwardVector(target) * -1.0
                specPos = targetPos + initialDir * specDistance + vector3(0.0, 0.0, 1.0)
                specRot = vector3(0.0, 0.0, GetEntityHeading(target) - 180.0)
                spectateCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
                SetCamCoord(spectateCam, specPos)
                SetCamRot(spectateCam, specRot, 2)
                SetCamActive(spectateCam, true)
                RenderScriptCams(true, true, 500, true, true)
                SetEntityVisible(p, false, false)
                SetEntityCollision(p, false, false)
                notify_push("Addict", "Spectate ~p~ON")
            else
                RenderScriptCams(false, true, 500, true, true)
                if spectateCam ~= nil then
                    SetCamActive(spectateCam, false)
                    DestroyCam(spectateCam, true)
                    spectateCam = nil
                end
                SetEntityVisible(p, true, false)
                SetEntityCollision(p, true, true)
                specPos = nil
                specRot = nil
                specDistance = 5.0
                notify_push("Addict", "Spectate ~r~OFF")
            end
        elseif it=="Cage Selected Player (on selected)" then
            if not selPlayer then notify_push("Addict", "~r~Select player first"); return end
            local ped=GetPlayerPed(selPlayer); if DoesEntityExist(ped) then local pos=GetEntityCoords(ped); PlaceObjectOnGroundProperly(CreateObject(GetHashKey("prop_gold_cont_01"),pos.x,pos.y,pos.z,true,true,false)); notify_push("Addict", "~p~Caged") end
        elseif it=="Pull All Peds (to selected)" then
            if not selPlayer then notify_push("Addict", "~r~Select player first"); return end
            local targetPed = GetPlayerPed(selPlayer)
            if not DoesEntityExist(targetPed) then return end
            local targetC = GetEntityCoords(targetPed)
            Citizen.CreateThread(function()
                local h,e=FindFirstPed(); local ok
                repeat
                    if DoesEntityExist(e) and e~=p then
                        net_ctrl(e); SetEntityCoords(e,targetC.x,targetC.y,targetC.z,false,false,false,true)
                    end; ok,e=FindNextPed(h)
                until not ok; EndFindPed(h)
                notify_push("Addict", "~p~Pulled to selected")
            end)
        elseif it=="Pull All Vehicles (to selected)" then
            if not selPlayer then notify_push("Addict", "~r~Select player first"); return end
            local targetPed = GetPlayerPed(selPlayer)
            if not DoesEntityExist(targetPed) then return end
            local targetC = GetEntityCoords(targetPed)
            Citizen.CreateThread(function()
                local h,e=FindFirstVehicle(); local ok
                repeat
                    if DoesEntityExist(e) then
                        net_ctrl(e); SetEntityCoords(e,targetC.x,targetC.y,targetC.z,false,false,false,true)
                    end; ok,e=FindNextVehicle(h)
                until not ok; EndFindVehicle(h)
                notify_push("Addict", "~p~Pulled to selected")
            end)
        elseif it=="Pull All Props (to selected)" then
            if not selPlayer then notify_push("Addict", "~r~Select player first"); return end
            local targetPed = GetPlayerPed(selPlayer)
            if not DoesEntityExist(targetPed) then return end
            local targetC = GetEntityCoords(targetPed)
            Citizen.CreateThread(function()
                local h,e=FindFirstObject(); local ok
                repeat
                    if DoesEntityExist(e) then
                        net_ctrl(e); SetEntityCoords(e,targetC.x,targetC.y,targetC.z,false,false,false,true)
                    end; ok,e=FindNextObject(h)
                until not ok; EndFindObject(h)
                notify_push("Addict", "~p~Pulled to selected")
            end)
        elseif it=="HELL MODE (on selected)" then
            if not selPlayer then notify_push("Addict", "~r~Select player first"); return end
            local targetPed = GetPlayerPed(selPlayer)
            if not DoesEntityExist(targetPed) then return end
            local targetC = GetEntityCoords(targetPed)
            for i=1,3 do AddExplosion(targetC.x+math.random(-20,20),targetC.y+math.random(-20,20),targetC.z+math.random(0,10),29,5,true,false,1) end; notify_push("Addict", "~p~HELL MODE on selected")
        elseif it=="Vortex Player (on selected)" then
            if not selPlayer then notify_push("Addict", "~r~Select player first"); return end
            feat.vortex = not feat.vortex
            vortex_target = feat.vortex and selPlayer or nil
            notify_push("Addict", "Vortex "..(feat.vortex and "~p~ON" or "~r~OFF"))
        elseif it=="Trip Player (on selected)" then
            if not selPlayer then notify_push("Addict", "~r~Select player first"); return end
            local targetPed = GetPlayerPed(selPlayer)
            if not DoesEntityExist(targetPed) then notify_push("Addict", "~r~Target not found"); return end
            TripPlayer(targetPed)
            notify_push("Addict", "~p~Trip sent to selected player")
        elseif it=="Crash Player (on selected)" then
            if not selPlayer then notify_push("Addict", "~r~Select player first"); return end
            local targetPed = GetPlayerPed(selPlayer)
            if not DoesEntityExist(targetPed) then return end
            CrashPlayer(targetPed)
            notify_push("Addict", "~r~Crashing selected player")
        elseif it=="Spawn Cargoplane (on selected)" then
            if not selPlayer then notify_push("Addict", "~r~Select player first"); return end
            local targetPed = GetPlayerPed(selPlayer)
            if not DoesEntityExist(targetPed) then return end
            local targetC = GetEntityCoords(targetPed)
            local model = `cargoplane`
            SpawnVehAtCoords(model, targetC, GetEntityHeading(targetPed)); notify_push("Addict", "~p~Spawned on selected")
        elseif it=="Spawn Rumpo2 (on selected)" then
            if not selPlayer then notify_push("Addict", "~r~Select player first"); return end
            local targetPed = GetPlayerPed(selPlayer)
            if not DoesEntityExist(targetPed) then return end
            local targetC = GetEntityCoords(targetPed)
            local model = `rumpo2`
            SpawnVehAtCoords(model, targetC, GetEntityHeading(targetPed)); notify_push("Addict", "~p~Spawned on selected")
        elseif it=="Spawn Cerberus (on selected)" then
            if not selPlayer then notify_push("Addict", "~r~Select player first"); return end
            local targetPed = GetPlayerPed(selPlayer)
            if not DoesEntityExist(targetPed) then return end
            local targetC = GetEntityCoords(targetPed)
            local model = `cerberus`
            SpawnVehAtCoords(model, targetC, GetEntityHeading(targetPed)); notify_push("Addict", "~p~Spawned on selected")
        elseif it=="Spawn Dump (on selected)" then
            if not selPlayer then notify_push("Addict", "~r~Select player first"); return end
            local targetPed = GetPlayerPed(selPlayer)
            if not DoesEntityExist(targetPed) then return end
            local targetC = GetEntityCoords(targetPed)
            local model = `dump`
            SpawnVehAtCoords(model, targetC, GetEntityHeading(targetPed)); notify_push("Addict", "~p~Spawned on selected")
        elseif it=="Spawn Adder (on selected)" then
            if not selPlayer then notify_push("Addict", "~r~Select player first"); return end
            local targetPed = GetPlayerPed(selPlayer)
            if not DoesEntityExist(targetPed) then return end
            local targetC = GetEntityCoords(targetPed)
            local model = `adder`
            SpawnVehAtCoords(model, targetC, GetEntityHeading(targetPed)); notify_push("Addict", "~p~Spawned on selected")
        elseif it=="Vehicle Rain (on selected)" then
            if not selPlayer then notify_push("Addict", "~r~Select player first"); return end
            local targetPed = GetPlayerPed(selPlayer)
            if not DoesEntityExist(targetPed) then return end
            local targetC = GetEntityCoords(targetPed)
            local vs={"adder","stunt","cargoplane","rumpo2"}
            for i=1,8 do
                local model = GetHashKey(vs[math.random(#vs)])
                SpawnVehAtCoords(model, vector3(targetC.x + math.random(-10,10), targetC.y + math.random(-10,10), targetC.z + math.random(5,15)));
            end
            notify_push("Addict", "~p~Vehicle rain on selected!")
        elseif it=="Franklin Swarm (on selected)" then
            if not selPlayer then notify_push("Addict", "~r~Select player first"); return end
            feat.franklinSwarm = not feat.franklinSwarm
            notify_push("Addict", "Franklin Swarm "..(feat.franklinSwarm and "~p~ON" or "~r~OFF"))
            if feat.franklinSwarm then
                local pid = selPlayer
                Citizen.CreateThread(function()
                    local hash = GetHashKey("player_one")
                    RequestModel(hash)
                    while not HasModelLoaded(hash) do Wait(0) end

                    local davePeds = {}
                    local targetPed = GetPlayerPed(pid)
                    if not DoesEntityExist(targetPed) then feat.franklinSwarm = false; return end
                    local spawnC = GetEntityCoords(targetPed)

                    -- Spawn all 30 peds on exact player coords
                    for i = 1, 16 do
                        local ped = CreatePed(4, hash, spawnC.x, spawnC.y, spawnC.z, 0.0, true, false)
                        if DoesEntityExist(ped) then
                            SetPedAsEnemy(ped, false)
                            SetBlockingOfNonTemporaryEvents(ped, true)
                            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)
                            table.insert(davePeds, ped)
                        end
                        Wait(1)
                    end
                    SetModelAsNoLongerNeeded(hash)

                    -- Continuously teleport to player while toggled on
                    while feat.franklinSwarm do
                        local tp = GetPlayerPed(pid)
                        if DoesEntityExist(tp) then
                            local tc = GetEntityCoords(tp)
                            for _, dp in ipairs(davePeds) do
                                if DoesEntityExist(dp) then
                                    SetEntityCoords(dp, tc.x, tc.y, tc.z, false, false, false, false)
                                end
                            end
                        end
                        Wait(1)
                    end

                    -- Cleanup on toggle off
                    for _, dp in ipairs(davePeds) do
                        if DoesEntityExist(dp) then
                            SetEntityAsMissionEntity(dp, false, true)
                            DeleteEntity(dp)
                        end
                    end
                    davePeds = {}
                end)
            end
        end
    elseif tab_name == "Vehicle" then
        if it=="Repair Vehicle" then
            Citizen.CreateThread(function()
                local veh=GetVehiclePedIsIn(p,false)
                if DoesEntityExist(veh) and net_ctrl(veh) then SetVehicleFixed(veh); SetVehicleDeformationFixed(veh); SetVehicleEngineOn(veh,true,true,false); notify_push("Addict", "~p~Repaired")
                else notify_push("Addict", "~r~Not in a vehicle / no control") end
            end)
        elseif it=="Flip Vehicle" then
            Citizen.CreateThread(function()
                local veh=GetVehiclePedIsIn(p,false)
                if DoesEntityExist(veh) and net_ctrl(veh) then SetVehicleOnGroundProperly(veh); notify_push("Addict", "~p~Flipped")
                else notify_push("Addict", "~r~Not in a vehicle / no control") end
            end)
        elseif it=="Vehicle Godmode (toggle)" then
            feat.vehgod=not feat.vehgod
            Citizen.CreateThread(function()
                local veh=GetVehiclePedIsIn(p,false)
                if DoesEntityExist(veh) and net_ctrl(veh) then SetEntityInvincible(veh,feat.vehgod) end
            end)
            notify_push("Addict", "Veh God "..(feat.vehgod and "~p~ON" or "~r~OFF"))
        elseif it=="Boost Vehicle" then
            Citizen.CreateThread(function()
                local veh=GetVehiclePedIsIn(p,false)
                if DoesEntityExist(veh) and net_ctrl(veh) then local fwd=GetEntityForwardVector(veh); SetEntityVelocity(veh,fwd.x*30,fwd.y*30,fwd.z*30); notify_push("Addict", "~p~Boosted!")
                else notify_push("Addict", "~r~Not in a vehicle / no control") end
            end)
        elseif it=="Max Speed" then
            Citizen.CreateThread(function()
                local veh=GetVehiclePedIsIn(p,false)
                if DoesEntityExist(veh) and net_ctrl(veh) then SetVehicleMaxSpeed(veh,500); notify_push("Addict", "~p~Max speed")
                else notify_push("Addict", "~r~Not in a vehicle / no control") end
            end)
        elseif it=="Clean Vehicle" then
            Citizen.CreateThread(function()
                local veh=GetVehiclePedIsIn(p,false)
                if DoesEntityExist(veh) and net_ctrl(veh) then WashDecalsFromVehicle(veh,1); SetVehicleDirtLevel(veh,0); notify_push("Addict", "~p~Cleaned")
                else notify_push("Addict", "~r~Not in a vehicle / no control") end
            end)
        elseif it=="Lock Vehicle" then
            Citizen.CreateThread(function()
                local veh=GetVehiclePedIsIn(p,false)
                if DoesEntityExist(veh) and net_ctrl(veh) then SetVehicleDoorsLocked(veh,2); notify_push("Addict", "~p~Vehicle locked")
                else notify_push("Addict", "~r~Not in a vehicle / no control") end
            end)
        elseif it=="Unlock Vehicle" then
            Citizen.CreateThread(function()
                local veh=GetVehiclePedIsIn(p,false)
                if DoesEntityExist(veh) and net_ctrl(veh) then SetVehicleDoorsLocked(veh,1); notify_push("Addict", "~p~Vehicle unlocked")
                else notify_push("Addict", "~r~Not in a vehicle / no control") end
            end)
        elseif it=="Teleport All Vehicles" then
            Citizen.CreateThread(function()
                local pos = GetEntityCoords(p)
                local heading = GetEntityHeading(p)
                local myVeh = GetVehiclePedIsIn(p, false)
                local count = 0
                local iter, veh2 = FindFirstVehicle()
                local found = true
                while found do
                    if DoesEntityExist(veh2) and veh2 ~= myVeh then
                        if net_ctrl(veh2, 30) then
                            SetEntityCoords(veh2, pos.x, pos.y, pos.z, false, false, false, true)
                            SetEntityHeading(veh2, heading)
                            count = count + 1
                        end
                    end
                    found, veh2 = FindNextVehicle(iter)
                end
                EndFindVehicle(iter)
                notify_push("Addict", "~p~Teleported " .. count .. " vehicles to you")
            end)
        elseif it=="Spawn Adder" then SpawnVeh(GetHashKey("adder"))
        elseif it=="Spawn Zentorno" then SpawnVeh(GetHashKey("zentorno"))
        elseif it=="Spawn Oppressor Mk2" then SpawnVeh(GetHashKey("oppressor2"))
        elseif it=="Spawn Cargoplane" then SpawnVeh(GetHashKey("cargoplane"))
        elseif it=="Delete Current Vehicle" then
            Citizen.CreateThread(function()
                local veh=GetVehiclePedIsIn(p,false)
                if DoesEntityExist(veh) and net_ctrl(veh) then
                    TaskLeaveVehicle(p,veh,0); Citizen.Wait(500)
                    SetEntityAsMissionEntity(veh,false,true); DeleteEntity(veh)
                    notify_push("Addict", "~p~Deleted")
                else notify_push("Addict", "~r~Not in a vehicle / no control") end
            end)
        elseif it=="Loop Vehicle (toggle)" then
            loopVehSpawn=not loopVehSpawn; notify_push("Addict", "Loop Spawn "..(loopVehSpawn and "~p~ON" or "~r~OFF"))

        elseif it=="Open/Close Hood" then
            Citizen.CreateThread(function()
                local veh = getClosestVehicleNearby(8.0)
                if not veh then notify_push("Addict","~r~No vehicle nearby"); return end
                net_ctrl(veh)
                local angle = GetVehicleDoorAngleRatio(veh, 4)
                if angle > 0.1 then
                    SetVehicleDoorShut(veh, 4, false)
                    notify_push("Addict","~p~Hood closed")
                else
                    SetVehicleDoorOpen(veh, 4, false, false)
                    notify_push("Addict","~p~Hood opened")
                end
            end)

        elseif it=="Steal Engine" then
            Citizen.CreateThread(function()
                local p2 = PlayerPedId()
                local veh = getClosestVehicleNearby(8.0)
                if not veh then notify_push("Addict","~r~No vehicle nearby"); return end
                net_ctrl(veh)
                local offset = GetOffsetFromEntityInWorldCoords(veh, 0.0, 2.5, 0.5)
                local engineObj = loadAndSpawnObject(ENGINE_HASH, offset)
                table.insert(spawnedParts, engineObj)
                SetVehicleEngineHealth(veh, -4000)
                SetVehicleBodyHealth(veh, -4000)
                loadCarryAnim(p2)
                local bone = GetPedBoneIndex(p2, CARRY_BONE_ID)
                AttachEntityToEntity(engineObj, p2, bone, 0.15, 0.0, -0.50, 0.0, 0.0, 0.0, true, true, false, false, 2, true)
                notify_push("Addict","~p~Engine stolen!")
            end)

        elseif it=="Steal All 4 Tyres" then
            Citizen.CreateThread(function()
                local p2 = PlayerPedId()
                local veh = getClosestVehicleNearby(8.0)
                if not veh then notify_push("Addict","~r~No vehicle nearby"); return end
                net_ctrl(veh)
                for _, wi in ipairs({0,1,4,5}) do SetVehicleTyreBurst(veh, wi, true, 1000.0) end
                local vc = GetEntityCoords(veh)
                local sp = vector3(vc.x+2.0, vc.y+2.0, vc.z+0.5)
                local stack = {}
                for i = 1, 4 do
                    local obj = loadAndSpawnObject(TYRE_HASH, sp)
                    table.insert(stack, obj); table.insert(spawnedParts, obj)
                end
                loadCarryAnim(p2)
                local bone = GetPedBoneIndex(p2, CARRY_BONE_ID)
                AttachEntityToEntity(stack[1], p2, bone,      0.30, 0.6, -0.3, 0,0,0, true,true,false,false,2,true)
                AttachEntityToEntity(stack[2], stack[1], 0,   0.0,-0.20, 0.0,  0,0,0, true,true,false,false,2,true)
                AttachEntityToEntity(stack[3], stack[2], 0,   0.0,-0.20, 0.0,  0,0,0, true,true,false,false,2,true)
                AttachEntityToEntity(stack[4], stack[3], 0,   0.0,-0.20, 0.0,  0,0,0, true,true,false,false,2,true)
                notify_push("Addict","~p~4 tyres stolen!")
            end)

        elseif it=="Steal All 4 Wheels" then
            Citizen.CreateThread(function()
                local p2 = PlayerPedId()
                local veh = getClosestVehicleNearby(8.0)
                if not veh then notify_push("Addict","~r~No vehicle nearby"); return end
                net_ctrl(veh)
                for wi = 0, 5 do
                    SetVehicleTyreBurst(veh, wi, true)
                    SetVehicleTyreBurst(veh, wi, true, 1000.0)
                end
                local vc = GetEntityCoords(veh)
                local sp = vector3(vc.x+2.0, vc.y+2.0, vc.z+0.5)
                local stack = {}
                for i = 1, 4 do
                    local obj = loadAndSpawnObject(WHEEL_HASH, sp)
                    table.insert(stack, obj); table.insert(spawnedParts, obj)
                end
                loadCarryAnim(p2)
                local bone = GetPedBoneIndex(p2, CARRY_BONE_ID)
                AttachEntityToEntity(stack[1], p2, bone,      0.30, 0.6, -0.3, 0,0,0, true,true,false,false,2,true)
                AttachEntityToEntity(stack[2], stack[1], 0,   0.0,-0.20, 0.0,  0,0,0, true,true,false,false,2,true)
                AttachEntityToEntity(stack[3], stack[2], 0,   0.0,-0.20, 0.0,  0,0,0, true,true,false,false,2,true)
                AttachEntityToEntity(stack[4], stack[3], 0,   0.0,-0.20, 0.0,  0,0,0, true,true,false,false,2,true)
                notify_push("Addict","~p~4 wheels stolen!")
            end)

        elseif it=="Drop Parts" then
            Citizen.CreateThread(function()
                if #spawnedParts == 0 then notify_push("Addict","~r~No parts to drop"); return end
                local p2 = PlayerPedId()
                for _, part in ipairs(spawnedParts) do
                    if DoesEntityExist(part) then
                        NetworkRequestControlOfEntity(part)
                        local tw = 0
                        while not NetworkHasControlOfEntity(part) and tw < 20 do Citizen.Wait(0); tw = tw + 1 end
                        DetachEntity(part, true, true)
                        ApplyForceToEntity(part, 1, 0.0, 2.0, 0.5, 0.0, 0.0, 0.0, 0, false, true, true, false, true)
                    end
                end
                ClearPedTasks(p2)
                spawnedParts = {}
                notify_push("Addict","~p~Parts dropped")
            end)

        elseif it=="Delete Broken Parts" then
            Citizen.CreateThread(function()
                local p2   = PlayerPedId()
                local pos  = GetEntityCoords(p2)
                local count = 0
                local iter2, obj = FindFirstObject()
                local found2 = true
                while found2 do
                    if DoesEntityExist(obj) then
                        local d = #(GetEntityCoords(obj) - pos)
                        if d <= 15.0 then
                            local m = GetEntityModel(obj)
                            for _, h in ipairs(BROKEN_PART_HASHES) do
                                if m == h then
                                    NetworkRequestControlOfEntity(obj)
                                    local tw = 0
                                    while not NetworkHasControlOfEntity(obj) and tw < 10 do Citizen.Wait(0); tw = tw + 1 end
                                    if NetworkHasControlOfEntity(obj) then
                                        SetEntityAsMissionEntity(obj, false, true)
                                        DeleteEntity(obj)
                                        count = count + 1
                                    end
                                    break
                                end
                            end
                        end
                    end
                    found2, obj = FindNextObject(iter2)
                end
                EndFindObject(iter2)
                notify_push("Addict","~p~Deleted "..count.." broken parts")
            end)
        end
    elseif tab_name == "VehicleSelected" then
        if not selVehicle or not DoesEntityExist(selVehicle) then
            notify_push("Addict", "~r~Select a vehicle from the list first"); return
        end
        local veh = selVehicle

        -- Helper: teleport into the selected vehicle, run action_fn, teleport back
        local function with_veh(action_fn)
            Citizen.CreateThread(function()
                local origin = GetEntityCoords(p)
                net_ctrl(veh, 60)
                SetPedIntoVehicle(p, veh, -1)
                Citizen.Wait(120)
                action_fn(veh)
                Citizen.Wait(80)
                TaskLeaveVehicle(p, veh, 16)
                Citizen.Wait(120)
                SetEntityCoords(p, origin.x, origin.y, origin.z, false, false, false, true)
            end)
        end

        if it == "Teleport Into Selected" then
            net_ctrl(veh, 60)
            SetPedIntoVehicle(p, veh, -1)
            notify_push("Addict", "~p~Entered vehicle")
        elseif it == "Teleport Vehicle To Me" then
            Citizen.CreateThread(function()
                if net_ctrl(veh, 60) then
                    local pos = GetEntityCoords(p)
                    local heading = GetEntityHeading(p)
                    -- Place it 4m in front of the player
                    local headRad = math.rad(heading)
                    local tx = pos.x - math.sin(headRad) * 4.0
                    local ty = pos.y + math.cos(headRad) * 4.0
                    SetEntityCoords(veh, tx, ty, pos.z, false, false, false, true)
                    SetEntityHeading(veh, heading)
                    notify_push("Addict", "~p~Vehicle teleported to you")
                else
                    notify_push("Addict", "~r~Could not get control of vehicle")
                end
            end)
        elseif it == "Repair Selected" then
            with_veh(function(v)
                SetVehicleFixed(v); SetVehicleDeformationFixed(v)
                SetVehicleEngineOn(v, true, true, false)
                notify_push("Addict", "~p~Selected vehicle repaired")
            end)
        elseif it == "Flip Selected" then
            with_veh(function(v)
                SetVehicleOnGroundProperly(v)
                notify_push("Addict", "~p~Selected vehicle flipped")
            end)
        elseif it == "Godmode Selected" then
            selVehGod = not selVehGod
            with_veh(function(v)
                SetEntityInvincible(v, selVehGod)
                notify_push("Addict", "Selected Veh God " .. (selVehGod and "~p~ON" or "~r~OFF"))
            end)
        elseif it == "Max Speed Selected" then
            with_veh(function(v)
                SetVehicleMaxSpeed(v, 500)
                notify_push("Addict", "~p~Max speed set on selected")
            end)
        elseif it == "Boost Selected" then
            with_veh(function(v)
                local fwd = GetEntityForwardVector(v)
                SetEntityVelocity(v, fwd.x*35, fwd.y*35, fwd.z*35)
                notify_push("Addict", "~p~Boosted selected vehicle")
            end)
        elseif it == "Clean Selected" then
            with_veh(function(v)
                WashDecalsFromVehicle(v, 1); SetVehicleDirtLevel(v, 0)
                notify_push("Addict", "~p~Selected vehicle cleaned")
            end)
        elseif it == "Pop Tyres" then
            with_veh(function(v)
                for wi = 0, 5 do
                    SetVehicleTyreBurst(v, wi, true, 1000.0)
                end
                notify_push("Addict", "~p~Tyres popped")
            end)
        elseif it == "Remove Wheels" then
            with_veh(function(v)
                for wi = 0, 5 do
                    BreakOffVehicleWheel(v, wi, false, true, true, false)
                end
                notify_push("Addict", "~p~Wheels removed")
            end)
        elseif it == "Explode Selected" then
            net_ctrl(veh, 60)
            AddExplosion(GetEntityCoords(veh), 7, 10.0, true, false, 1.0)
            notify_push("Addict", "~r~Exploded selected vehicle")
        elseif it == "Delete Selected" then
            net_ctrl(veh, 60)
            SetEntityAsMissionEntity(veh, false, true)
            DeleteEntity(veh)
            selVehicle = nil
            notify_push("Addict", "~p~Deleted selected vehicle")
        end
    elseif tab_name == "Weapon" then
        if it=="Give All Weapons" then
            local ws={"weapon_pistol","weapon_smg","weapon_assaultrifle","weapon_sniperrifle","weapon_rpg","weapon_grenadelauncher","weapon_minigun","weapon_knife"}
            for _,w in pairs(ws) do GiveWeaponToPed(p,GetHashKey(w),9999,false,true) end; notify_push("Addict", "~p~All weapons given")
        elseif it=="Unlimited Ammo (toggle)" then unlimitedAmmo=not unlimitedAmmo; notify_push("Addict", "Unlimited Ammo "..(unlimitedAmmo and "~p~ON" or "~r~OFF"))
        elseif it=="Remove All Weapons" then RemoveAllPedWeapons(p,true); notify_push("Addict", "~p~Weapons removed")
        elseif it=="Explosive Bullets (toggle)" then bulletFlags.explosive=not bulletFlags.explosive; notify_push("Addict", "Explosive Bullets "..(bulletFlags.explosive and "~p~ON" or "~r~OFF"))
        elseif it=="Fire Bullets (toggle)" then bulletFlags.fire=not bulletFlags.fire; notify_push("Addict", "Fire Bullets "..(bulletFlags.fire and "~p~ON" or "~r~OFF"))
        end
    elseif tab_name == "Misc" then
        if it=="Player Blips (toggle)" then feat.playerblips=not feat.playerblips; notify_push("Addict", "Player Blips "..(feat.playerblips and "~p~ON" or "~r~OFF"))
        elseif it=="No Rain (toggle)" then feat.norain=not feat.norain; if feat.norain then SetRainLevel(0); SetWeatherTypeNow("EXTRASUNNY") end; notify_push("Addict", "No Rain "..(feat.norain and "~p~ON" or "~r~OFF"))
        elseif it=="Always Bright (toggle)" then feat.alwaysbright=not feat.alwaysbright; notify_push("Addict", "Always Bright "..(feat.alwaysbright and "~p~ON" or "~r~OFF"))
        elseif it=="Rainbow Menu (toggle)" then feat.rainbow=not feat.rainbow; if not feat.rainbow then cfg.hi={r=180,g=60,b=255,a=255} end; notify_push("Addict", "Rainbow "..(feat.rainbow and "~p~ON" or "~r~OFF"))
        elseif it=="Clear Area Peds" then
            Citizen.CreateThread(function()
                local h,e=FindFirstPed(); local ok
                repeat
                    if DoesEntityExist(e) and e~=p then net_ctrl(e); SetEntityAsMissionEntity(e,false,true); DeleteEntity(e) end
                    ok,e=FindNextPed(h)
                until not ok; EndFindPed(h)
                notify_push("Addict", "~p~Peds cleared")
            end)
        elseif it=="Clear Area Vehicles" then
            Citizen.CreateThread(function()
                local mv=GetVehiclePedIsIn(p,false); local h,e=FindFirstVehicle(); local ok
                repeat
                    if DoesEntityExist(e) and e~=mv then net_ctrl(e); SetEntityAsMissionEntity(e,false,true); DeleteEntity(e) end
                    ok,e=FindNextVehicle(h)
                until not ok; EndFindVehicle(h)
                notify_push("Addict", "~p~Vehicles cleared")
            end)
        elseif it=="Time: Midnight" then NetworkOverrideClockTime(0,0,0); notify_push("Addict", "~p~Midnight")
        elseif it=="Time: Noon" then NetworkOverrideClockTime(12,0,0); notify_push("Addict", "~p~Noon")
        elseif it=="Weather: Clear" then SetWeatherTypeNow("EXTRASUNNY"); notify_push("Addict", "~p~Clear")
        elseif it=="Weather: Thunder" then SetWeatherTypeNow("THUNDER"); notify_push("Addict", "~p~Thunder")
        elseif it=="Low Gravity (toggle)" then lowgrav=not lowgrav; SetGravityLevel(lowgrav and 1 or 0); notify_push("Addict", "Low Gravity "..(lowgrav and "~p~ON" or "~r~OFF"))
        elseif it=="Meteor Shower" then Chaos.meteors=not Chaos.meteors; notify_push("Addict", "Meteor Shower "..(Chaos.meteors and "~p~ON" or "~r~OFF"))
        elseif it=="Lightning Storm" then Chaos.lightning=not Chaos.lightning; notify_push("Addict", "Lightning "..(Chaos.lightning and "~p~ON" or "~r~OFF"))
        elseif it=="Force Field" then Chaos.forcefield=not Chaos.forcefield; notify_push("Addict", "Force Field "..(Chaos.forcefield and "~p~ON" or "~r~OFF"))
        elseif it=="Teleport" then
            local blip=GetFirstBlipInfoId(8)
            if DoesBlipExist(blip) then local co=GetBlipInfoIdCoord(blip); SetEntityCoords(p,co.x,co.y,co.z+2,false,false,false,true)
            else SetEntityCoords(p,c.x+math.random(-100,100),c.y+math.random(-100,100),c.z,false,false,false,true) end; notify_push("Addict", "~p~Teleported")
        elseif it=="Time Warp" then Chaos.timewarp=not Chaos.timewarp; notify_push("Addict", "Time Warp "..(Chaos.timewarp and "~p~ON" or "~r~OFF"))
        elseif it=="Random Weapon Drop" then
            local ws={"WEAPON_PISTOL","WEAPON_SPECIALCARBINE","WEAPON_SPECIALCARBINE_MK2"}
            GiveWeaponToPed(p,GetHashKey(ws[math.random(#ws)]),100,false,true); notify_push("Addict", "~p~Weapon given")
        elseif it=="Heal Player" then SetEntityHealth(p,GetEntityMaxHealth(p)); SetPedArmour(p,100); notify_push("Addict", "~p~Healed")
        elseif it=="Give Weapon" then
            DisplayOnscreenKeyboard(1,"FMMC_KEY_TIP1","","","","","",50)
            while UpdateOnscreenKeyboard()==0 do Wait(0) end
            local res=GetOnscreenKeyboardResult(); if res and tonumber(res) then GiveWeaponToPed(p,tonumber(res),100,false,true) end
        elseif it=="Spawn Animal" then
            local as={"a_c_chimp","a_c_cow","a_c_deer","a_c_fish","a_c_hen","a_c_killerwhale"}
            SpawnPed(GetHashKey(as[math.random(#as)]),c.x+1,c.y+1,c.z); notify_push("Addict", "~p~Animal spawned")
        elseif it=="Weather Cycle" then World.weathercycle=not World.weathercycle; notify_push("Addict", "Weather Cycle "..(World.weathercycle and "~p~ON" or "~r~OFF"))
        elseif it=="Change Time" then World.changetime=not World.changetime; notify_push("Addict", "Change Time "..(World.changetime and "~p~ON" or "~r~OFF"))
        elseif it=="Explode Nearby Vehicles" then
            local h,e=FindFirstVehicle(); local ok
            repeat if DoesEntityExist(e) then local pos=GetEntityCoords(e); AddExplosion(pos.x,pos.y,pos.z,29,1,true,false,2) end; ok,e=FindNextVehicle(h) until not ok; EndFindVehicle(h); notify_push("Addict", "~r~Boom!")
        elseif it=="Pull All Animals" then
            Citizen.CreateThread(function()
                local h,e=FindFirstPed(); local ok
                repeat
                    if DoesEntityExist(e) and e~=p then net_ctrl(e); SetEntityCoords(e,c.x,c.y,c.z,false,false,false,true) end
                    ok,e=FindNextPed(h)
                until not ok; EndFindPed(h)
                notify_push("Addict", "~p~Pulled")
            end)
        elseif it=="Explosion Loop" then Chaos.explosionloop=not Chaos.explosionloop; notify_push("Addict", "Explosion Loop "..(Chaos.explosionloop and "~p~ON" or "~r~OFF"))
        elseif it=="Random Teleport" then
            SetEntityCoords(p,c.x+math.random(-50,50),c.y+math.random(-50,50),c.z+math.random(0,30),false,false,false,true); notify_push("Addict", "~p~Random teleport")
        elseif it=="Low Gravity (WG)" then World.lowgrav=not World.lowgrav; SetGravityLevel(World.lowgrav and 1 or 0); notify_push("Addict", "Low Gravity "..(World.lowgrav and "~p~ON" or "~r~OFF"))
        elseif it=="Chaos Physics" then SetEntityMaxSpeed(p,100); SetEntityMaxHealth(p,1000); notify_push("Addict", "~p~Chaos physics")
        elseif it=="Flying Cars" then
            Citizen.CreateThread(function()
                local h,e=FindFirstVehicle(); local ok
                repeat
                    if DoesEntityExist(e) and net_ctrl(e) then SetVehicleForwardSpeed(e,100); SetEntityVelocity(e,0,0,2) end
                    ok,e=FindNextVehicle(h)
                until not ok; EndFindVehicle(h)
                notify_push("Addict", "~p~Flying cars!")
            end)
        elseif it=="Random Vehicle Spawn" then
            local vs={"adder","stunt","cargoplane","rumpo2"}
            for i=1,math.random(3,6) do SpawnVehRaw(GetHashKey(vs[math.random(#vs)])) end; notify_push("Addict", "~p~Spawned")
        elseif it=="Dimension Shift" then Chaos.dimensionshift=not Chaos.dimensionshift; notify_push("Addict", "Dimension Shift "..(Chaos.dimensionshift and "~p~ON" or "~r~OFF"))
        elseif it=="Super Speed" then Powers.superspeed=not Powers.superspeed; notify_push("Addict", "Super Speed "..(Powers.superspeed and "~p~ON" or "~r~OFF"))
        elseif it=="Night Vision" then Visuals.nightvision=not Visuals.nightvision; SetNightvision(Visuals.nightvision); notify_push("Addict", "Night Vision "..(Visuals.nightvision and "~p~ON" or "~r~OFF"))
        elseif it=="Thermal Vision" then Visuals.thermalvision=not Visuals.thermalvision; SetSeethrough(Visuals.thermalvision); notify_push("Addict", "Thermal Vision "..(Visuals.thermalvision and "~p~ON" or "~r~OFF"))
        elseif it=="Tornado" then World.tornado=not World.tornado; notify_push("Addict", "Tornado "..(World.tornado and "~p~ON" or "~r~OFF"))
        elseif it=="Hurricane" then World.hurricane=not World.hurricane; notify_push("Addict", "Hurricane "..(World.hurricane and "~p~ON" or "~r~OFF"))
        elseif it=="Vehicle Teleport" then
            Citizen.CreateThread(function()
                local h,e=FindFirstVehicle(); local ok
                repeat
                    if DoesEntityExist(e) and net_ctrl(e) then SetEntityCoords(e,c.x,c.y,c.z,false,false,false,true) end
                    ok,e=FindNextVehicle(h)
                until not ok; EndFindVehicle(h)
                notify_push("Addict", "~p~Vehicles teleported")
            end)
        elseif it=="Vehicle Spawn Wave" then
            local vs={"adder","stunt","cargoplane","rumpo2","cerberus","dump"}
            DisplayOnscreenKeyboard(1,"FMMC_KEY_TIP1","","","","","",10)
            while UpdateOnscreenKeyboard()==0 do Wait(0) end
            local n=tonumber(GetOnscreenKeyboardResult()) or 5
            for i=1,n do SpawnVehRaw(GetHashKey(vs[math.random(#vs)])) end
        elseif it=="Ped Teleport" then
            Citizen.CreateThread(function()
                local h,e=FindFirstPed(); local ok
                repeat
                    if DoesEntityExist(e) and e~=p and net_ctrl(e) then SetEntityCoords(e,c.x,c.y,c.z,false,false,false,true) end
                    ok,e=FindNextPed(h)
                until not ok; EndFindPed(h)
                notify_push("Addict", "~p~Peds teleported")
            end)
        elseif it=="Ped Spawn Wave" then
            local peds={"a_m_m_skater_01","a_f_y_hipster_01","a_m_o_tramp_01","a_f_y_soucentral_01"}
            DisplayOnscreenKeyboard(1,"FMMC_KEY_TIP1","","","","","",10)
            while UpdateOnscreenKeyboard()==0 do Wait(0) end
            local n=tonumber(GetOnscreenKeyboardResult()) or 5
            for i=1,n do SpawnPed(GetHashKey(peds[math.random(#peds)]),c.x+math.random(-5,5),c.y+math.random(-5,5),c.z) end
        elseif it=="New Vehicle 2" then SpawnVehRaw(`stunt`)
        elseif it=="Random Ped Spawn" then
            local ms={`a_m_m_skater_01`,`a_f_y_hipster_01`,`a_m_o_tramp_01`}
            SpawnPed(ms[math.random(#ms)],c.x+math.random(-5,5),c.y+math.random(-5,5),c.z); notify_push("Addict", "~p~Ped spawned")
        elseif it=="Ultra Fast Ped Spawn" then
            for i=1,20 do SpawnPed(`a_m_m_skater_01`,c.x+math.random(-10,10),c.y+math.random(-10,10),c.z) end; notify_push("Addict", "~p~20 peds")
        elseif it=="Mega Ped Spawn" then
            for i=1,50 do SpawnPed(`a_m_m_skater_01`,c.x+math.random(-20,20),c.y+math.random(-20,20),c.z) end; notify_push("Addict", "~p~50 peds")
        elseif it=="Random Explosions" then
            for i=1,10 do AddExplosion(c.x+math.random(-30,30),c.y+math.random(-30,30),c.z+math.random(0,10),29,5,true,false,2) end; notify_push("Addict", "~r~Boom!")
        elseif it=="Firework Loop" then
            Citizen.CreateThread(function() for i=1,20 do AddExplosion(c.x+math.random(-20,20),c.y+math.random(-20,20),c.z+math.random(5,15),9,1,true,false,1); Wait(300) end end); notify_push("Addict", "~p~Fireworks!")
        elseif it=="Mass Ped Knockup" then
            Citizen.CreateThread(function()
                local h,e=FindFirstPed(); local ok
                repeat
                    if DoesEntityExist(e) and e~=p and net_ctrl(e) then ApplyForceToEntity(e,1,0,0,20,0,0,0,true,true,true,true,false) end
                    ok,e=FindNextPed(h)
                until not ok; EndFindPed(h)
                notify_push("Addict", "~p~Launched!")
            end)
        elseif it=="Sticky Bomb Rain" then
            for i=1,20 do CreateObject(GetHashKey("prop_cs_coke_block_01"),c.x+math.random(-20,20),c.y+math.random(-20,20),c.z+30,true,true,false) end; notify_push("Addict", "~p~Bombs!")
        elseif it=="Confetti Rain" then
            Citizen.CreateThread(function() for i=1,30 do AddExplosion(c.x+math.random(-15,15),c.y+math.random(-15,15),c.z+math.random(10,25),9,0.1,false,false,0.5); Wait(200) end end)
        elseif it=="Laser Show" then
            Citizen.CreateThread(function() for i=1,30 do DrawLine(c.x,c.y,c.z,c.x+math.random(-50,50),c.y+math.random(-50,50),c.z+math.random(10,40),math.random(255),math.random(255),math.random(255),255); Wait(100) end end)
        elseif it=="Clone Me" then
            local ped=SpawnPed(`a_m_m_skater_01`,c.x+1,c.y+1,c.z)
            if ped then SetPedAsGroupMember(ped,GetPedGroupIndex(p)); notify_push("Addict", "~p~Clone created") end
        elseif it=="Clone Army" then
            DisplayOnscreenKeyboard(1,"FMMC_KEY_TIP1","","","","","",10)
            while UpdateOnscreenKeyboard()==0 do Wait(0) end
            local amt=tonumber(GetOnscreenKeyboardResult()) or 5
            for i=1,amt do SpawnPed(`a_m_m_skater_01`,c.x+math.random(-5,5),c.y+math.random(-5,5),c.z) end
            notify_push("Addict", "~p~Clone army deployed")
        elseif it=="Freeze Peds (toggle)" then PedCtrl.freeze=not PedCtrl.freeze; notify_push("Addict", "Freeze Peds "..(PedCtrl.freeze and "~p~ON" or "~r~OFF"))
        elseif it=="Launch Peds" then
            Citizen.CreateThread(function()
                local h,e=FindFirstPed(); local ok
                repeat
                    if DoesEntityExist(e) and e~=p and net_ctrl(e) then ApplyForceToEntity(e,1,0,0,50,0,0,0,true,true,true,true,false) end
                    ok,e=FindNextPed(h)
                until not ok; EndFindPed(h)
                notify_push("Addict", "~p~Launched!")
            end)
        elseif it=="Ragdoll Loop (toggle)" then PedCtrl.ragdoll=not PedCtrl.ragdoll; notify_push("Addict", "Ragdoll Loop "..(PedCtrl.ragdoll and "~p~ON" or "~r~OFF"))
        end
    elseif tab_name == "World" then
        if it=="Clear Area" then
            local p   = PlayerPedId()
            local pos = GetEntityCoords(p)
            local r   = clearArea_radius

            -- Run in a thread so we can yield while requesting network control
            Citizen.CreateThread(function()
                local del_peds, del_vehs, del_objs = 0, 0, 0

                local function net_delete(ent)
                    if not DoesEntityExist(ent) then return false end
                    -- Request ownership so the server lets us delete it
                    if NetworkGetEntityIsNetworked(ent) then
                        NetworkRequestControlOfEntity(ent)
                        local t = 0
                        while not NetworkHasControlOfEntity(ent) and t < 30 do
                            Citizen.Wait(0); t = t + 1
                        end
                    end
                    if DoesEntityExist(ent) then
                        SetEntityAsMissionEntity(ent, false, true)
                        DeleteEntity(ent)
                        return true
                    end
                    return false
                end

                -- ── Delete vehicles ──────────────────────────────────────
                local hv, ev = FindFirstVehicle(); local ok3
                repeat
                    if DoesEntityExist(ev) then
                        local inVeh = GetVehiclePedIsIn(p, false)
                        if ev ~= inVeh then
                            if #(pos - GetEntityCoords(ev)) <= r then
                                if net_delete(ev) then del_vehs = del_vehs + 1 end
                            end
                        end
                    end
                    ok3, ev = FindNextVehicle(hv)
                until not ok3
                EndFindVehicle(hv)

                -- ── Delete peds ──────────────────────────────────────────
                local h, e = FindFirstPed(); local ok2
                repeat
                    if DoesEntityExist(e) and e ~= p then
                        if #(pos - GetEntityCoords(e)) <= r then
                            if net_delete(e) then del_peds = del_peds + 1 end
                        end
                    end
                    ok2, e = FindNextPed(h)
                until not ok2
                EndFindPed(h)

                -- ── Delete objects / props ───────────────────────────────
                local ho, eo = FindFirstObject(); local ok4
                repeat
                    if DoesEntityExist(eo) then
                        if #(pos - GetEntityCoords(eo)) <= r then
                            if net_delete(eo) then del_objs = del_objs + 1 end
                        end
                    end
                    ok4, eo = FindNextObject(ho)
                until not ok4
                EndFindObject(ho)

                notify_push("Addict",
                    string.format("~p~Cleared!~n~~w~Vehs: %d  Peds: %d  Objects: %d",
                    del_vehs, del_peds, del_objs))
            end)

        elseif it=="Freeze Time (toggle)" then World.freeze=not World.freeze; notify_push("Addict", "Freeze Time "..(World.freeze and "~p~ON" or "~r~OFF"))
        elseif it=="Slow Motion (toggle)" then World.slowmo=not World.slowmo; notify_push("Addict", "Slow Motion "..(World.slowmo and "~p~ON" or "~r~OFF"))
        elseif it=="Clear Weather" then SetWeatherTypeNow("EXTRASUNNY"); notify_push("Addict", "~p~Clear weather")
        elseif it=="Storm Weather" then SetWeatherTypeNow("THUNDER"); notify_push("Addict", "~p~Storm")
        elseif it=="Low Gravity (WC)" then World.lowgrav=not World.lowgrav; SetGravityLevel(World.lowgrav and 1 or 0); notify_push("Addict", "Low Gravity "..(World.lowgrav and "~p~ON" or "~r~OFF"))
        elseif it=="Earthquake (toggle)" then World.earthquake=not World.earthquake; notify_push("Addict", "Earthquake "..(World.earthquake and "~p~ON" or "~r~OFF"))
        elseif it=="Tornado (WC)" then World.tornado=not World.tornado; notify_push("Addict", "Tornado "..(World.tornado and "~p~ON" or "~r~OFF"))
        elseif it=="Hurricane (WC)" then World.hurricane=not World.hurricane; notify_push("Addict", "Hurricane "..(World.hurricane and "~p~ON" or "~r~OFF"))
        elseif it=="Weather Cycle (toggle)" then World.weathercycle=not World.weathercycle; notify_push("Addict", "Weather Cycle "..(World.weathercycle and "~p~ON" or "~r~OFF"))
        elseif it=="Change Time (toggle)" then World.changetime=not World.changetime; notify_push("Addict", "Change Time "..(World.changetime and "~p~ON" or "~r~OFF"))
        elseif it=="Ped Markers (toggle)" then Visuals.peds=not Visuals.peds; notify_push("Addict", "Ped Markers "..(Visuals.peds and "~p~ON" or "~r~OFF"))
        elseif it=="Vehicle Markers (toggle)" then Visuals.vehicles=not Visuals.vehicles; notify_push("Addict", "Vehicle Markers "..(Visuals.vehicles and "~p~ON" or "~r~OFF"))
        elseif it=="Distance Text (toggle)" then Visuals.text=not Visuals.text; notify_push("Addict", "Distance Text "..(Visuals.text and "~p~ON" or "~r~OFF"))
        elseif it=="Snap Lines (toggle)" then Visuals.lines=not Visuals.lines; notify_push("Addict", "Snap Lines "..(Visuals.lines and "~p~ON" or "~r~OFF"))
        elseif it=="Radius +" then Visuals.radius=Visuals.radius+10; notify_push("Addict", "Radius: "..Visuals.radius)
        elseif it=="Radius -" then Visuals.radius=math.max(10,Visuals.radius-10); notify_push("Addict", "Radius: "..Visuals.radius)
        elseif it=="Clear Visuals" then Visuals.peds=false; Visuals.vehicles=false; Visuals.text=false; Visuals.lines=false; notify_push("Addict", "~p~Visuals cleared")
        elseif it=="ESP (toggle)" then feat.esp=not feat.esp; notify_push("Addict", "ESP "..(feat.esp and "~p~ON" or "~r~OFF"))
        elseif it=="Random Teleport" then
            local p = PlayerPedId()
            -- Pick a random named location from a curated list of GTA V coords
            local locations = {
                {x=  -75.0, y= -819.0, z=  326.0, name="Maze Bank Tower"},
                {x= -560.0, y= 5323.0, z=  76.0,  name="Sandy Shores"},
                {x=  203.0, y=-1008.0, z=  29.0,  name="Del Perro Pier"},
                {x=-1821.0, y= 3688.0, z=  34.0,  name="Paleto Bay"},
                {x=  385.0, y=-1968.0, z=  24.0,  name="LSIA Airport"},
                {x= -330.0, y=  618.0, z= 168.0,  name="Vinewood Hills"},
                {x= 2005.0, y= 3773.0, z=  32.0,  name="Grapeseed"},
                {x= -710.0, y=-1430.0, z=   5.0,  name="Vespucci Beach"},
                {x=  934.0, y= -408.0, z=  68.0,  name="Vinewood Sign"},
                {x=  134.0, y= 6648.0, z=  32.0,  name="North Chumash"},
                {x=-3192.0, y= 1100.0, z=  20.0,  name="Chumash Pier"},
                {x=  445.0, y= 5607.0, z=  36.0,  name="Alamo Sea"},
                {x=-1093.0, y= 4920.0, z=  219.0, name="Mount Chiliad Peak"},
                {x= 2673.0, y= 1548.0, z=  24.0,  name="Tataviam Mountains"},
                {x= -988.0, y= -280.0, z=  38.0,  name="Little Seoul"},
            }
            local loc = locations[math.random(#locations)]
            local ok, gz = GetGroundZFor_3dCoord(loc.x, loc.y, 1000.0, false)
            SetEntityCoords(PlayerPedId(), loc.x, loc.y, ok and gz or loc.z, false, false, false, true)
            notify_push("Addict", "~p~Teleported to " .. loc.name)
        elseif it=="Entity Throttler (toggle)" then
            feat.entityThrottler = not feat.entityThrottler
            notify_push("Addict", "Entity Throttler "..(feat.entityThrottler and "~p~ON" or "~r~OFF"))
        end
    end
end

local last_open_press = 0

Citizen.CreateThread(function()
    local screen_w, screen_h = GetActiveScreenResolution()
    reset_particles()

    while true do
        Citizen.Wait(0)

        screen_w, screen_h = GetActiveScreenResolution()
        local dt = GetFrameTime()

        local m_x = GetControlNormal(2, 239) * screen_w
        local m_y = GetControlNormal(2, 240) * screen_h

        if state.open then
            SetMouseCursorActiveThisFrame()

            if not state.ui.binding_open_key then
                DisableAllControlActions(0)
                DisableAllControlActions(1)
            end

            EnableControlAction(0, cfg.open_key, true)
            EnableControlAction(1, cfg.open_key, true)
            EnableControlAction(2, 239, true)
            EnableControlAction(2, 240, true)
            EnableControlAction(2, 237, true)
            EnableControlAction(2, 238, true)
            EnableControlAction(2, 241, true)
            EnableControlAction(2, 242, true)
        end

        if state.open and state.ui.binding_open_key then
            for control = 1, 356 do
                if IsControlJustPressed(0, control) and control ~= 237 and control ~= 238 then  -- Exclude mouse buttons
                    cfg.open_key = control
                    state.ui.binding_open_key = false
                    notify_push("Addict", "Open key set to: " .. control_name(control))
                    break
                end
            end
        end

        if key_just_pressed(cfg.open_key) and GetGameTimer() - last_open_press > 500 then
            last_open_press = GetGameTimer()
            state.open = not state.open
            state.dragging = false
            state.ui.active_slider = nil
            state.ui.settings_dragging = false
            state.ui.scrollbar_dragging = false
            state.ui.wheel_accum = 0.0
            state.ui.binding_open_key = false
            state.ui.prev_control_down = {}

            if not state.open then
                state.ui.settings_scroll = 0.0
                state.inPlayerList = false
            else
                reset_particles()
            end
        end

        local wheel_off = 0.0
        if IsControlJustReleased(2, 241) then wheel_off = wheel_off - 1.0 end
        if IsControlJustReleased(2, 242) then wheel_off = wheel_off + 1.0 end

        if state.open and hit(state.ui.settings_area.x, state.ui.settings_area.y, state.ui.settings_area.w, state.ui.settings_area.h, m_x, m_y) and not state.ui.scrollbar_dragging and state.ui.active_slider == nil then
            state.ui.wheel_accum = state.ui.wheel_accum + wheel_off
        end

        if state.open and cfg.overlay_enabled then
            update_drag(screen_w, screen_h, m_x, m_y)
            draw_overlay(dt, screen_w, screen_h)
        else
            state.ui.active_slider = nil
            state.ui.settings_dragging = false
            state.ui.scrollbar_dragging = false
            state.ui.wheel_accum = 0.0
            state.ui.binding_open_key = false
            state.ui.prev_control_down = {}
        end

        -- Always-on spectator HUD (outside menu)
        draw_spectator_hud(screen_w, screen_h, dt, m_x, m_y)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local p=PlayerPedId(); local pid=PlayerId()
        if feat.godmode then SetEntityInvincible(p,true) end
        if feat.noragdoll then SetPedCanRagdoll(p,false) end
        if feat.stamina then RestorePlayerStamina(pid,1.0) end
        if feat.superrun then SetRunSprintMultiplierForPlayer(pid,1.49) end
        if feat.superjump then SetSuperJumpThisFrame(pid) end
        if feat.invisible then SetEntityVisible(p,false,false); SetEntityAlpha(p,0,false) end
        if feat.nocriticals then SetPlayerMayNotEnterWater(pid,true) end
        if unlimitedAmmo then local w=GetSelectedPedWeapon(p); if w~=0 then SetPedAmmo(p,w,9999) end end
        if bulletFlags.explosive then SetExplosiveAmmoThisFrame(pid) end
        if bulletFlags.fire then SetFireAmmoThisFrame(pid) end
        if noclipActive then HandleNoclip()
        elseif not feat.freecam then SetEntityCollision(p,true,true); FreezeEntityPosition(p,false) end
        if feat.vehgod then local veh=GetVehiclePedIsIn(p,false); if DoesEntityExist(veh) then SetEntityInvincible(veh,true) end end
        if feat.alwaysbright then SetArtificialLightsState(false) end
        if feat.norain then SetRainLevel(0) end
        if feat.playerblips then UpdateBlips() elseif next(blipMap) then ClearBlips() end
        if feat.esp then DrawESP() end
        if feat.spectate then
            local target = GetPlayerPed(selPlayer)
            if DoesEntityExist(target) then
                DisableAllControlActions(0)
                EnableControlAction(0, 1, true) -- look left/right
                EnableControlAction(0, 2, true) -- look up/down
                EnableControlAction(0, 178, true) -- DEL for menu
                -- Look input
                local rotX = GetDisabledControlNormal(0, 2) * -15.0
                local rotZ = GetDisabledControlNormal(0, 1) * -15.0
                specRot = specRot + vector3(rotX, 0.0, rotZ)
                specRot = vector3(clamp(specRot.x, -89.0, 89.0), 0.0, specRot.z)
                -- Zoom
                if IsControlPressed(0, 241) then specDistance = math.max(1.0, specDistance - 0.5) end
                if IsControlPressed(0, 242) then specDistance = specDistance + 0.5 end
                -- Update position
                local targetPos = GetEntityCoords(target)
                local camDir = RotationToDirection(specRot)
                specPos = targetPos - camDir * specDistance
                SetCamCoord(spectateCam, specPos)
                SetCamRot(spectateCam, specRot, 2)
            else
                feat.spectate = false
                RenderScriptCams(false, true, 500, true, true)
                if spectateCam ~= nil then
                    SetCamActive(spectateCam, false)
                    DestroyCam(spectateCam, true)
                    spectateCam = nil
                end
                SetEntityVisible(p, true, false)
                SetEntityCollision(p, true, true)
                specPos = nil
                specRot = nil
                specDistance = 5.0
            end
        end
        local c=GetEntityCoords(p)
        if Powers.stamina then RestorePlayerStamina(pid,1.0) end
        if Powers.noragdoll then SetPedCanRagdoll(p,false) end
        if Powers.invis then SetEntityVisible(p,false,false); SetEntityAlpha(p,0,false) end
        if Powers.fastrun then SetRunSprintMultiplierForPlayer(pid,1.49) end
        if Powers.superjump then SetSuperJumpThisFrame(pid) end
        if Powers.god then SetEntityInvincible(p,true) end
        if Powers.superstrength then
            SetPedSuffersCriticalHits(p, false)
            SetPlayerMeleeWeaponDamageModifier(pid, 10.0)
            SetPlayerMeleeWeaponDefenseModifier(pid, 10.0)
        else
            SetPlayerMeleeWeaponDamageModifier(pid, 1.0)
            SetPlayerMeleeWeaponDefenseModifier(pid, 1.0)
        end
        if Powers.superspeed then local veh=GetVehiclePedIsIn(p,false); if DoesEntityExist(veh) then SetVehicleMaxSpeed(veh,500) end end
        if World.freeze then FreezeEntityPosition(p,true) end
        if World.slowmo then SetTimeScale(0.4) else SetTimeScale(1.0) end
        SetGravityLevel((World.lowgrav or lowgrav) and 1 or 0)
        if World.earthquake then ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.3) end
        if World.tornado then
            local h,e=FindFirstPed(); local ok
            repeat
                if DoesEntityExist(e) and e~=p then local pos=GetEntityCoords(e)
                    if #(c-pos)<50 then ApplyForceToEntity(e,1,math.random(-2,2),math.random(-2,2),2,0,0,0,true,true,true,true,false) end
                end; ok,e=FindNextPed(h)
            until not ok; EndFindPed(h)
        end
        if World.hurricane then
            SetWeatherTypeNow("THUNDER")
            local h,e=FindFirstVehicle(); local ok
            repeat if DoesEntityExist(e) then ApplyForceToEntity(e,1,math.random(-5,5),math.random(-5,5),3,0,0,0,true,true,true,true,false) end; ok,e=FindNextVehicle(h) until not ok; EndFindVehicle(h)
        end
        if World.changetime then SetClockTime(GetClockHours()<12 and 12 or 0,0,0) end
        if Chaos.forcefield then ApplyForceField(50) end
        if Chaos.meteors then AddExplosion(c.x+math.random(-40,40),c.y+math.random(-40,40),c.z+math.random(25,45),29,10,true,false,2); Wait(150) end
        if Chaos.lightning then AddExplosion(c.x+math.random(-50,50),c.y+math.random(-50,50),c.z+50,9,1,true,false,0.5); Wait(1000) end
        if Chaos.explosionloop then AddExplosion(c.x+math.random(-20,20),c.y+math.random(-20,20),c.z+math.random(10,20),29,10,true,false,2); Wait(500) end
        if Chaos.timewarp then SetTimeScale(math.random(1,10)/10); Wait(2000) end
        if Chaos.dimensionshift then SetEntityCoords(p,c.x+math.random(-5,5),c.y+math.random(-5,5),c.z,false,false,false,true); Wait(3000) end
        if PedCtrl.freeze then
            local h,e=FindFirstPed(); local ok
            repeat
                if DoesEntityExist(e) and e~=p then net_ctrl(e,10); FreezeEntityPosition(e,true) end
                ok,e=FindNextPed(h)
            until not ok; EndFindPed(h)
        end
        if PedCtrl.ragdoll then
            local h,e=FindFirstPed(); local ok
            repeat
                if DoesEntityExist(e) and e~=p then net_ctrl(e,10); SetPedCanRagdoll(e,true); SetPedToRagdoll(e,2000,2000,0,false,false,false) end
                ok,e=FindNextPed(h)
            until not ok; EndFindPed(h); Wait(500)
        end
        if Visuals.peds then
            local h,e=FindFirstPed(); local ok
            repeat if DoesEntityExist(e) and e~=p then local pos=GetEntityCoords(e); local dist=#(c-pos); if dist<Visuals.radius then DrawText3D(pos.x,pos.y,pos.z+1,"PED ["..math.floor(dist).."m]") end end; ok,e=FindNextPed(h) until not ok; EndFindPed(h)
        end
        if Visuals.vehicles then
            local h,e=FindFirstVehicle(); local ok
            repeat if DoesEntityExist(e) then local pos=GetEntityCoords(e); local dist=#(c-pos); if dist<Visuals.radius then DrawText3D(pos.x,pos.y,pos.z+1,"VEH ["..math.floor(dist).."m]") end end; ok,e=FindNextVehicle(h) until not ok; EndFindVehicle(h)
        end
        if loopVehSpawn then
            local vs={"adder","stunt","cargoplane","rumpo2","cerberus","dump"}
            SpawnVehRaw(GetHashKey(vs[math.random(#vs)])); Wait(3000)
        end
        if feat.vortex then
            local vortex_ped = p
            if vortex_target then
                vortex_ped = GetPlayerPed(vortex_target)
                if not DoesEntityExist(vortex_ped) then
                    feat.vortex = false
                    vortex_target = nil
                    notify_push("Addict", "~r~Target lost, Vortex OFF")
                end
            end
            local pc = GetEntityCoords(vortex_ped)
            local playerVeh = GetVehiclePedIsIn(vortex_ped, false)
            -- For vehicles
            local h,e=FindFirstVehicle(); local ok
            repeat
                if DoesEntityExist(e) and e ~= playerVeh then
                    local pos=GetEntityCoords(e)
                    local dir = pc - pos
                    local dist = #dir
                    if dist > 0.1 and dist < 50 then
                        net_ctrl(e, 8)
                        dir = dir / dist
                        local radial_force = dir * (50 / dist)
                        local tang = vector3(-dir.y, dir.x, 0)
                        local tang_force = tang * 5
                        local up_force = vector3(0,0,1) * 2
                        ApplyForceToEntity(e, 1, radial_force.x, radial_force.y, radial_force.z + up_force.z, 0,0,0, true, true, true, true, false)
                        ApplyForceToEntity(e, 1, tang_force.x, tang_force.y, tang_force.z, 0,0,0, true, true, true, true, false)
                    end
                end
                ok,e=FindNextVehicle(h)
            until not ok
            EndFindVehicle(h)
            -- For props
            local h2,e2=FindFirstObject(); local ok2
            repeat
                if DoesEntityExist(e2) then
                    local pos=GetEntityCoords(e2)
                    local dir = pc - pos
                    local dist = #dir
                    if dist > 0.1 and dist < 50 then
                        net_ctrl(e2, 8)
                        dir = dir / dist
                        local radial_force = dir * (50 / dist)
                        local tang = vector3(-dir.y, dir.x, 0)
                        local tang_force = tang * 5
                        local up_force = vector3(0,0,1) * 2
                        ApplyForceToEntity(e2, 1, radial_force.x, radial_force.y, radial_force.z + up_force.z, 0,0,0, true, true, true, true, false)
                        ApplyForceToEntity(e2, 1, tang_force.x, tang_force.y, tang_force.z, 0,0,0, true, true, true, true, false)
                    end
                end
                ok2,e2=FindNextObject(h2)
            until not ok2
            EndFindObject(h2)
        end
    end
end)

-- Freecam thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local p = PlayerPedId()
        if feat.freecam then
            if freecam_cam == nil then
                local coords = GetEntityCoords(p)
                local heading = GetEntityHeading(p)
                local headRad = math.rad(heading)
                local startX = coords.x + math.sin(headRad) * 3.0
                local startY = coords.y - math.cos(headRad) * 3.0
                local startZ = coords.z + 1.5
                SetEntityInvincible(p, true)
                SetEntityCollision(p, false, false)
                FreezeEntityPosition(p, true)
                freecam_cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
                SetCamCoord(freecam_cam, startX, startY, startZ)
                SetCamRot(freecam_cam, -15.0, 0.0, -heading, 2)
                SetCamActive(freecam_cam, true)
                RenderScriptCams(true, false, 0, true, false)
                DisplayRadar(false)
                DisplayHud(false)
                freecam_ready = false  -- block actions until next frame
            else
                freecam_ready = true   -- safe to accept inputs from second frame onward
            end
            local camCoords = GetCamCoord(freecam_cam)
            local right, forward, up, at = GetCamMatrix(freecam_cam)
            local speed = 0.5
            if IsControlPressed(0, 21) then speed = 2.5 end -- SHIFT
            if IsControlPressed(0, 32) then camCoords = camCoords + forward * speed end -- W
            if IsControlPressed(0, 33) then camCoords = camCoords - forward * speed end -- S
            if IsControlPressed(0, 34) then camCoords = camCoords - right * speed end   -- A
            if IsControlPressed(0, 35) then camCoords = camCoords + right * speed end   -- D
            if IsControlPressed(0, 51) then camCoords = camCoords + up * speed end      -- E
            if IsControlPressed(0, 52) then camCoords = camCoords - up * speed end      -- Q
            SetCamCoord(freecam_cam, camCoords.x, camCoords.y, camCoords.z)
            local rot = GetCamRot(freecam_cam, 2)
            local rotX = rot.x - GetDisabledControlNormal(0, 2) * 8.0
            local rotZ = rot.z - GetDisabledControlNormal(0, 1) * 8.0
            rotX = clamp(rotX, -89.5, 89.5)
            SetCamRot(freecam_cam, rotX, 0.0, rotZ, 2)
            local offsetCoords = camCoords + forward * 500.0
            local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(camCoords.x, camCoords.y, camCoords.z, offsetCoords.x, offsetCoords.y, offsetCoords.z, -1, p, 0)
            local _, hitResult, coords, _, entity = GetShapeTestResult(rayHandle)
            if hitResult == 1 then
                DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.2, 0.2, 0.2, 255, 0, 0, 255, false, true, 2, false, false, false, false)
            end
            local cx = math.floor(coords.x or 0)
            local cy = math.floor(coords.y or 0)
            local cz = math.floor((coords.z or 0) - 1.0)
            local currentmode = freecam.modes[freecam.mode]
            SetTextFont(0); SetTextScale(0.34, 0.34); SetTextColour(255, 255, 255, 255); SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("[Addict Freecam] Mode: " .. currentmode .. "  |  X:" .. cx .. " Y:" .. cy .. " Z:" .. cz)
            DrawText(0.5, 0.97)
            if IsDisabledControlJustPressed(1, 14) then
                freecam.mode = freecam.mode + 1
                if freecam.mode > #freecam.modes then freecam.mode = 1 end
            end
            if IsDisabledControlJustPressed(1, 15) then
                freecam.mode = freecam.mode - 1
                if freecam.mode < 1 then freecam.mode = #freecam.modes end
            end
            if freecam_ready and coords ~= vector3(0, 0, 0) then
                if currentmode == "Teleport" then
                    if IsDisabledControlJustPressed(0, 69) then SetEntityCoords(p, coords) end
                elseif currentmode == "Fast and Furious" then
                    if IsDisabledControlJustPressed(0, 69) then
                        local vehs = {"sultanrs","blista","zentorno","adder","turismo","deviant","thrax","vamos"}
                        local hash = GetHashKey(vehs[math.random(#vehs)])
                        RequestModel(hash); while not HasModelLoaded(hash) do Citizen.Wait(0) end
                        local veh = CreateVehicle(hash, coords, GetCamRot(freecam_cam, 2).z, true, true)
                        SetVehicleEngineOn(veh, true, true, true)
                        SetVehicleForwardSpeed(veh, 500.0)
                    end
                elseif currentmode == "Vehicle Spawner" then
                    if IsDisabledControlJustPressed(0, 69) then
                        local vehicles = {"adder","sultanrs","bati"}
                        local hash = GetHashKey(vehicles[math.random(#vehicles)])
                        RequestModel(hash); while not HasModelLoaded(hash) do Citizen.Wait(0) end
                        CreateVehicle(hash, coords, 0.0, true, true)
                    end
                elseif currentmode == "Entity Deleter" then
                    if IsDisabledControlJustPressed(0, 69) then
                        if DoesEntityExist(entity) and not IsPedAPlayer(entity) then DeleteEntity(entity) end
                    end
                elseif currentmode == "Particle Spawner" then
                    if IsDisabledControlJustPressed(0, 69) then
                        RequestNamedPtfxAsset("scr_rcbarry2"); while not HasNamedPtfxAssetLoaded("scr_rcbarry2") do Citizen.Wait(0) end
                        UseParticleFxAssetNextCall("scr_rcbarry2")
                        StartNetworkedParticleFxNonLoopedAtCoord("scr_clown_appears", coords, 0.0, 0.0, 0.0, 21.0, false, false, false)
                        RequestNamedPtfxAsset("core"); while not HasNamedPtfxAssetLoaded("core") do Citizen.Wait(0) end
                        UseParticleFxAssetNextCall("core")
                        StartNetworkedParticleFxNonLoopedAtCoord("ent_sht_petrol_fire", coords, 0.0, 0.0, 0.0, 21.0, false, false, false)
                    end
                elseif currentmode == "Ped Spawner" then
                    if IsDisabledControlJustPressed(0, 69) then
                        local pedTable = {"s_m_y_armymech_01","s_m_y_blackops_01","s_m_m_marine_01","s_m_y_blackops_03","s_m_y_blackops_02"}
                        local hash = GetHashKey(pedTable[math.random(#pedTable)])
                        RequestModel(hash); while not HasModelLoaded(hash) do Citizen.Wait(0) end
                        local ped_spawn = CreatePed(3, hash, coords.x, coords.y, coords.z - 0.5, 0.0, true, true)
                        SetEntityInvincible(ped_spawn, true)
                        GiveWeaponToPed(ped_spawn, GetHashKey("WEAPON_CARBINERIFLE"), 200, true, true)
                        for _, player in ipairs(GetActivePlayers()) do TaskCombatPed(ped_spawn, GetPlayerPed(player), 0, 16) end
                    end
                elseif currentmode == "Animal Spawner" then
                    if IsDisabledControlJustPressed(0, 69) then
                        local animalTable = {"a_c_boar","a_c_dolphin","a_c_killerwhale","a_c_retriever","a_c_pig","a_c_cow","a_c_humpback"}
                        local hash = GetHashKey(animalTable[math.random(#animalTable)])
                        RequestModel(hash); while not HasModelLoaded(hash) do Citizen.Wait(0) end
                        CreatePed(3, hash, coords.x, coords.y, coords.z, 0.0, true, true)
                    end
                elseif currentmode == "Prop Spawner" then
                    if IsDisabledControlJustPressed(0, 69) then
                        local props = {"prop_beach_fire","prop_beach_lounger","prop_beach_volball01","prop_cs_bin_01","prop_dumpster_01a","prop_rub_carwreck_7"}
                        local hash = GetHashKey(props[math.random(#props)])
                        RequestModel(hash); while not HasModelLoaded(hash) do Citizen.Wait(0) end
                        CreateObject(hash, coords.x, coords.y, coords.z, true, true, true)
                    end
                elseif currentmode == "Map Fucker" then
                    if IsDisabledControlJustPressed(0, 69) then
                        local smallprops = {"prop_phonebox_04","prop_parking_hut_2","prop_dumpster_01a","bkr_prop_bkr_cashpile_07","bkr_prop_meth_chiller_01a","lf_house_09_","lf_house_08_"}
                        local hash = GetHashKey(smallprops[math.random(#smallprops)])
                        RequestModel(hash); while not HasModelLoaded(hash) do Citizen.Wait(0) end
                        local obj = CreateObject(hash, coords.x, coords.y, coords.z, true, true, true)
                        FreezeEntityPosition(obj, true)
                    end
                elseif currentmode == "Tree Spawner" then
                    if IsDisabledControlJustPressed(0, 69) then
                        local treeprops = {"prop_tree_olive_01","prop_tree_pine_01","prop_tree_maple_02","prop_w_r_cedar_01"}
                        local hash = GetHashKey(treeprops[math.random(#treeprops)])
                        RequestModel(hash); while not HasModelLoaded(hash) do Citizen.Wait(0) end
                        local obj = CreateObject(hash, coords.x, coords.y, coords.z, true, true, true)
                        FreezeEntityPosition(obj, true)
                    end
                elseif currentmode == "Look Around" then
                    -- No action, just look around
                elseif currentmode == "Freeze Entity" then
                    if IsDisabledControlJustPressed(0, 69) then
                        if DoesEntityExist(entity) then FreezeEntityPosition(entity, true) end
                    end
                elseif currentmode == "Terrorist Attack" then
                    if IsDisabledControlJustPressed(0, 69) then
                        local pedTable = {"s_m_y_blackops_01","s_m_y_blackops_02"}
                        local hash = GetHashKey(pedTable[math.random(#pedTable)])
                        RequestModel(hash); while not HasModelLoaded(hash) do Citizen.Wait(0) end
                        local ped_spawn = CreatePed(3, hash, coords.x, coords.y, coords.z - 0.5, 0.0, true, true)
                        SetEntityInvincible(ped_spawn, true)
                        GiveWeaponToPed(ped_spawn, GetHashKey("WEAPON_RPG"), 10, true, true)
                        for _, player in ipairs(GetActivePlayers()) do TaskCombatPed(ped_spawn, GetPlayerPed(player), 0, 16) end
                    end
                elseif currentmode == "CrashHim" then
                    if IsDisabledControlJustPressed(0, 69) then
                        if DoesEntityExist(entity) then
                            local playerIndex = NetworkGetPlayerIndexFromPed(entity)
                            if playerIndex ~= -1 and NetworkIsPlayerActive(playerIndex) and playerIndex ~= PlayerId() then
                                notify_push("~r~Addict", "~y~CrashHim ~w~sent")
                            end
                        end
                    end
                elseif currentmode == "Trip Player" then
                    if IsDisabledControlJustPressed(0, 69) then
                        if DoesEntityExist(entity) then
                            local playerIndex = NetworkGetPlayerIndexFromPed(entity)
                            if playerIndex ~= -1 and NetworkIsPlayerActive(playerIndex) and playerIndex ~= PlayerId() then
                                TripPlayer(entity)
                                notify_push("~r~Addict", "~y~Trip ~w~sent to player")
                            else
                                -- If aimed at a ped or non-player, trip at the crosshair coords
                                TripPlayer(entity)
                                notify_push("Addict", "~p~Trip sent to entity")
                            end
                        end
                    end
                end
            end
        else
            -- Freecam OFF: restore player in place
            if freecam_cam ~= nil then
                SetCamActive(freecam_cam, false)
                RenderScriptCams(false, false, 0, true, false)
                DestroyCam(freecam_cam, true)
                freecam_cam = nil
                freecam_ready = false
                SetEntityInvincible(p, feat.godmode or false)
                if not noclipActive then
                    SetEntityCollision(p, true, true)
                end
                DisplayRadar(true)
                DisplayHud(true)
            end
        end
    end
end)

-- ─── Radial Menu thread ──────────────────────────────────────────────────────
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local ok, err = pcall(function()
        if not feat.radialMenu then
            if radialMenu_open then
                radialMenu_open    = false
                radialMenu_hovered = 0
                radialMenu_target  = nil
                radialMenu_openRot = nil
            end
            return
        end

        local screen_w, screen_h = GetActiveScreenResolution()
        if not screen_w or screen_w == 0 then screen_w = 1920; screen_h = 1080 end
        local p = PlayerPedId()

        -- ── Crosshair — always visible when Radial Menu is enabled ───────
        do
            local ccx = screen_w * 0.5; local ccy = screen_h * 0.5
            local clen = 9.0; local cgap = 5.0; local cw = 2.0
            draw_rect(ccx - clen - cgap, ccy - cw*0.5, clen, cw, {r=255,g=255,b=255,a=210}, screen_w, screen_h)
            draw_rect(ccx + cgap,        ccy - cw*0.5, clen, cw, {r=255,g=255,b=255,a=210}, screen_w, screen_h)
            draw_rect(ccx - cw*0.5, ccy - clen - cgap, cw, clen, {r=255,g=255,b=255,a=210}, screen_w, screen_h)
            draw_rect(ccx - cw*0.5, ccy + cgap,        cw, clen, {r=255,g=255,b=255,a=210}, screen_w, screen_h)
            draw_rect(ccx - 2, ccy - 2, 4, 4, {r=255,g=255,b=255,a=255}, screen_w, screen_h)
        end

        -- ── Continuous crosshair raycast ──────────────────────────────
        local camPos = GetGameplayCamCoord()
        local camRot = GetGameplayCamRot(2)
        local camDir = RotationToDirection(camRot)
        local farPos = vector3(
            camPos.x + camDir.x * 90.0,
            camPos.y + camDir.y * 90.0,
            camPos.z + camDir.z * 90.0
        )
        local ray = StartExpensiveSynchronousShapeTestLosProbe(
            camPos.x, camPos.y, camPos.z,
            farPos.x, farPos.y, farPos.z,
            -1, p, 0
        )
        local _, hitResult, hitCoords, _, hitEntity = GetShapeTestResult(ray)

        local validTarget = (hitResult == 1) and DoesEntityExist(hitEntity) and (hitEntity ~= p)

        -- ── Draw 3D bounding box + label when aimed at an entity ──────────
            if validTarget and not radialMenu_open then
                local epos = GetEntityCoords(hitEntity)
                local etype = GetEntityType(hitEntity)

                -- 3D wireframe box around the entity
                draw_3d_box(hitEntity, 180, 255, 100, 220)

                -- Type label above entity
                local typeLabel = "ENTITY"
                if etype == 1 then
                    local isPlayer = false
                    for i = 0, 128 do
                        if NetworkIsPlayerActive(i) and GetPlayerPed(i) == hitEntity then
                            local ok, nm = pcall(GetPlayerName, i)
                            typeLabel = "PLAYER: " .. (ok and nm or "?")
                            isPlayer = true; break
                        end
                    end
                    if not isPlayer then typeLabel = "PED" end
                elseif etype == 2 then
                    typeLabel = "VEHICLE"
                elseif etype == 3 then
                    typeLabel = "OBJECT"
                end

                local on, sx, sy = GetScreenCoordFromWorldCoord(epos.x, epos.y, epos.z + 1.3)
                if on then
                    SetTextFont(0); SetTextScale(0.28, 0.28)
                    SetTextColour(180, 255, 100, 255); SetTextOutline()
                    SetTextCentre(true); SetTextEntry("STRING")
                    AddTextComponentString(typeLabel)
                    DrawText(sx, sy - 0.032)

                    SetTextFont(0); SetTextScale(0.22, 0.22)
                    SetTextColour(200, 200, 200, 180); SetTextOutline()
                    SetTextCentre(true); SetTextEntry("STRING")
                    AddTextComponentString("Hold [G] to open Radial Menu")
                    DrawText(sx, sy - 0.018)
                end
            end

            -- ── R key detection — must use IsDisabledControl because the  ──
            -- main HUD thread calls DisableAllControlActions while open.   ──
            -- R key = control 45 = INPUT_RELOAD
            local holding = IsDisabledControlPressed(0, 47) or IsControlPressed(0, 47)

            -- Open: only if holding AND a valid entity is aimed at
            if holding and not radialMenu_open and validTarget then
                radialMenu_open    = true
                radialMenu_target  = hitEntity
                radialMenu_openRot = GetGameplayCamRot(2)   -- snapshot
            end

            -- If we started holding with no entity, keep checking (don't open yet)
            if holding and not radialMenu_open and not validTarget then
                -- Show "no target" hint at crosshair centre
                local cx = screen_w * 0.5; local cy = screen_h * 0.5
                SetTextFont(0); SetTextScale(0.25, 0.25)
                SetTextColour(255, 80, 80, 200); SetTextOutline()
                SetTextCentre(true); SetTextEntry("STRING")
                AddTextComponentString("No entity in crosshair")
                DrawText(cx / screen_w, (cy + 30) / screen_h)
            end

            -- ── While open ────────────────────────────────────────────────
            if radialMenu_open then
                if not holding then
                    -- Released — fire action
                    if radialMenu_hovered > 0 and radialMenu_target ~= nil then
                        ExecuteRadialAction(radialMenu_hovered, radialMenu_target)
                    end
                    radialMenu_open    = false
                    radialMenu_hovered = 0
                    radialMenu_target  = nil
                    radialMenu_openRot = nil
                else
                    -- Compute camera delta from snapshot so aiming selects slices
                    local curRot = GetGameplayCamRot(2)
                    local cam_dx = curRot.z - radialMenu_openRot.z
                    local cam_dy = curRot.x - radialMenu_openRot.x
                    -- Wrap yaw delta into [-180, 180]
                    if cam_dx >  180 then cam_dx = cam_dx - 360 end
                    if cam_dx < -180 then cam_dx = cam_dx + 360 end
                    draw_radial_menu(screen_w, screen_h, cam_dx, cam_dy)
                end
            end
        end) -- end pcall
        if not ok then
            -- Print error to F8 console so we can see what crashed
            print("[Addict] Radial thread error: " .. tostring(err))
        end
    end
end)

-- ─── Entity Throttler thread ─────────────────────────────────────────────────
Citizen.CreateThread(function()
    local MAX_VEHICLES = 30
    local MAX_PEDS     = 40
    local MAX_OBJECTS  = 60

    while true do
        Wait(500)
        if not feat.entityThrottler then goto continue end

        local p     = PlayerPedId()
        local myVeh = GetVehiclePedIsIn(p, false)
        local pc    = GetEntityCoords(p)

        -- ── Vehicles ──
        local veh_list = {}
        local iter, veh = FindFirstVehicle()
        local found = true
        while found do
            if DoesEntityExist(veh) and veh ~= myVeh then
                veh_list[#veh_list + 1] = veh
            end
            found, veh = FindNextVehicle(iter)
        end
        EndFindVehicle(iter)
        if #veh_list > MAX_VEHICLES then
            table.sort(veh_list, function(a, b)
                return #(GetEntityCoords(a) - pc) > #(GetEntityCoords(b) - pc)
            end)
            local del = 0
            for i = 1, #veh_list - MAX_VEHICLES do
                local e = veh_list[i]
                if DoesEntityExist(e) then
                    NetworkRequestControlOfEntity(e)
                    local t = 0
                    while not NetworkHasControlOfEntity(e) and t < 10 do Wait(0); t = t + 1 end
                    if NetworkHasControlOfEntity(e) then
                        SetEntityAsMissionEntity(e, false, true); DeleteEntity(e); del = del + 1
                    end
                end
            end
            if del > 0 then notify_push("Addict", "~y~Throttler: culled " .. del .. " vehicles") end
        end

        -- ── Peds ──
        local ped_list = {}
        iter, veh = FindFirstPed()
        found = true
        while found do
            if DoesEntityExist(veh) and veh ~= p and not IsPedAPlayer(veh) then
                ped_list[#ped_list + 1] = veh
            end
            found, veh = FindNextPed(iter)
        end
        EndFindPed(iter)
        if #ped_list > MAX_PEDS then
            table.sort(ped_list, function(a, b)
                return #(GetEntityCoords(a) - pc) > #(GetEntityCoords(b) - pc)
            end)
            local del = 0
            for i = 1, #ped_list - MAX_PEDS do
                local e = ped_list[i]
                if DoesEntityExist(e) then
                    NetworkRequestControlOfEntity(e)
                    local t = 0
                    while not NetworkHasControlOfEntity(e) and t < 10 do Wait(0); t = t + 1 end
                    if NetworkHasControlOfEntity(e) then
                        SetEntityAsMissionEntity(e, false, true); DeleteEntity(e); del = del + 1
                    end
                end
            end
            if del > 0 then notify_push("Addict", "~y~Throttler: culled " .. del .. " peds") end
        end

        -- ── Objects ──
        local obj_list = {}
        iter, veh = FindFirstObject()
        found = true
        while found do
            if DoesEntityExist(veh) then
                obj_list[#obj_list + 1] = veh
            end
            found, veh = FindNextObject(iter)
        end
        EndFindObject(iter)
        if #obj_list > MAX_OBJECTS then
            table.sort(obj_list, function(a, b)
                return #(GetEntityCoords(a) - pc) > #(GetEntityCoords(b) - pc)
            end)
            local del = 0
            for i = 1, #obj_list - MAX_OBJECTS do
                local e = obj_list[i]
                if DoesEntityExist(e) then
                    NetworkRequestControlOfEntity(e)
                    local t = 0
                    while not NetworkHasControlOfEntity(e) and t < 10 do Wait(0); t = t + 1 end
                    if NetworkHasControlOfEntity(e) then
                        SetEntityAsMissionEntity(e, false, true); DeleteEntity(e); del = del + 1
                    end
                end
            end
            if del > 0 then notify_push("Addict", "~y~Throttler: culled " .. del .. " objects") end
        end

        ::continue::
    end
end)

-- ─── Super Strength melee blast thread ───────────────────────────────────────
Citizen.CreateThread(function()
    local cooldown = false
    while true do
        Wait(0)
        if not Powers.superstrength then Wait(200); goto ss_continue end

        local p = PlayerPedId()
        if IsPedInAnyVehicle(p, false) then goto ss_continue end

        -- Detect any attack input (unarmed / melee weapon)
        local attacking =
            IsControlJustPressed(0, 140) or IsControlJustPressed(0, 141) or
            IsControlJustPressed(0, 142) or IsControlJustPressed(0, 143) or
            IsDisabledControlJustPressed(0, 140) or IsDisabledControlJustPressed(0, 141) or
            IsDisabledControlJustPressed(0, 142) or IsDisabledControlJustPressed(0, 143)

        if attacking and not cooldown then
            cooldown = true
            local pc2 = GetEntityCoords(p)
            local fwd = GetEntityForwardVector(p)
            local REACH = 2.8  -- arm's reach in metres

            -- Find any vehicle within reach
            local iter, veh3 = FindFirstVehicle()
            local fok = true
            while fok do
                if DoesEntityExist(veh3) then
                    local diff = GetEntityCoords(veh3) - pc2
                    local dist = #diff
                    if dist < REACH then
                        -- Check it's roughly in front (dot product > -0.3)
                        local dot = (diff.x * fwd.x + diff.y * fwd.y)
                        if dot > -0.3 then
                            NetworkRequestControlOfEntity(veh3)
                            local tw = 0
                            while not NetworkHasControlOfEntity(veh3) and tw < 10 do Wait(0); tw = tw + 1 end
                            if NetworkHasControlOfEntity(veh3) then
                                local dir = diff * (1.0 / math.max(dist, 0.1))
                                SetEntityVelocity(veh3,
                                    dir.x * 30.0 + fwd.x * 15.0,
                                    dir.y * 30.0 + fwd.y * 15.0,
                                    22.0)
                            end
                        end
                    end
                end
                fok, veh3 = FindNextVehicle(iter)
            end
            EndFindVehicle(iter)

            Wait(350)
            cooldown = false
        end

        ::ss_continue::
    end
end)

-- ─── Spectator / Noclip Detection thread ─────────────────────────────────────
Citizen.CreateThread(function()
    local samples    = {}   -- [pid] = { pos, time } ring buffer (last 3)
    local flags      = {}   -- [pid] = consecutive noclip tick count
    local names      = {}   -- [pid] = cached name
    local CONFIRM    = 1    -- consecutive ticks before flagging
    local CLEAR      = 3    -- clear ticks before removing
    local clear_ctr  = {}   -- [pid] = ticks since last noclip

    while true do
        Wait(120)  -- scan every 120ms — fast enough to catch movement bursts

        local myPid = PlayerId()
        local now   = GetGameTimer()

        for pid = 0, 255 do
            if not NetworkIsPlayerActive(pid) then
                samples[pid] = nil; flags[pid] = nil; clear_ctr[pid] = nil
                goto next_pid
            end
            if pid == myPid then goto next_pid end

            local ped = GetPlayerPed(pid)
            if not DoesEntityExist(ped) then goto next_pid end

            local pos    = GetEntityCoords(ped)
            local inVeh  = IsPedInAnyVehicle(ped, false)
            local prev   = samples[pid]

            if prev then
                local dt2   = (now - prev.t) / 1000.0
                if dt2 > 0 then
                    local diff  = pos - prev.pos
                    local speed = #diff / dt2  -- m/s

                    -- Flag anyone on foot moving faster than a normal sprint (~5 m/s)
                    local suspect = not inVeh and speed > 5.0

                    if suspect then
                        flags[pid] = (flags[pid] or 0) + 1
                        clear_ctr[pid] = 0
                        if not names[pid] then
                            local ok, n = pcall(GetPlayerName, pid)
                            names[pid] = (ok and n) or ("Player " .. pid)
                        end
                    else
                        clear_ctr[pid] = (clear_ctr[pid] or 0) + 1
                        if (clear_ctr[pid] or 0) >= CLEAR then
                            flags[pid] = 0
                        end
                    end
                end
            end

            samples[pid] = { pos = pos, t = now }
            ::next_pid::
        end

        -- Rebuild spectator list from confirmed flags
        local found = {}
        for pid = 0, 255 do
            if (flags[pid] or 0) >= CONFIRM and NetworkIsPlayerActive(pid) then
                local ped = GetPlayerPed(pid)
                if DoesEntityExist(ped) then
                    table.insert(found, {
                        pid  = pid,
                        name = names[pid] or ("Player " .. pid),
                        ped  = ped,
                    })
                end
            end
        end
        spectator_list = found
    end
end)

Wait(200)
state.open = true
notify_push('~p~Addict ' .. my_version, ' Loaded!                              Press DELETE to open')