--- STEAMODDED HEADER
--- MOD_NAME: TVFs Decks
--- MOD_ID: tvfsdecks
--- PREFIX: TVFD
--- MOD_AUTHOR: [TVFLabs]
--- MOD_DESCRIPTION: Adds some new decks
----------------------------------------------
------------MOD CODE ------------------------- 

SMODS.Atlas {
	key = 'tvfs_decks_backs_atlas',
	px = 71,
	py = 95,
	path = 'tvfs_decks_backs.png'
}

SMODS.Back {
	key = 'blank_deck',
	loc_txt = {
		name = 'Blank Deck',
		text = {'{C:inactive}No effects{}'}
	},
	atlas = 'tvfs_decks_backs_atlas',
	pos = { x = 0, y = 0 },
	config = {},
	unlocked = true,
	discovered = true,
}

last_before = false

SMODS.Back {
	key = 'bonus_deck',
	loc_txt = {
		name = 'Bonus Deck',
		text = {'{C:chips}+30{} chips'}
	},
	atlas = 'tvfs_decks_backs_atlas',
	pos = { x = 6, y = 0 },
	config = {},
	unlocked = true,
	discovered = true,
	calculate = function(self, back, context)
		if context.modify_hand then
			return {
				chips = 30
			}
		end
	end,
}

SMODS.Back {
	key = 'mult_deck',
	loc_txt = {
		name = 'Mult Deck',
		text = {'{C:mult}+4{} Mult'}
	},
	atlas = 'tvfs_decks_backs_atlas',
	pos = { x = 5, y = 0 },
	config = {},
	unlocked = true,
	discovered = true,
	calculate = function(self, back, context)
		if context.modify_hand then
			return {
				mult = 4
			}
		end
	end,
}

SMODS.Back {
	key = 'joke_deck',
	loc_txt = {
		name = 'Joke Deck',
		text = {'Start with {C:attention}2 random{}', '{C:attention}eternal Jokers{}'}
	},
	atlas = 'tvfs_decks_backs_atlas',
	pos = { x = 4, y = 0 },
	config = {},
	unlocked = true,
	discovered = true,
	apply = function(self, back)
		for i=1,2 do
			G.E_MANAGER:add_event(Event({
				func = function()
					
					local card = create_card('Joker', G.jokers, nil, pseudorandom('joke_deck', 0.4, 1.0), true, nil, nil, nil)
					card:set_eternal(true)
					while not card.ability.eternal do
						card:remove()
						card = create_card('Joker', G.jokers, nil, pseudorandom('joke_deck', 0.4, 1.0), true, nil, nil, nil)
						card:set_eternal(true)
					end
					card:add_to_deck()
					G.jokers:emplace(card)
					return true
				end
			}))
			
		end
	end,
}

SMODS.Back {
	key = 'chiseled_deck',
	loc_txt = {
		name = 'Chiseled Deck',
		text = {'Cards become {C:attention}Stone{}', 'when scored'}
	},
	atlas = 'tvfs_decks_backs_atlas',
	pos = { x = 3, y = 0 },
	config = {},
	unlocked = true,
	discovered = true,
	calculate = function(self, back, context)
		if context.final_scoring_step then
			for k, v in ipairs(context.scoring_hand) do
				if v.config.center ~= G.P_CENTERS.m_stone then
					v:set_ability(G.P_CENTERS.m_stone, nil, true)
					G.E_MANAGER:add_event(Event({
						func = function()
							v:juice_up()
							return true
						end
					})) 
				end
			end
		end
	end,
}

SMODS.Back {
	key = 'riffraff_deck',
	loc_txt = {
		name = 'Riff-Raff Deck',
		text = {'All base edition {C:blue}Common{}', 'Jokers become {C:dark_edition}Negative{}'}
	},
	atlas = 'tvfs_decks_backs_atlas',
	pos = { x = 7, y = 0 },
	config = {},
	unlocked = true,
	discovered = true,
	calculate = function(self, back, context)
		if (context.starting_shop or context.reroll_shop) and G.shop_jokers then
			if #G.shop_jokers.cards > 0 then
				for k,v in pairs(G.shop_jokers.cards) do
					if v.config and v.config.center then
						if v.config.center.set == 'Joker' and v.config.center.rarity == 1 then
							if (not v.edition) then
								v:set_edition({negative = true})
							end
						end
					end
				end
			end
		end
		if (context.open_booster) and context.cardarea then
			G.E_MANAGER:add_event(Event({
				func = (function()
					if G.pack_cards and G.pack_cards.cards then
						print(inspect(G.pack_cards.cards))
						if #G.pack_cards.cards > 0 then
							for k,v in pairs(G.pack_cards.cards) do
								if v.config and v.config.center then
									if v.config.center.set == 'Joker' and v.config.center.rarity == 1 then
										if (not v.edition) then
											v:set_edition({negative = true})
										end
									end
								end
							end
							return true
						end
					end
				end)
			}))
		end
		if (context.card_added) and context.card then
			if context.card.config and context.card.config.center then
				if context.card.config.center.set == 'Joker' and context.card.config.center.rarity == 1 then
					if (not context.card.edition) then
						context.card:set_edition({negative = true})
					end
				end
			end
		end
	end,
}

