_addon.name = 'Herald'
_addon.author = 'Rahvin'
_addon.version = '1.0'
_addon.commands = { 'her', 'herald' }

local packets = require('packets')
local res = require('resources')
local config = require('config')

--User-Defined equipment sets for your gearswap.  Modify in gearswap to match these, or modify the sets and the reset command here to match your gearswap.
local cursna_set = "sets.Cursna_Received"
local phalanx_set = "sets.Phalanx_Received"
local protect_shell_set = "sets.Protect_Shell_Received"
local regen_set = "sets.Regen_Received"
local equip_reset_command = "gs c update auto"

--Default Settings.  Overridden by Character Specific Settings.
local default_settings = {
    debug_mode = false,
    delay = 3,
    track_cursna = true,
    track_phalanx = true,
    track_regen = true,
    track_protect_shell = true,
}
local settings = config.load(default_settings)

local addon_enabled = true
local accession_active = false
local in_progress = false
local failsafe_active = false
local failsafe_trigger_time = 0

local tracked_spells = {
    [20] = settings.track_cursna,         --Cursna
    [106] = settings.track_phalanx,       --Phalanx
    [107] = settings.track_phalanx,       --Phalanx II
    [108] = settings.track_regen,         --Regen
    [110] = settings.track_regen,         --Regen II
    [111] = settings.track_regen,         --Regen III
    [477] = settings.track_regen,         --Regen IV
    [504] = settings.track_regen,         --Regen V
    [43] = settings.track_protect_shell,  --Protect
    [44] = settings.track_protect_shell,  --Protect II
    [45] = settings.track_protect_shell,  --Protect III
    [46] = settings.track_protect_shell,  --Protect IV
    [47] = settings.track_protect_shell,  --Protect V
    [125] = settings.track_protect_shell, --Protectra
    [126] = settings.track_protect_shell, --Protectra II
    [127] = settings.track_protect_shell, --Protectra III
    [128] = settings.track_protect_shell, --Protectra IV
    [129] = settings.track_protect_shell, --Protectra V
    [48] = settings.track_protect_shell,  --Shell
    [49] = settings.track_protect_shell,  --Shell II
    [50] = settings.track_protect_shell,  --Shell III
    [51] = settings.track_protect_shell,  --Shell IV
    [52] = settings.track_protect_shell,  --Shell V
    [130] = settings.track_protect_shell, --Shellra
    [131] = settings.track_protect_shell, --Shellra II
    [132] = settings.track_protect_shell, --Shellra III
    [133] = settings.track_protect_shell, --Shellra IV
    [134] = settings.track_protect_shell, --Shellra V
}

local cursna_spells = {
    [20] = settings.track_cursna, --Cursna
}

local phalanx_spells = {
    [106] = settings.track_phalanx, --Phalanx
    [107] = settings.track_phalanx, --Phalanx II
}

local protect_and_shell_spells = {
    [43] = settings.track_protect_shell,  --Protect
    [44] = settings.track_protect_shell,  --Protect II
    [45] = settings.track_protect_shell,  --Protect III
    [46] = settings.track_protect_shell,  --Protect IV
    [47] = settings.track_protect_shell,  --Protect V
    [125] = settings.track_protect_shell, --Protectra
    [126] = settings.track_protect_shell, --Protectra II
    [127] = settings.track_protect_shell, --Protectra III
    [128] = settings.track_protect_shell, --Protectra IV
    [129] = settings.track_protect_shell, --Protectra V
    [48] = settings.track_protect_shell,  --Shell
    [49] = settings.track_protect_shell,  --Shell II
    [50] = settings.track_protect_shell,  --Shell III
    [51] = settings.track_protect_shell,  --Shell IV
    [52] = settings.track_protect_shell,  --Shell V
    [130] = settings.track_protect_shell, --Shellra
    [131] = settings.track_protect_shell, --Shellra II
    [132] = settings.track_protect_shell, --Shellra III
    [133] = settings.track_protect_shell, --Shellra IV
    [134] = settings.track_protect_shell, --Shellra V
}

local regen_spells = {
    [108] = settings.track_regen, --Regen
    [110] = settings.track_regen, --Regen II
    [111] = settings.track_regen, --Regen III
    [477] = settings.track_regen, --Regen IV
    [504] = settings.track_regen, --Regen V
}

