--Set up gear sets for an unlimited number of characters here. Sets from your personal gearswap file WILL NOT
--be used by Herald.  Copy all sets into this file.  Use cure_set, cursna_set, phalanx_set,protect_shell_set,
--refresh_set, regen_set, waltz_set.  Be sure to disable any doom/cursna actions in your gearswap.
--Use the modified Mirdain include provided in the repository for multibox-optimized functions and less overhead.
--Add characters as needed by copying and pasting.  Extensive list of spell received gear at bottom of this file.

--============================================--
-- CHANGE CHARACTERNUM TO YOUR CHARACTER NAME --
--============================================--
--Establish gear sets for each character and each spell received set.  Job specific sets take precedence over
--all_jobs set.  Sets are not combined.  Each are individual set definitions for maximum job-specific control.

return {
    --Change "CharacterOne" to your character name.
    ["CharacterOne"] = {
        --Cure Received Potency - 30% Cap.  Stacks with Cure Potency I 50% Max, Cure Potency II 30% Max
        --and Day/Weather Bonus
        cure_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {
                waist = "Gishdubar Sash",
            },
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Cursna Received - Unknown Cap. Multiplicative bonus to cursa chance to remove from healing skill
        --and cursna+ of caster. 1% for 1 cursna received.
        cursna_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {
                neck       = "Nicander's Necklace",
                left_ring  = { name = "Saida Ring", bag = "wardrobe3", priority = 2 },
                right_ring = { name = "Saida Ring", bag = "wardrobe4", priority = 1 },
                waist      = "Gishdubar Sash",
            },
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Phalanx Received - Unkonwn Cap.  Stacks with Phalanx+ from caster.  Works with embolden.
        phalanx_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},

        },

        --Protect and Shell received - Potential that items do not stack.  Only the highest value is used.
        --Protect Received+ adds DEF.  Shell Received+ adds fractional MDT but does not exceed the 50% MDT cap.
        protect_shell_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Refresh duration increase gear.  No known cap.  Adds seconds to Refresh Duration.
        --Increase is flat and not multiplicative with other refresh buff extension spells and abilities.
        refresh_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {
                waist = "Gishdubar Sash",
            },
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Regen received potency
        --Final HP per Tick = Caster Base Spell Power + Caster Regen Potency Gear + Your Received Regen Gear
        regen_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Waltz Potency Received - 30% cap that stacks with Waltz Potency (outgoing) multiplicatively
        waltz_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },
    },
    ["CharacterTwo"] = {
        --Cure Received Potency - 30% Cap.  Stacks with Cure Potency I 50% Max, Cure Potency II 30% Max
        --and Day/Weather Bonus
        cure_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Cursna Received - Unknown Cap. Multiplicative bonus to cursa chance to remove from healing skill
        --and cursna+ of caster. 1% for 1 cursna received.
        cursna_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Phalanx Received - Unkonwn Cap.  Stacks with Phalanx+ from caster.  Works with embolden.
        phalanx_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},

        },

        --Protect and Shell received - Potential that items do not stack.  Only the highest value is used.
        --Protect Received+ adds DEF.  Shell Received+ adds fractional MDT but does not exceed the 50% MDT cap.
        protect_shell_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Refresh duration increase gear.  No known cap.  Adds seconds to Refresh Duration.
        --Increase is flat and not multiplicative with other refresh buff extension spells and abilities.
        refresh_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Regen received potency
        --Final HP per Tick = Caster Base Spell Power + Caster Regen Potency Gear + Your Received Regen Gear
        regen_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Waltz Potency Received - 30% cap that stacks with Waltz Potency (outgoing) multiplicatively
        waltz_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },
    },
    ["CharacterThree"] = {
        --Cure Received Potency - 30% Cap.  Stacks with Cure Potency I 50% Max, Cure Potency II 30% Max
        --and Day/Weather Bonus
        cure_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Cursna Received - Unknown Cap. Multiplicative bonus to cursa chance to remove from healing skill
        --and cursna+ of caster. 1% for 1 cursna received.
        cursna_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Phalanx Received - Unkonwn Cap.  Stacks with Phalanx+ from caster.  Works with embolden.
        phalanx_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},

        },

        --Protect and Shell received - Potential that items do not stack.  Only the highest value is used.
        --Protect Received+ adds DEF.  Shell Received+ adds fractional MDT but does not exceed the 50% MDT cap.
        protect_shell_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Refresh duration increase gear.  No known cap.  Adds seconds to Refresh Duration.
        --Increase is flat and not multiplicative with other refresh buff extension spells and abilities.
        refresh_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Regen received potency
        --Final HP per Tick = Caster Base Spell Power + Caster Regen Potency Gear + Your Received Regen Gear
        regen_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Waltz Potency Received - 30% cap that stacks with Waltz Potency (outgoing) multiplicatively
        waltz_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },
    },
    ["CharacterFour"] = {
        --Cure Received Potency - 30% Cap.  Stacks with Cure Potency I 50% Max, Cure Potency II 30% Max
        --and Day/Weather Bonus
        cure_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Cursna Received - Unknown Cap. Multiplicative bonus to cursa chance to remove from healing skill
        --and cursna+ of caster. 1% for 1 cursna received.
        cursna_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Phalanx Received - Unkonwn Cap.  Stacks with Phalanx+ from caster.  Works with embolden.
        phalanx_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},

        },

        --Protect and Shell received - Potential that items do not stack.  Only the highest value is used.
        --Protect Received+ adds DEF.  Shell Received+ adds fractional MDT but does not exceed the 50% MDT cap.
        protect_shell_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Refresh duration increase gear.  No known cap.  Adds seconds to Refresh Duration.
        --Increase is flat and not multiplicative with other refresh buff extension spells and abilities.
        refresh_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Regen received potency
        --Final HP per Tick = Caster Base Spell Power + Caster Regen Potency Gear + Your Received Regen Gear
        regen_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Waltz Potency Received - 30% cap that stacks with Waltz Potency (outgoing) multiplicatively
        waltz_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },
    },
    ["CharacterFive"] = {
        --Cure Received Potency - 30% Cap.  Stacks with Cure Potency I 50% Max, Cure Potency II 30% Max
        --and Day/Weather Bonus
        cure_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Cursna Received - Unknown Cap. Multiplicative bonus to cursa chance to remove from healing skill
        --and cursna+ of caster. 1% for 1 cursna received.
        cursna_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Phalanx Received - Unkonwn Cap.  Stacks with Phalanx+ from caster.  Works with embolden.
        phalanx_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},

        },

        --Protect and Shell received - Potential that items do not stack.  Only the highest value is used.
        --Protect Received+ adds DEF.  Shell Received+ adds fractional MDT but does not exceed the 50% MDT cap.
        protect_shell_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Refresh duration increase gear.  No known cap.  Adds seconds to Refresh Duration.
        --Increase is flat and not multiplicative with other refresh buff extension spells and abilities.
        refresh_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Regen received potency
        --Final HP per Tick = Caster Base Spell Power + Caster Regen Potency Gear + Your Received Regen Gear
        regen_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Waltz Potency Received - 30% cap that stacks with Waltz Potency (outgoing) multiplicatively
        waltz_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },
    },
    ["CharacterSix"] = {
        --Cure Received Potency - 30% Cap.  Stacks with Cure Potency I 50% Max, Cure Potency II 30% Max
        --and Day/Weather Bonus
        cure_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Cursna Received - Unknown Cap. Multiplicative bonus to cursa chance to remove from healing skill
        --and cursna+ of caster. 1% for 1 cursna received.
        cursna_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Phalanx Received - Unkonwn Cap.  Stacks with Phalanx+ from caster.  Works with embolden.
        phalanx_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},

        },

        --Protect and Shell received - Potential that items do not stack.  Only the highest value is used.
        --Protect Received+ adds DEF.  Shell Received+ adds fractional MDT but does not exceed the 50% MDT cap.
        protect_shell_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Refresh duration increase gear.  No known cap.  Adds seconds to Refresh Duration.
        --Increase is flat and not multiplicative with other refresh buff extension spells and abilities.
        refresh_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Regen received potency
        --Final HP per Tick = Caster Base Spell Power + Caster Regen Potency Gear + Your Received Regen Gear
        regen_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Waltz Potency Received - 30% cap that stacks with Waltz Potency (outgoing) multiplicatively
        waltz_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },
    },
    ["CharacterSeven"] = {
        --Cure Received Potency - 30% Cap.  Stacks with Cure Potency I 50% Max, Cure Potency II 30% Max
        --and Day/Weather Bonus
        cure_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Cursna Received - Unknown Cap. Multiplicative bonus to cursa chance to remove from healing skill
        --and cursna+ of caster. 1% for 1 cursna received.
        cursna_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Phalanx Received - Unkonwn Cap.  Stacks with Phalanx+ from caster.  Works with embolden.
        phalanx_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},

        },

        --Protect and Shell received - Potential that items do not stack.  Only the highest value is used.
        --Protect Received+ adds DEF.  Shell Received+ adds fractional MDT but does not exceed the 50% MDT cap.
        protect_shell_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Refresh duration increase gear.  No known cap.  Adds seconds to Refresh Duration.
        --Increase is flat and not multiplicative with other refresh buff extension spells and abilities.
        refresh_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Regen received potency
        --Final HP per Tick = Caster Base Spell Power + Caster Regen Potency Gear + Your Received Regen Gear
        regen_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },

        --Waltz Potency Received - 30% cap that stacks with Waltz Potency (outgoing) multiplicatively
        waltz_set = {
            --Defaults to all_jobs if job specific set is not defined.  Uses job set if not empty.
            all_jobs = {},
            blm      = {},
            blu      = {},
            brd      = {},
            bst      = {},
            cor      = {},
            dnc      = {},
            drg      = {},
            drk      = {},
            geo      = {},
            mnk      = {},
            nin      = {},
            pld      = {},
            pup      = {},
            rdm      = {},
            rng      = {},
            run      = {},
            sam      = {},
            sch      = {},
            smn      = {},
            thf      = {},
            war      = {},
            whm      = {},
        },
    },


    --=====================================================================================--
    -- Available Spell Received Gear. Copy to your character block as desired
    -- Does not include augmented gear.  Use //gs export to get your augmented gear string
    -- Rings and Ears can be changed to left or right (left_ring, right_ring, left_ear, right_ear
    -- Duplicate items require separate wardrobe and priority to equip both at once e.g. Eshmun's Ring
    --=====================================================================================--

    --[[
===================================
Cure Received Potency Gear
Cure Received Potency - 30% Cap.  Stacks with Cure Potency I 50% Max, Cure Potency II 30% Max
and Day/Weather Bonus

main = "Reikono" --15%
main = "Nibiru Faussar" --10%
main = "Medicor Sword" --10%
main = "Sanus Ensis" -- 10%
main = "Eshus" --8%

sub = "Adamas" --15%

neck = "Phalaina Locket" --4%

waist = "Gishdubar Sash" --10%

left_ear = "Corybant Pearl" --Legion: 10%
left_ear = "Oneiros Earring" --5%

head = "Shabti Armet"
head = "Shabti Armet +1" --8%

hands = "Buremte Gloves" --5%

body = "Savas Jawshan" --7%
body = "Shedir Manteel" --3%

legs = "Souveran Diechlings" --7%
legs = "Souveran Diechlings +1" --8%

left_ring = "Vocane Ring" --5%
left_ring = "Vocane Ring +1" --6%
left_ring = "Kunaji Ring" --5%

=====================================
Cursna Received Potency Gear
Cursna Received - Unknown Cap. Multiplicative bonus to cursa chance to remove from healing skill
and cursna+ of caster. 1% for 1 cursna received. Does not apply to holy water usage unless stated.

neck = "Nicander's Necklace" -- +20 Cursna, +30 Holy Water

waist = "Gishdubar Sash" -- +10

legs = "Shabti Cuisses" -- +10
legs = "Shabti Cuisses +1" -- +10


left_ring = { name = "Eshmun's Ring", bag = "wardrobe3", priority = 1 }, -- +20
left_ring = { name = "Saida Ring", bag = "wardrobe3", priority = 1 },-- +10
left_ring = "Purity Ring" -- +7 Cursna, +7  Holy Water

=======================================
Phalanx Received Gear
Phalanx Received - Unkonwn Cap.  Stacks with Phalanx+ from caster.  Works with embolden.
Recommend using //gs export to get your exact augmented piece for geas fete and alluvion
gear to avoid equipping a duplicate non-augmented item

main = "Sakpata's Sword" -- 5
main = "Deacon Sword" --4
main = "Egeking" --3

sub = "Priwen" --2

head = "Futhark Bandeau" -- 4
head = "Futhark Bandeau +1" -- 5
head = "Futhark Bandeau +2" -- 6
head = "Futhark Bandeau +3" -- 7
head = "Sworn Crown" -- Augmented Amount 1-4
head = "Prestige Crown" -- Augmented Amount 1-4
head = "Trust Crown" -- Augmented Amount 1-4
head = "Herculean Helm" --Dark Matter Augmented 1-5.  Use //gs export
head = "Merlinic Hood" --Dark Matter Augmented 1-5.  Use //gs export
head = "Valorous Mask" --Dark Matter Augmented 1-5.  Use //gs export
head = "Chironic Hat" --Dark Matter Augmented 1-5.  Use //gs export
head = "Odyssean Helm" --Dark Matter Augmented 1-5.  Use //gs export
head = "Taeon Chapeau" --Duskdim Augment 1-3. Use //gs export
head = "Yorium Barbuta" --Duskdim Augment 1-3. Use //gs export


body = "Sworn Platemail" --Augmented Amount 1-6
body = "Prestige Platemail" --Augmented Amount 1-6
body = "Trust Platemail" --Augmented Amount 1-6
body = "Herculean Vest" --Dark Matter Augmented 1-5.  Use //gs export
body = "Merlinic Jubbah" --Dark Matter Augmented 1-5.  Use //gs export
body = "Valorous Mail" --Dark Matter Augmented 1-5.  Use //gs export
body = "Chironic Doublet" --Dark Matter Augmented 1-5.  Use //gs export
body = "Odyssean Chestplate" --Dark Matter Augmented 1-5.  Use //gs export
body = "Taeon Tabard" --Duskdim Augment 1-3. Use //gs export
body = "Yorium Cuirass" --Duskdim Augment 1-3. Use //gs export


hands = "Souveran Handschuhs" --4
hands = "Souveran Handschuhs +1" --5
hands = "Herculean Gloves" --Dark Matter Augmented 1-5.  Use //gs export
hands = "Merlinic Dastanas" --Dark Matter Augmented 1-5.  Use //gs export
hands = "Valorous Mitts" --Dark Matter Augmented 1-5.  Use //gs export
hands = "Chironic Gloves" --Dark Matter Augmented 1-5.  Use //gs export
hands = "Odyssean Gauntlets" --Dark Matter Augmented 1-5.  Use //gs export
hands = "Taeon Gloves" --Duskdim Augment 1-3. Use //gs export
hands = "Yorium Gauntlets" --Duskdim Augment 1-3. Use //gs export

legs = "Sakpata's Cuisses" --5
legs = "Herculean Trousers" --Dark Matter Augmented 1-5.  Use //gs export
legs = "Merlinic Shalwar" --Dark Matter Augmented 1-5.  Use //gs export
legs = "Valorous Hose" --Dark Matter Augmented 1-5.  Use //gs export
legs = "Chironic Hose" --Dark Matter Augmented 1-5.  Use //gs export
legs = "Odyssean Cuisses" --Dark Matter Augmented 1-5.  Use //gs export
legs = "Taeon Tights" --Duskdim Augment 1-3. Use //gs export
legs = "Yorium Cuisses" --Duskdim Augment 1-3. Use //gs export

feet = "Souveran Schuhs" --4
feet = "Souveran Schuhs +1" --5
feet = "Herculean Boots" --Dark Matter Augmented 1-5.  Use //gs export
feet = "Merlinic Crackows" --Dark Matter Augmented 1-5.  Use //gs export
feet = "Valorous Greaves" --Dark Matter Augmented 1-5.  Use //gs export
feet = "Chironic Slippers" --Dark Matter Augmented 1-5.  Use //gs export
feet = "Odyssean Greaves" --Dark Matter Augmented 1-5.  Use //gs export
feet = "Taeon Boots" --Duskdim Augment 1-3. Use //gs export
feet = "Yorium Sabatons" --Duskdim Augment 1-3. Use //gs export

back = "Weard Mantle" --Augmented Amount 3-5

========================================
Protect and Shell Received Gear
Protect and Shell received - Potential that items do not stack.  Only the highest value is used.
Protect Received+ adds DEF.  Shell Received+ adds fractional MDT through magid defense bonus.

left_ring = "Brachyura Earring" -- +10 Def to Protect V, +2 Magic Defense Bonus to Shell V
left_ring = "Sheltered Ring" -- +10 Def to Protect V, +2 Magic Defense Bonus to Shell V

=========================================
Refresh Received Gear
Refresh duration increase gear.  No known cap.  Adds seconds to Refresh Duration.
Increase is flat and not multiplicative with other refresh buff extension spells and abilities.

waist = "Gishdubar Sash" -- +20 Seconds

back = "Grapevine Cape" -- +30 Seconds

feet = "Inspired Boots" -- +15 Seconds

==========================================
Regen Received Gear
Final HP per Tick = Caster Base Spell Power + Caster Regen Potency Gear + Your Received Regen Gear

main = "Morgelai" -- +25 on Path C
main = "Peord Claymore" -- +20 on Path C
main = "Futhark Claymore" -- +15 on Path C

right_ear = "Erilaz Earring" -- +10 in Right Ear
right_ear = "Erilaz Earring +1" -- +11 in Right Ear
right_ear = "Erilaz Earring +2" -- +12 in Right Ear

==========================================
Waltz Received Gear
Waltz Potency Received - 30% cap that stacks with Waltz Potency (outgoing) multiplicatively

head = "Mummu Bonnet" -- 5%
head = "Mummu Bonnet +1" -- 8%
head = "Mummu Bonnet +2" -- 9%
head = "Taeon Chapeau" --Duskdim Augment 1-3. Use //gs export
head = "Yorium Barbuta" --Duskdim Augment 1-3. Use //gs export

body = "Maxixi Casaque" -- 5%
body = "Maxixi Casaque +1" -- 6%
body = "Maxixi Casaque +2" -- 7%
body = "Maxixi Casaque +3" -- 8%
body = "Taeon Tabard" --Duskdim Augment 1-3. Use //gs export
body = "Yorium Cuirass" --Duskdim Augment 1-3. Use //gs export

hands = "Taeon Gloves" --Duskdim Augment 1-3. Use //gs export
hands = "Yorium Gauntlets" --Duskdim Augment 1-3. Use //gs export

legs = "Taeon Tights" --Duskdim Augment 1-3. Use //gs export
legs = "Yorium Cuisses" --Duskdim Augment 1-3. Use //gs export

feet = "Taeon Boots" --Duskdim Augment 1-3. Use //gs export
feet = "Yorium Sabatons" --Duskdim Augment 1-3. Use //gs export

left_ring = "Asklepian Ring" -- 3%

]]
}