SMODS.Back {
	key = 'soul_deck',
	loc_txt = {
		name = 'Soul Deck',
		text = {'Start with {C:attention}eternal{}', 'copies of all 5', '{C:legendary,E:1}Legendary{} Jokers'}
	},
	atlas = 'tvfs_decks_backs_atlas',
	pos = { x = 8, y = 0 },
	config = {},
	unlocked = true,
	discovered = true,
	apply = function(self, back)
		G.E_MANAGER:add_event(Event({
			func = function()
				local cards_list = {'caino', 'triboulet', 'yorick', 'chicot', 'perkeo'}
				for k,v in pairs(cards_list) do
					local card = SMODS.create_card({set = 'Joker', area = G.jokers, skip_materialize = true, key = 'j_' .. v, no_edition = true})
					card:set_eternal(true)
					card:add_to_deck()
					G.jokers:emplace(card)
				end
				return true
			end
		}))
	end,
}

SMODS.Back {
	key = 'rainbow_deck',
	loc_txt = {
		name = 'Rainbow Deck',
		text = {'Applies the effects', 'of {C:dark_edition}all colored decks{}'}
	},
	atlas = 'tvfs_decks_backs_atlas',
	pos = { x = 1, y = 0 },
	config = {
		discards = 1,
		hands = 0,
		dollars = 10,
		extra_hand_bonus = 2,
		extra_discard_bonus = 1,
		no_interest = true,
		joker_slot = 1,
	},
	unlocked = true,
	discovered = true,
}

SMODS.Back {
	key = 'patchwork_deck',
	loc_txt = {
		name = 'Patchwork Deck',
		text = {'Applies the effects of', '{C:dark_edition}all decks{} from vanilla'}
	},
	atlas = 'tvfs_decks_backs_atlas',
	pos = { x = 2, y = 0 },
	config = {
		discards = 1,
		hands = 0,
		dollars = 10,
		extra_hand_bonus = 2,
		extra_discard_bonus = 1,
		no_interest = true,
		joker_slot = 0,
		vouchers = {'v_crystal_ball', 'v_telescope', 'v_tarot_merchant', 'v_planet_merchant', 'v_overstock_norm'},
		consumables = {'c_fool', 'c_fool', 'c_hex'},
		consumable_slot = -1,
		spectral_rate = 2,
		remove_faces = true,
		hand_size = 2,
		ante_scaling = 2,
		randomize_rank_suit = true,
	},
	unlocked = true,
	discovered = true,
	calculate = function(self, back, context)
		if context.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
			G.E_MANAGER:add_event(Event({
				func = (function()
					add_tag(Tag('tag_double'))
					play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
					play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
					return true
				end)
			}))
		end
		if context.context == 'blind_amount' then
			return 
		end

		if context.context == 'final_scoring_step' then
			local tot = context.chips + context.mult
			context.chips = math.floor(tot/2)
			context.mult = math.floor(tot/2)
			update_hand_text({delay = 0}, {mult = context.mult, chips = context.chips})

			G.E_MANAGER:add_event(Event({
				func = (function()
					local text = localize('k_balanced')
					play_sound('gong', 0.94, 0.3)
					play_sound('gong', 0.94*1.5, 0.2)
					play_sound('tarot1', 1.5)
					ease_colour(G.C.UI_CHIPS, {0.8, 0.45, 0.85, 1})
					ease_colour(G.C.UI_MULT, {0.8, 0.45, 0.85, 1})
					attention_text({
						scale = 1.4, text = text, hold = 2, align = 'cm', offset = {x = 0,y = -2.7},major = G.play
					})
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						blockable = false,
						blocking = false,
						delay =  4.3,
						func = (function() 
								ease_colour(G.C.UI_CHIPS, G.C.BLUE, 2)
								ease_colour(G.C.UI_MULT, G.C.RED, 2)
							return true
						end)
					}))
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						blockable = false,
						blocking = false,
						no_delete = true,
						delay =  6.3,
						func = (function() 
							G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
							G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
							return true
						end)
					}))
					return true
				end)
			}))

			delay(0.6)
			return context.chips, context.mult
		end
	end,
	apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.playing_cards) do
                    if v.base.suit == 'Clubs' then 
                        v:change_suit('Spades')
                    end
                    if v.base.suit == 'Diamonds' then 
                        v:change_suit('Hearts')
                    end
                end
            return true
            end
        }))
	end,
}



----------------------------------------------
------------MOD CODE END----------------------