local aoe_spells = {
    [125] = settings.track_protect_shell, --Protectra
    [126] = settings.track_protect_shell, --Protectra II
    [127] = settings.track_protect_shell, --Protectra III
    [128] = settings.track_protect_shell, --Protectra IV
    [129] = settings.track_protect_shell, --Protectra V
    [130] = settings.track_protect_shell, --Shellra
    [131] = settings.track_protect_shell, --Shellra II
    [132] = settings.track_protect_shell, --Shellra III
    [133] = settings.track_protect_shell, --Shellra IV
    [134] = settings.track_protect_shell, --Shellra V
}

local function log_echo(message, color_id)
    windower.add_to_chat(color_id or 204, '[Herald] ' .. message)
end

local function debug(message, color_id)
    if not settings.debug_mode then return end

    local timestamp = math.floor(os.clock() * 1000)
    windower.add_to_chat(color_id or 204, "[Herald] [Time: " .. timestamp .. "] DEBUG: " .. message)
end

windower.register_event('load', function()
    log_echo('Herald Loaded Successfully and Tracking Enabled', 204)
    log_echo('Tracked Spells: Cursna ' ..
        (settings.track_cursna and "ON" or "OFF") ..
        ' | Phalanx ' ..
        (settings.track_regen and "ON" or "OFF") ..
        ' | Regen ' ..
        (settings.track_regen and "ON" or "OFF") .. ' | Protect ' .. (settings.track_protect_shell and "ON" or "OFF"))
    log_echo("Failsafe equipment reversion delay is " ..
        tostring(settings.delay) .. "s and debug mode is " .. (settings.debug_mode and "ON" or "OFF"))
    log_echo("Options: //her [help|on|off|debug|cursna|phalanx|regen|protect|delay <seconds>]")
end)

windower.register_event('outgoing chunk', function(id, data, modified, injected, blocked)
    if not addon_enabled then return end
    --Detect outgoing action packet
    if id == 0x01A then
        debug("Action Initiated")
        local packet = packets.parse('outgoing', data)

        --Detect spell casting. Category 3 corresponds to Magic Spell Cast Start
        if packet['Category'] == 3 then
            debug('Category 3 Outgoing Action Recognized')

            local spell_id = packet['Param'] -- The ID of the spell being cast
            debug('Outgoing Spell ID is ' .. spell_id)

            --Check if spell is currently being tracked and continue to equipment changing if so
            if tracked_spells[spell_id] == true then
                debug('Outgoing Spell ID is tracked. Continuing to messaging.')

                --Extract Target and Spell Data from the packet.
                local target_id = packet['Target']
                debug("Target of outgoing spell is " .. target_id)
                local spell_data = res.spells[spell_id]
                debug("Outgoing spell name is " .. spell_data.en)

                --Get player and target and then send spell cast notifications.
                local player = windower.ffxi.get_player() or "Unknown Player ID"
                local target_mob = windower.ffxi.get_mob_by_id(target_id)
                local target_name = target_mob and target_mob.name or "Unknown Target"
                debug(player.name .. " is attempting to cast: " .. spell_data.en .. " on " .. target_name)

                --IPC Messaging is not received by the caster/sender.  Must track self casts separately.
                if target_name == player.name then
                    debug("Self Cast Detected")
                end

                --Calculate AoE Targets
                if aoe_spells[spell_id] or accession_active then
                    debug("AoE Spell Cast Detected.  Calculating targets.")

                    local party = windower.ffxi.get_party()
                    if not player or not target_mob or not party then return end

                    local max_distance = 10
                    local nearby_members = {}
                    local threshold_squared = max_distance * max_distance

                    for slot, member in pairs(party) do
                        -- Ensure the slot contains a valid party member table with a name
                        if type(member) == 'table' and member.name then
                            -- Get the full mob table for this specific party member to fetch coordinates
                            local member_mob = windower.ffxi.get_mob_by_name(member.name)

                            if member_mob then
                                -- Calculate spatial deltas between the party member and the spell target
                                local dx = member_mob.x - target_mob.x
                                local dy = member_mob.y - target_mob.y
                                local dz = member_mob.z - target_mob.z

                                -- Compute 3D Euclidean distance squared
                                local distance_squared = (dx * dx) + (dy * dy) + (dz * dz)

                                -- Compare directly against the squared threshold
                                if distance_squared <= threshold_squared then
                                    debug(member.name .. " is WITHIN 10 yalms of " .. target_mob.name)
                                    table.insert(nearby_members, member.name)

                                    -- TODO: Pack this player into an IPC broadcast table
                                else
                                    debug(member.name .. " is OUT of range.")
                                end
                            else
                                -- The party member is out of zone or beyond local draw distance limits
                                debug(member.name .. " data unavailable (Too far away).")
                            end
                        end
                    end

                    if #nearby_members > 0 then
                        target_name = table.concat(nearby_members, ",")
                    end
                end

                --Send IPC Message to others indicating target, spell name and send time.
                local msg = string.format("HERALD|%s|%s", target_name, spell_data.id)
                debug("IPC Message Sent: " .. msg)
                windower.send_ipc_message(msg)
                in_progress = true
            end
        end

        --Category 9 corresponds to Job Ability and Parameter 218 is Accession
        if packet['Category'] == 9 and packet['Param'] == 218 then
            debug("Accession has been detected")
            accession_active = true
        end
    end
end)

--Register when casting is completed, only during a previously registered cast.
windower.register_event('incoming chunk', function(id, data, modified, injected, blocked)
    if not addon_enabled then return end
    --Watch for the server's authoritative action confirmation packet
    if id == 0x028 then
        local packet = packets.parse('incoming', data)
        local player = windower.ffxi.get_player()

        --Ensure the actor for the incoming packet is self prior to performing any operation.
        if player and packet['Actor'] == player.id then
            --Detect tracked spell cast, Broadcast IPC message and reset state
            --Category 4 = Spell Cast Completed Successfully
            if packet['Category'] == 4 and in_progress then
                local spell_id = packet['Param']

                --Broadcast the completion payload over IPC
                --Structure: HERALD_DONE|PlayerName|SpellID|Timestamp
                local msg = string.format("HERALD_DONE|%s|%s", player.name, spell_id)
                windower.send_ipc_message(msg)
                in_progress = false
                accession_active = false
                debug("Cast complete! Broadcasted IPC: " .. msg)

                --Detect when non-tracked spell is cast to reset accession state
            elseif packet['Category'] == 4 and not in_progress and accession_active then
                debug("Non-tracked spell cast completed! Resetting Accession")
                accession_active = false

                --Detect spell interrupts, broadcast IPC message and reset state.
                --Category 5 = Spell Cast Interrupted
            elseif packet['Category'] == 5 and in_progress then
                debug("Category 5 detected - Spell Interrupted")
                local msg_id = packet['Param']
                if msg_id == 16 or msg_id == 85 then
                    local msg = string.format("HERALD_INTERRUPT|%s", player.name)
                    windower.send_ipc_message(msg)
                    debug("Cast interrupted! Broadcasted IPC: " .. msg)
                    in_progress = false
                end
            end
        end
    end
end)

local function equip_gear(spell_i)
    debug("Equip Gear Function Initiated with Spell ID " .. spell_i)
    if cursna_spells[spell_i] then
        debug("Sending Cursna Equip Command")
        windower.send_command("gs equip " .. cursna_set)
    elseif phalanx_spells[spell_i] then
        debug("Sending Phalanx Equip Command")
        windower.send_command("gs equip " .. phalanx_set)
    elseif protect_and_shell_spells[spell_i] then
        debug("Sending Prot/Shell Equip Command")
        windower.send_command("gs equip " .. protect_shell_set)
    elseif regen_spells[spell_i] then
        debug("Sending Regen Equip Command")
        windower.send_command("gs equip " .. regen_set)
    end
end

--Receive IPC Messages, send commands to gearswap and set casting state
windower.register_event('ipc message', function(msg)
    if not addon_enabled then return end
    if msg:startswith('HERALD|') then
        debug("IPC Message Received: " .. msg)

        local split_msg = msg:split("|")
        local target_name = split_msg[2] or "Missing Target Name"
        local spell_id = split_msg[3] or "Missing Spell ID"

        local player = windower.ffxi.get_player() or "Unknown Player ID"
        if string.find(target_name, player.name, 1, true) and not in_progress then
            equip_gear(tonumber(spell_id))
            in_progress = true
            failsafe_active = true
            failsafe_trigger_time = os.clock() + settings.delay
            debug(player.name .. " is recognized within targets list. Equipping gear and setting in_progress to true")
        end
    elseif msg:startswith("HERALD_DONE|") and in_progress then
        debug("IPC Message Received: " .. msg)

        local split_msg = msg:split("|")
        local caster_name = split_msg[2]
        local spell_id = split_msg[3]

        windower.send_command(equip_reset_command)
        in_progress = false
        debug(caster_name .. " has finished casting spell ID: " .. spell_id .. " Resetting in_progress")
    elseif msg:startswith("HERALD_INTERRUPT|") and in_progress then
        debug("IPC Message Received: " .. msg)

        local split_msg = msg:split("|")
        local caster_name = split_msg[2]

        debug(caster_name .. " has been interrupted while casting. Resetting in_progress")
        in_progress = false
    elseif msg:startswith("HERALD_PROT|") then
        settings.track_protect_shell = not settings.track_protect_shell
        log_echo('Protect and Shell tracking ' .. (settings.track_protect_shell and "ON" or "OFF"))
        config.save(settings)
    elseif msg:startswith("HERALD_PHALANX|") then
        settings.track_phalanx = not settings.track_phalanx
        log_echo('Phalanx tracking ' .. (settings.track_phalanx and "ON" or "OFF"))
        config.save(settings)
    elseif msg:startswith("HERALD_REGEN|") then
        settings.track_regen = not settings.track_regen
        log_echo('Regen tracking ' .. (settings.track_regen and "ON" or "OFF"))
        config.save(settings)
    elseif msg:startswith("HERALD_CURSNA|") then
        settings.track_cursna = not settings.track_cursna
        log_echo('Cursna tracking ' .. (settings.track_cursna and "ON" or "OFF"))
        config.save(settings)
    end
end)

windower.register_event('addon command', function(cmd, ...)
    local args = { ... }
    if not cmd then return end
    cmd = cmd:lower()

    if cmd == 'on' then
        log_echo('Enabled.')
        addon_enabled = true
        in_progress = false
        accession_active = false
        failsafe_active = false
        failsafe_trigger_time = 0
    elseif cmd == 'off' then
        log_echo('Disabled.')
        addon_enabled = false
        in_progress = false
        accession_active = false
        failsafe_active = false
        failsafe_trigger_time = 0
    elseif cmd == 'debug' then
        settings.debug_mode = not settings.debug_mode
        log_echo('Debug Mode ' .. (settings.debug_mode and "ON" or "OFF"))
        config.save(settings)
    elseif cmd == 'delay' then
        local new_delay = tonumber(args)
        if new_delay and new_delay >= 0 then
            settings.delay = new_delay
            config.save(settings)
            log_echo('Failsafe reset delay updated to: ' .. string.format("%.1f", new_delay) .. ' seconds.')
        else
            log_echo('Invalid delay value. Example: //her delay 1.5')
        end
    elseif cmd == 'protect' then
        settings.track_protect_shell = not settings.track_protect_shell
        log_echo('Protect and Shell tracking ' .. (settings.track_protect_shell and "ON" or "OFF"))
        config.save(settings)
        windower.send_ipc_message("HERALD_PROT|")
    elseif cmd == 'phalanx' then
        settings.track_phalanx = not settings.track_phalanx
        log_echo('Phalanx tracking ' .. (settings.track_phalanx and "ON" or "OFF"))
        config.save(settings)
        windower.send_ipc_message("HERALD_PHALANX|")
    elseif cmd == 'regen' then
        settings.track_regen = not settings.track_regen
        log_echo('Regen tracking ' .. (settings.track_regen and "ON" or "OFF"))
        config.save(settings)
        windower.send_ipc_message("HERALD_REGEN|")
    elseif cmd == 'cursna' then
        settings.track_cursna = not settings.track_cursna
        log_echo('Cursna tracking ' .. (settings.track_cursna and "ON" or "OFF"))
        config.save(settings)
        windower.send_ipc_message("HERALD_CURSNA|")
    else
        log_echo("Unknown command. Options: //her [help|on|off|debug|cursna|phalanx|regen|protect|delay <seconds>]")
    end
end)

windower.register_event('prerender', function()
    if not addon_enabled or not failsafe_active then return end

    if os.clock() >= failsafe_trigger_time then
        failsafe_active = false
        failsafe_trigger_time = 0
        in_progress = false
        windower.send_command("gs c update auto")
        debug("Failsafe triggered! Sending equipment reset command.")
    end
end)
