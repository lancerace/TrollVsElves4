function trollnelves2:StartEventTest()
	ListenToGameEvent("team_info", Dynamic_Wrap(trollnelves2, 'On_team_info'), self)
	ListenToGameEvent("team_score", Dynamic_Wrap(trollnelves2, 'On_team_score'), self)
	ListenToGameEvent("teamplay_broadcast_audio", Dynamic_Wrap(trollnelves2, 'On_teamplay_broadcast_audio'), self)
	ListenToGameEvent("player_team", Dynamic_Wrap(trollnelves2, 'On_player_team'), self)
	ListenToGameEvent("player_class", Dynamic_Wrap(trollnelves2, 'On_player_class'), self)
	ListenToGameEvent("player_death", Dynamic_Wrap(trollnelves2, 'On_player_death '), self)
	ListenToGameEvent("player_hurt", Dynamic_Wrap(trollnelves2, 'On_player_hurt '), self)
	ListenToGameEvent("player_chat", Dynamic_Wrap(trollnelves2, 'On_player_chat '), self)
	ListenToGameEvent("player_score", Dynamic_Wrap(trollnelves2, 'On_player_score'), self)
	ListenToGameEvent("player_spawn", Dynamic_Wrap(trollnelves2, 'On_player_spawn'), self)
	ListenToGameEvent("player_shoot", Dynamic_Wrap(trollnelves2, 'On_player_shoot'), self)
	ListenToGameEvent("player_use", Dynamic_Wrap(trollnelves2, 'On_player_use'), self)
	ListenToGameEvent("player_changename", Dynamic_Wrap(trollnelves2, 'On_player_changename'), self)
	ListenToGameEvent("player_hintmessage", Dynamic_Wrap(trollnelves2, 'On_player_hintmessage'), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(trollnelves2, 'On_player_reconnected '), self)
	ListenToGameEvent("game_init", Dynamic_Wrap(trollnelves2, 'On_game_init'), self)
	ListenToGameEvent("game_newmap", Dynamic_Wrap(trollnelves2, 'On_game_newmap'), self)
	ListenToGameEvent("game_start", Dynamic_Wrap(trollnelves2, 'On_game_start'), self)
	ListenToGameEvent("game_end", Dynamic_Wrap(trollnelves2, 'On_game_end'), self)
	ListenToGameEvent("round_start", Dynamic_Wrap(trollnelves2, 'On_round_start'), self)
	ListenToGameEvent("round_end", Dynamic_Wrap(trollnelves2, 'On_round_end'), self)
	ListenToGameEvent("round_start_pre_entity", Dynamic_Wrap(trollnelves2, 'On_round_start_pre_entity'), self)
	ListenToGameEvent("teamplay_round_start", Dynamic_Wrap(trollnelves2, 'On_teamplay_round_start'), self)
	ListenToGameEvent("hostname_changed", Dynamic_Wrap(trollnelves2, 'On_hostname_changed'), self)
	ListenToGameEvent("difficulty_changed", Dynamic_Wrap(trollnelves2, 'On_difficulty_changed'), self)
	ListenToGameEvent("finale_start", Dynamic_Wrap(trollnelves2, 'On_finale_start'), self)
	ListenToGameEvent("game_message", Dynamic_Wrap(trollnelves2, 'On_game_message'), self)
	ListenToGameEvent("break_breakable", Dynamic_Wrap(trollnelves2, 'On_break_breakable'), self)
	ListenToGameEvent("break_prop", Dynamic_Wrap(trollnelves2, 'On_break_prop'), self)
	--ListenToGameEvent("npc_spawned", Dynamic_Wrap(trollnelves2, 'On_npc_spawned'), self)
	ListenToGameEvent("npc_replaced", Dynamic_Wrap(trollnelves2, 'On_npc_replaced'), self)
	--ListenToGameEvent("entity_killed", Dynamic_Wrap(trollnelves2, 'On_entity_killed'), self)
	--ListenToGameEvent("entity_hurt", Dynamic_Wrap(trollnelves2, 'On_entity_hurt'), self)
	ListenToGameEvent("bonus_updated", Dynamic_Wrap(trollnelves2, 'On_bonus_updated'), self)
	ListenToGameEvent("player_stats_updated", Dynamic_Wrap(trollnelves2, 'On_player_stats_updated'), self)
	ListenToGameEvent("achievement_event", Dynamic_Wrap(trollnelves2, 'On_achievement_event'), self)
	ListenToGameEvent("achievement_earned", Dynamic_Wrap(trollnelves2, 'On_achievement_earned'), self)
	ListenToGameEvent("achievement_write_failed", Dynamic_Wrap(trollnelves2, 'On_achievement_write_failed'), self)
	ListenToGameEvent("physgun_pickup", Dynamic_Wrap(trollnelves2, 'On_physgun_pickup'), self)
	ListenToGameEvent("flare_ignite_npc", Dynamic_Wrap(trollnelves2, 'On_flare_ignite_npc'), self)
	ListenToGameEvent("helicopter_grenade_punt_miss", Dynamic_Wrap(trollnelves2, 'On_helicopter_grenade_punt_miss'), self)
	ListenToGameEvent("user_data_downloaded", Dynamic_Wrap(trollnelves2, 'On_user_data_downloaded'), self)
	ListenToGameEvent("ragdoll_dissolved", Dynamic_Wrap(trollnelves2, 'On_ragdoll_dissolved'), self)
	ListenToGameEvent("gameinstructor_draw", Dynamic_Wrap(trollnelves2, 'On_gameinstructor_draw'), self)
	ListenToGameEvent("gameinstructor_nodraw", Dynamic_Wrap(trollnelves2, 'On_gameinstructor_nodraw'), self)
	ListenToGameEvent("map_transition", Dynamic_Wrap(trollnelves2, 'On_map_transition'), self)
	ListenToGameEvent("instructor_server_hint_create", Dynamic_Wrap(trollnelves2, 'On_instructor_server_hint_create'), self)
	ListenToGameEvent("instructor_server_hint_stop", Dynamic_Wrap(trollnelves2, 'On_instructor_server_hint_stop'), self)
	ListenToGameEvent("chat_new_message", Dynamic_Wrap(trollnelves2, 'On_chat_new_message'), self)
	ListenToGameEvent("chat_members_changed", Dynamic_Wrap(trollnelves2, 'On_chat_members_changed'), self)
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(trollnelves2, 'On_game_rules_state_change'), self)
	ListenToGameEvent("inventory_updated", Dynamic_Wrap(trollnelves2, 'On_inventory_updated'), self)
	ListenToGameEvent("cart_updated", Dynamic_Wrap(trollnelves2, 'On_cart_updated'), self)
	ListenToGameEvent("store_pricesheet_updated", Dynamic_Wrap(trollnelves2, 'On_store_pricesheet_updated'), self)
	ListenToGameEvent("gc_connected", Dynamic_Wrap(trollnelves2, 'On_gc_connected'), self)
	ListenToGameEvent("item_schema_initialized", Dynamic_Wrap(trollnelves2, 'On_item_schema_initialized'), self)
	ListenToGameEvent("drop_rate_modified", Dynamic_Wrap(trollnelves2, 'On_drop_rate_modified'), self)
	ListenToGameEvent("event_ticket_modified", Dynamic_Wrap(trollnelves2, 'On_event_ticket_modified'), self)
	ListenToGameEvent("modifier_event", Dynamic_Wrap(trollnelves2, 'On_modifier_event'), self)
	ListenToGameEvent("dota_player_kill", Dynamic_Wrap(trollnelves2, 'On_dota_player_kill'), self)
	ListenToGameEvent("dota_player_deny", Dynamic_Wrap(trollnelves2, 'On_dota_player_deny'), self)
	ListenToGameEvent("dota_barracks_kill", Dynamic_Wrap(trollnelves2, 'On_dota_barracks_kill'), self)
	ListenToGameEvent("dota_tower_kill", Dynamic_Wrap(trollnelves2, 'On_dota_tower_kill'), self)
	ListenToGameEvent("dota_roshan_kill", Dynamic_Wrap(trollnelves2, 'On_dota_roshan_kill'), self)
	ListenToGameEvent("dota_courier_lost", Dynamic_Wrap(trollnelves2, 'On_dota_courier_lost'), self)
	ListenToGameEvent("dota_courier_respawned", Dynamic_Wrap(trollnelves2, 'On_dota_courier_respawned'), self)
	ListenToGameEvent("dota_glyph_used", Dynamic_Wrap(trollnelves2, 'On_dota_glyph_used'), self)
	ListenToGameEvent("dota_super_creeps", Dynamic_Wrap(trollnelves2, 'On_dota_super_creeps'), self)
	ListenToGameEvent("dota_item_purchase", Dynamic_Wrap(trollnelves2, 'On_dota_item_purchase'), self)
	ListenToGameEvent("dota_item_gifted", Dynamic_Wrap(trollnelves2, 'On_dota_item_gifted'), self)
	ListenToGameEvent("dota_rune_pickup", Dynamic_Wrap(trollnelves2, 'On_dota_rune_pickup'), self)
	ListenToGameEvent("dota_rune_spotted", Dynamic_Wrap(trollnelves2, 'On_dota_rune_spotted'), self)
	ListenToGameEvent("dota_item_spotted", Dynamic_Wrap(trollnelves2, 'On_dota_item_spotted'), self)
	ListenToGameEvent("dota_no_battle_points", Dynamic_Wrap(trollnelves2, 'On_dota_no_battle_points'), self)
	ListenToGameEvent("dota_chat_informational", Dynamic_Wrap(trollnelves2, 'On_dota_chat_informational'), self)
	ListenToGameEvent("dota_action_item", Dynamic_Wrap(trollnelves2, 'On_dota_action_item'), self)
	ListenToGameEvent("dota_chat_ban_notification", Dynamic_Wrap(trollnelves2, 'On_dota_chat_ban_notification'), self)
	ListenToGameEvent("dota_chat_event", Dynamic_Wrap(trollnelves2, 'On_dota_chat_event'), self)
	ListenToGameEvent("dota_chat_timed_reward", Dynamic_Wrap(trollnelves2, 'On_dota_chat_timed_reward'), self)
	ListenToGameEvent("dota_pause_event", Dynamic_Wrap(trollnelves2, 'On_dota_pause_event'), self)
	ListenToGameEvent("dota_chat_kill_streak", Dynamic_Wrap(trollnelves2, 'On_dota_chat_kill_streak'), self)
	ListenToGameEvent("dota_chat_first_blood", Dynamic_Wrap(trollnelves2, 'On_dota_chat_first_blood'), self)
	ListenToGameEvent("dota_player_update_hero_selection", Dynamic_Wrap(trollnelves2, 'On_dota_player_update_hero_selection'), self)
	ListenToGameEvent("dota_player_update_selected_unit", Dynamic_Wrap(trollnelves2, 'On_dota_player_update_selected_unit'), self)
	ListenToGameEvent("dota_player_update_query_unit", Dynamic_Wrap(trollnelves2, 'On_dota_player_update_query_unit'), self)
	ListenToGameEvent("dota_player_update_killcam_unit", Dynamic_Wrap(trollnelves2, 'On_dota_player_update_killcam_unit'), self)
	ListenToGameEvent("dota_player_take_tower_damage", Dynamic_Wrap(trollnelves2, 'On_dota_player_take_tower_damage'), self)
	ListenToGameEvent("dota_hud_error_message", Dynamic_Wrap(trollnelves2, 'On_dota_hud_error_message'), self)
	ListenToGameEvent("dota_action_success", Dynamic_Wrap(trollnelves2, 'On_dota_action_success'), self)
	ListenToGameEvent("dota_starting_position_changed", Dynamic_Wrap(trollnelves2, 'On_dota_starting_position_changed'), self)
	ListenToGameEvent("dota_money_changed", Dynamic_Wrap(trollnelves2, 'On_dota_money_changed'), self)
	ListenToGameEvent("dota_enemy_money_changed", Dynamic_Wrap(trollnelves2, 'On_dota_enemy_money_changed'), self)
	ListenToGameEvent("dota_portrait_unit_stats_changed", Dynamic_Wrap(trollnelves2, 'On_dota_portrait_unit_stats_changed'), self)
	ListenToGameEvent("dota_portrait_unit_modifiers_changed", Dynamic_Wrap(trollnelves2, 'On_dota_portrait_unit_modifiers_changed'), self)
	ListenToGameEvent("dota_force_portrait_update", Dynamic_Wrap(trollnelves2, 'On_dota_force_portrait_update'), self)
	ListenToGameEvent("dota_inventory_changed", Dynamic_Wrap(trollnelves2, 'On_dota_inventory_changed'), self)
	ListenToGameEvent("dota_item_picked_up", Dynamic_Wrap(trollnelves2, 'On_dota_item_picked_up'), self)
	ListenToGameEvent("dota_inventory_item_changed", Dynamic_Wrap(trollnelves2, 'On_dota_inventory_item_changed'), self)
	ListenToGameEvent("dota_ability_changed", Dynamic_Wrap(trollnelves2, 'On_dota_ability_changed'), self)
	ListenToGameEvent("dota_portrait_ability_layout_changed", Dynamic_Wrap(trollnelves2, 'On_dota_portrait_ability_layout_changed'), self)
	ListenToGameEvent("dota_inventory_item_added", Dynamic_Wrap(trollnelves2, 'On_dota_inventory_item_added'), self)
	ListenToGameEvent("dota_inventory_changed_query_unit", Dynamic_Wrap(trollnelves2, 'On_dota_inventory_changed_query_unit'), self)
	ListenToGameEvent("dota_link_clicked", Dynamic_Wrap(trollnelves2, 'On_dota_link_clicked'), self)
	ListenToGameEvent("dota_set_quick_buy", Dynamic_Wrap(trollnelves2, 'On_dota_set_quick_buy'), self)
	ListenToGameEvent("dota_quick_buy_changed", Dynamic_Wrap(trollnelves2, 'On_dota_quick_buy_changed'), self)
	ListenToGameEvent("dota_player_shop_changed", Dynamic_Wrap(trollnelves2, 'On_dota_player_shop_changed'), self)
	ListenToGameEvent("dota_player_show_killcam", Dynamic_Wrap(trollnelves2, 'On_dota_player_show_killcam'), self)
	ListenToGameEvent("dota_player_show_minikillcam", Dynamic_Wrap(trollnelves2, 'On_dota_player_show_minikillcam'), self)
	ListenToGameEvent("gc_user_session_created", Dynamic_Wrap(trollnelves2, 'On_gc_user_session_created'), self)
	ListenToGameEvent("team_data_updated", Dynamic_Wrap(trollnelves2, 'On_team_data_updated'), self)
	ListenToGameEvent("guild_data_updated", Dynamic_Wrap(trollnelves2, 'On_guild_data_updated'), self)
	ListenToGameEvent("guild_open_parties_updated", Dynamic_Wrap(trollnelves2, 'On_guild_open_parties_updated'), self)
	ListenToGameEvent("fantasy_updated", Dynamic_Wrap(trollnelves2, 'On_fantasy_updated'), self)
	ListenToGameEvent("fantasy_league_changed", Dynamic_Wrap(trollnelves2, 'On_fantasy_league_changed'), self)
	ListenToGameEvent("fantasy_score_info_changed", Dynamic_Wrap(trollnelves2, 'On_fantasy_score_info_changed'), self)
	ListenToGameEvent("player_info_updated", Dynamic_Wrap(trollnelves2, 'On_player_info_updated'), self)
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(trollnelves2, 'On_game_rules_state_change'), self)
	ListenToGameEvent("match_history_updated", Dynamic_Wrap(trollnelves2, 'On_match_history_updated'), self)
	ListenToGameEvent("match_details_updated", Dynamic_Wrap(trollnelves2, 'On_match_details_updated'), self)
	ListenToGameEvent("live_games_updated", Dynamic_Wrap(trollnelves2, 'On_live_games_updated'), self)
	ListenToGameEvent("recent_matches_updated", Dynamic_Wrap(trollnelves2, 'On_recent_matches_updated'), self)
	ListenToGameEvent("news_updated", Dynamic_Wrap(trollnelves2, 'On_news_updated'), self)
	ListenToGameEvent("persona_updated", Dynamic_Wrap(trollnelves2, 'On_persona_updated'), self)
	ListenToGameEvent("tournament_state_updated", Dynamic_Wrap(trollnelves2, 'On_tournament_state_updated'), self)
	ListenToGameEvent("party_updated", Dynamic_Wrap(trollnelves2, 'On_party_updated'), self)
	ListenToGameEvent("lobby_updated", Dynamic_Wrap(trollnelves2, 'On_lobby_updated'), self)
	ListenToGameEvent("dashboard_caches_cleared", Dynamic_Wrap(trollnelves2, 'On_dashboard_caches_cleared'), self)
	ListenToGameEvent("last_hit", Dynamic_Wrap(trollnelves2, 'On_last_hit'), self)
	ListenToGameEvent("player_completed_game", Dynamic_Wrap(trollnelves2, 'On_player_completed_game'), self)
	--ListenToGameEvent("dota_combatlog", Dynamic_Wrap(trollnelves2, 'On_dota_combatlog'), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(trollnelves2, 'On_player_reconnected'), self)
	ListenToGameEvent("nommed_tree", Dynamic_Wrap(trollnelves2, 'On_nommed_tree'), self)
	ListenToGameEvent("dota_rune_activated_server", Dynamic_Wrap(trollnelves2, 'On_dota_rune_activated_server'), self)
	ListenToGameEvent("dota_player_gained_level", Dynamic_Wrap(trollnelves2, 'On_dota_player_gained_level'), self)
	ListenToGameEvent("dota_player_pick_hero", Dynamic_Wrap(trollnelves2, 'On_dota_player_pick_hero'), self)
	ListenToGameEvent("dota_player_learned_ability", Dynamic_Wrap(trollnelves2, 'On_dota_player_learned_ability'), self)
	ListenToGameEvent("dota_player_used_ability", Dynamic_Wrap(trollnelves2, 'On_dota_player_used_ability'), self)
	ListenToGameEvent("dota_non_player_used_ability", Dynamic_Wrap(trollnelves2, 'On_dota_non_player_used_ability'), self)
	ListenToGameEvent("dota_ability_channel_finished", Dynamic_Wrap(trollnelves2, 'On_dota_ability_channel_finished'), self)
	ListenToGameEvent("dota_holdout_revive_complete", Dynamic_Wrap(trollnelves2, 'On_dota_holdout_revive_complete'), self)
	ListenToGameEvent("dota_player_killed", Dynamic_Wrap(trollnelves2, 'On_dota_player_killed'), self)
	ListenToGameEvent("bindpanel_open", Dynamic_Wrap(trollnelves2, 'On_bindpanel_open'), self)
	ListenToGameEvent("bindpanel_close", Dynamic_Wrap(trollnelves2, 'On_bindpanel_close'), self)
	ListenToGameEvent("keybind_changed", Dynamic_Wrap(trollnelves2, 'On_keybind_changed'), self)
	ListenToGameEvent("dota_item_drag_begin", Dynamic_Wrap(trollnelves2, 'On_dota_item_drag_begin'), self)
	ListenToGameEvent("dota_item_drag_end", Dynamic_Wrap(trollnelves2, 'On_dota_item_drag_end'), self)
	ListenToGameEvent("dota_shop_item_drag_begin", Dynamic_Wrap(trollnelves2, 'On_dota_shop_item_drag_begin'), self)
	ListenToGameEvent("dota_shop_item_drag_end", Dynamic_Wrap(trollnelves2, 'On_dota_shop_item_drag_end'), self)
	ListenToGameEvent("dota_item_purchased", Dynamic_Wrap(trollnelves2, 'On_dota_item_purchased'), self)
	ListenToGameEvent("dota_item_used", Dynamic_Wrap(trollnelves2, 'On_dota_item_used'), self)
	ListenToGameEvent("dota_item_auto_purchase", Dynamic_Wrap(trollnelves2, 'On_dota_item_auto_purchase'), self)
	ListenToGameEvent("dota_unit_event", Dynamic_Wrap(trollnelves2, 'On_dota_unit_event'), self)
	ListenToGameEvent("dota_quest_started", Dynamic_Wrap(trollnelves2, 'On_dota_quest_started'), self)
	ListenToGameEvent("dota_quest_completed", Dynamic_Wrap(trollnelves2, 'On_dota_quest_completed'), self)
	ListenToGameEvent("gameui_activated", Dynamic_Wrap(trollnelves2, 'On_gameui_activated'), self)
	ListenToGameEvent("gameui_hidden", Dynamic_Wrap(trollnelves2, 'On_gameui_hidden'), self)
	ListenToGameEvent("player_fullyjoined", Dynamic_Wrap(trollnelves2, 'On_player_fullyjoined'), self)
	ListenToGameEvent("dota_spectate_hero", Dynamic_Wrap(trollnelves2, 'On_dota_spectate_hero'), self)
	ListenToGameEvent("dota_match_done", Dynamic_Wrap(trollnelves2, 'On_dota_match_done'), self)
	ListenToGameEvent("dota_match_done_client", Dynamic_Wrap(trollnelves2, 'On_dota_match_done_client'), self)
	ListenToGameEvent("set_instructor_group_enabled", Dynamic_Wrap(trollnelves2, 'On_set_instructor_group_enabled'), self)
	ListenToGameEvent("joined_chat_channel", Dynamic_Wrap(trollnelves2, 'On_joined_chat_channel'), self)
	ListenToGameEvent("left_chat_channel", Dynamic_Wrap(trollnelves2, 'On_left_chat_channel'), self)
	ListenToGameEvent("gc_chat_channel_list_updated", Dynamic_Wrap(trollnelves2, 'On_gc_chat_channel_list_updated'), self)
	ListenToGameEvent("today_messages_updated", Dynamic_Wrap(trollnelves2, 'On_today_messages_updated'), self)
	ListenToGameEvent("file_downloaded", Dynamic_Wrap(trollnelves2, 'On_file_downloaded'), self)
	ListenToGameEvent("player_report_counts_updated", Dynamic_Wrap(trollnelves2, 'On_player_report_counts_updated'), self)
	ListenToGameEvent("scaleform_file_download_complete", Dynamic_Wrap(trollnelves2, 'On_scaleform_file_download_complete'), self)
	ListenToGameEvent("item_purchased", Dynamic_Wrap(trollnelves2, 'On_item_purchased'), self)
	ListenToGameEvent("gc_mismatched_version", Dynamic_Wrap(trollnelves2, 'On_gc_mismatched_version'), self)
	ListenToGameEvent("demo_skip", Dynamic_Wrap(trollnelves2, 'On_demo_skip'), self)
	ListenToGameEvent("demo_start", Dynamic_Wrap(trollnelves2, 'On_demo_start'), self)
	ListenToGameEvent("demo_stop", Dynamic_Wrap(trollnelves2, 'On_demo_stop'), self)
	ListenToGameEvent("map_shutdown", Dynamic_Wrap(trollnelves2, 'On_map_shutdown'), self)
	ListenToGameEvent("dota_workshop_fileselected", Dynamic_Wrap(trollnelves2, 'On_dota_workshop_fileselected'), self)
	ListenToGameEvent("dota_workshop_filecanceled", Dynamic_Wrap(trollnelves2, 'On_dota_workshop_filecanceled'), self)
	ListenToGameEvent("rich_presence_updated", Dynamic_Wrap(trollnelves2, 'On_rich_presence_updated'), self)
	ListenToGameEvent("dota_hero_random", Dynamic_Wrap(trollnelves2, 'On_dota_hero_random'), self)
	ListenToGameEvent("dota_rd_chat_turn", Dynamic_Wrap(trollnelves2, 'On_dota_rd_chat_turn'), self)
	ListenToGameEvent("dota_favorite_heroes_updated", Dynamic_Wrap(trollnelves2, 'On_dota_favorite_heroes_updated'), self)
	ListenToGameEvent("profile_closed", Dynamic_Wrap(trollnelves2, 'On_profile_closed'), self)
	ListenToGameEvent("item_preview_closed", Dynamic_Wrap(trollnelves2, 'On_item_preview_closed'), self)
	ListenToGameEvent("dashboard_switched_section", Dynamic_Wrap(trollnelves2, 'On_dashboard_switched_section'), self)
	ListenToGameEvent("dota_tournament_item_event", Dynamic_Wrap(trollnelves2, 'On_dota_tournament_item_event'), self)
	ListenToGameEvent("dota_hero_swap", Dynamic_Wrap(trollnelves2, 'On_dota_hero_swap'), self)
	ListenToGameEvent("dota_reset_suggested_items", Dynamic_Wrap(trollnelves2, 'On_dota_reset_suggested_items'), self)
	ListenToGameEvent("halloween_high_score_received", Dynamic_Wrap(trollnelves2, 'On_halloween_high_score_received'), self)
	ListenToGameEvent("halloween_phase_end", Dynamic_Wrap(trollnelves2, 'On_halloween_phase_end'), self)
	ListenToGameEvent("halloween_high_score_request_failed", Dynamic_Wrap(trollnelves2, 'On_halloween_high_score_request_failed'), self)
	ListenToGameEvent("dota_hud_skin_changed", Dynamic_Wrap(trollnelves2, 'On_dota_hud_skin_changed'), self)
	ListenToGameEvent("dota_inventory_player_got_item", Dynamic_Wrap(trollnelves2, 'On_dota_inventory_player_got_item'), self)
	ListenToGameEvent("player_is_experienced", Dynamic_Wrap(trollnelves2, 'On_player_is_experienced'), self)
	ListenToGameEvent("player_is_notexperienced", Dynamic_Wrap(trollnelves2, 'On_player_is_notexperienced'), self)
	ListenToGameEvent("dota_tutorial_lesson_start", Dynamic_Wrap(trollnelves2, 'On_dota_tutorial_lesson_start'), self)
	ListenToGameEvent("map_location_updated", Dynamic_Wrap(trollnelves2, 'On_map_location_updated'), self)
	ListenToGameEvent("richpresence_custom_updated", Dynamic_Wrap(trollnelves2, 'On_richpresence_custom_updated'), self)
	ListenToGameEvent("game_end_visible", Dynamic_Wrap(trollnelves2, 'On_game_end_visible'), self)
	ListenToGameEvent("antiaddiction_update", Dynamic_Wrap(trollnelves2, 'On_antiaddiction_update'), self)
	ListenToGameEvent("highlight_hud_element", Dynamic_Wrap(trollnelves2, 'On_highlight_hud_element'), self)
	ListenToGameEvent("hide_highlight_hud_element", Dynamic_Wrap(trollnelves2, 'On_hide_highlight_hud_element'), self)
	ListenToGameEvent("intro_video_finished", Dynamic_Wrap(trollnelves2, 'On_intro_video_finished'), self)
	ListenToGameEvent("matchmaking_status_visibility_changed", Dynamic_Wrap(trollnelves2, 'On_matchmaking_status_visibility_changed'), self)
	ListenToGameEvent("practice_lobby_visibility_changed", Dynamic_Wrap(trollnelves2, 'On_practice_lobby_visibility_changed'), self)
	ListenToGameEvent("dota_courier_transfer_item", Dynamic_Wrap(trollnelves2, 'On_dota_courier_transfer_item'), self)
	ListenToGameEvent("full_ui_unlocked", Dynamic_Wrap(trollnelves2, 'On_full_ui_unlocked'), self)
	ListenToGameEvent("client_connectionless_packet", Dynamic_Wrap(trollnelves2, 'On_client_connectionless_packet'), self)
	ListenToGameEvent("hero_selector_preview_set", Dynamic_Wrap(trollnelves2, 'On_hero_selector_preview_set'), self)
	ListenToGameEvent("antiaddiction_toast", Dynamic_Wrap(trollnelves2, 'On_antiaddiction_toast'), self)
	ListenToGameEvent("hero_picker_shown", Dynamic_Wrap(trollnelves2, 'On_hero_picker_shown'), self)
	ListenToGameEvent("hero_picker_hidden", Dynamic_Wrap(trollnelves2, 'On_hero_picker_hidden'), self)
	ListenToGameEvent("dota_local_quickbuy_changed", Dynamic_Wrap(trollnelves2, 'On_dota_local_quickbuy_changed'), self)
	ListenToGameEvent("show_center_message", Dynamic_Wrap(trollnelves2, 'On_show_center_message'), self)
	ListenToGameEvent("hud_flip_changed", Dynamic_Wrap(trollnelves2, 'On_hud_flip_changed'), self)
	ListenToGameEvent("frosty_points_updated", Dynamic_Wrap(trollnelves2, 'On_frosty_points_updated'), self)
	ListenToGameEvent("defeated", Dynamic_Wrap(trollnelves2, 'On_defeated'), self)
	ListenToGameEvent("reset_defeated", Dynamic_Wrap(trollnelves2, 'On_reset_defeated'), self)
	ListenToGameEvent("booster_state_updated", Dynamic_Wrap(trollnelves2, 'On_booster_state_updated'), self)
	ListenToGameEvent("event_points_updated", Dynamic_Wrap(trollnelves2, 'On_event_points_updated'), self)
	ListenToGameEvent("local_player_event_points", Dynamic_Wrap(trollnelves2, 'On_local_player_event_points'), self)
	ListenToGameEvent("custom_game_difficulty", Dynamic_Wrap(trollnelves2, 'On_custom_game_difficulty'), self)
	ListenToGameEvent("tree_cut", Dynamic_Wrap(trollnelves2, 'On_tree_cut'), self)
	ListenToGameEvent("ugc_details_arrived", Dynamic_Wrap(trollnelves2, 'On_ugc_details_arrived'), self)
	ListenToGameEvent("ugc_subscribed", Dynamic_Wrap(trollnelves2, 'On_ugc_subscribed'), self)
	ListenToGameEvent("ugc_unsubscribed", Dynamic_Wrap(trollnelves2, 'On_ugc_unsubscribed'), self)
	ListenToGameEvent("prizepool_received", Dynamic_Wrap(trollnelves2, 'On_prizepool_received'), self)
	ListenToGameEvent("microtransaction_success", Dynamic_Wrap(trollnelves2, 'On_microtransaction_success'), self)
	ListenToGameEvent("dota_rubick_ability_steal", Dynamic_Wrap(trollnelves2, 'On_dota_rubick_ability_steal'), self)
	ListenToGameEvent("compendium_event_actions_loaded", Dynamic_Wrap(trollnelves2, 'On_compendium_event_actions_loaded'), self)
	ListenToGameEvent("compendium_selections_loaded", Dynamic_Wrap(trollnelves2, 'On_compendium_selections_loaded'), self)
	ListenToGameEvent("compendium_set_selection_failed", Dynamic_Wrap(trollnelves2, 'On_compendium_set_selection_failed'), self)
	ListenToGameEvent("community_cached_names_updated", Dynamic_Wrap(trollnelves2, 'On_community_cached_names_updated'), self)
	ListenToGameEvent("dota_team_kill_credit", Dynamic_Wrap(trollnelves2, 'On_dota_team_kill_credit'), self)

	ListenToGameEvent("dota_effigy_kill", Dynamic_Wrap(trollnelves2, 'On_dota_effigy_kill'), self)
	ListenToGameEvent("dota_chat_assassin_announce", Dynamic_Wrap(trollnelves2, 'On_dota_chat_assassin_announce'), self)
	ListenToGameEvent("dota_chat_assassin_denied", Dynamic_Wrap(trollnelves2, 'On_dota_chat_assassin_denied'), self)
	ListenToGameEvent("dota_chat_assassin_success", Dynamic_Wrap(trollnelves2, 'On_dota_chat_assassin_success'), self)
	ListenToGameEvent("player_info_individual_updated", Dynamic_Wrap(trollnelves2, 'On_player_info_individual_updated'), self)
	ListenToGameEvent("dota_player_begin_cast", Dynamic_Wrap(trollnelves2, 'On_dota_player_begin_cast'), self)
	ListenToGameEvent("dota_non_player_begin_cast", Dynamic_Wrap(trollnelves2, 'On_dota_non_player_begin_cast'), self)
	ListenToGameEvent("dota_item_combined", Dynamic_Wrap(trollnelves2, 'On_dota_item_combined'), self)
	ListenToGameEvent("profile_opened", Dynamic_Wrap(trollnelves2, 'On_profile_opened'), self)
	ListenToGameEvent("dota_tutorial_task_advance", Dynamic_Wrap(trollnelves2, 'On_dota_tutorial_task_advance'), self)
	ListenToGameEvent("dota_tutorial_shop_toggled", Dynamic_Wrap(trollnelves2, 'On_dota_tutorial_shop_toggled'), self)
	ListenToGameEvent("ugc_download_requested", Dynamic_Wrap(trollnelves2, 'On_ugc_download_requested'), self)
	ListenToGameEvent("ugc_installed", Dynamic_Wrap(trollnelves2, 'On_ugc_installed'), self)
	ListenToGameEvent("compendium_trophies_loaded", Dynamic_Wrap(trollnelves2, 'On_compendium_trophies_loaded'), self)
	ListenToGameEvent("spec_item_pickup", Dynamic_Wrap(trollnelves2, 'On_spec_item_pickup'), self)
	ListenToGameEvent("spec_aegis_reclaim_time", Dynamic_Wrap(trollnelves2, 'On_spec_aegis_reclaim_time'), self)
	ListenToGameEvent("account_trophies_changed", Dynamic_Wrap(trollnelves2, 'On_account_trophies_changed'), self)
	ListenToGameEvent("account_all_hero_challenge_changed", Dynamic_Wrap(trollnelves2, 'On_account_all_hero_challenge_changed'), self)
	ListenToGameEvent("team_showcase_ui_update", Dynamic_Wrap(trollnelves2, 'On_team_showcase_ui_update'), self)
	ListenToGameEvent("ingame_events_changed", Dynamic_Wrap(trollnelves2, 'On_ingame_events_changed'), self)
	ListenToGameEvent("dota_match_signout", Dynamic_Wrap(trollnelves2, 'On_dota_match_signout'), self)
	ListenToGameEvent("dota_illusions_created", Dynamic_Wrap(trollnelves2, 'On_dota_illusions_created'), self)
	ListenToGameEvent("dota_year_beast_killed", Dynamic_Wrap(trollnelves2, 'On_dota_year_beast_killed'), self)
	ListenToGameEvent("dota_hero_undoselection", Dynamic_Wrap(trollnelves2, 'On_dota_hero_undoselection'), self)
	ListenToGameEvent("dota_challenge_socache_updated", Dynamic_Wrap(trollnelves2, 'On_dota_challenge_socache_updated'), self)
	ListenToGameEvent("party_invites_updated", Dynamic_Wrap(trollnelves2, 'On_party_invites_updated'), self)
	ListenToGameEvent("lobby_invites_updated", Dynamic_Wrap(trollnelves2, 'On_lobby_invites_updated'), self)
	ListenToGameEvent("custom_game_mode_list_updated", Dynamic_Wrap(trollnelves2, 'On_custom_game_mode_list_updated'), self)
	ListenToGameEvent("custom_game_lobby_list_updated", Dynamic_Wrap(trollnelves2, 'On_custom_game_lobby_list_updated'), self)
	ListenToGameEvent("friend_lobby_list_updated", Dynamic_Wrap(trollnelves2, 'On_friend_lobby_list_updated'), self)
	ListenToGameEvent("dota_team_player_list_changed", Dynamic_Wrap(trollnelves2, 'On_dota_team_player_list_changed'), self)
	ListenToGameEvent("dota_player_details_changed", Dynamic_Wrap(trollnelves2, 'On_dota_player_details_changed'), self)
	ListenToGameEvent("player_profile_stats_updated", Dynamic_Wrap(trollnelves2, 'On_player_profile_stats_updated'), self)
	ListenToGameEvent("custom_game_player_count_updated", Dynamic_Wrap(trollnelves2, 'On_custom_game_player_count_updated'), self)
	ListenToGameEvent("custom_game_friends_played_updated", Dynamic_Wrap(trollnelves2, 'On_custom_game_friends_played_updated'), self)
	ListenToGameEvent("custom_games_friends_play_updated", Dynamic_Wrap(trollnelves2, 'On_custom_games_friends_play_updated'), self)
	ListenToGameEvent("dota_player_update_assigned_hero", Dynamic_Wrap(trollnelves2, 'On_dota_player_update_assigned_hero'), self)
	ListenToGameEvent("dota_player_hero_selection_dirty", Dynamic_Wrap(trollnelves2, 'On_dota_player_hero_selection_dirty'), self)
	--ListenToGameEvent("dota_npc_goal_reached", Dynamic_Wrap(trollnelves2, 'On_dota_npc_goal_reached'), self)
	ListenToGameEvent("dota_player_selected_custom_team", Dynamic_Wrap(trollnelves2, 'On_dota_player_selected_custom_team'), self)
end

function trollnelves2:On_team_info(data)
  print("[TROLLNELVES2] team_info")
  PrintTable(data)
end


function trollnelves2:On_team_score(data)
  print("[TROLLNELVES2] team_score")
  PrintTable(data)
end


function trollnelves2:On_teamplay_broadcast_audio(data)
  print("[TROLLNELVES2] teamplay_broadcast_audio")
  PrintTable(data)
end


function trollnelves2:On_player_team(data)
  print("[TROLLNELVES2] player_team")
  PrintTable(data)
end


function trollnelves2:On_player_class(data)
  print("[TROLLNELVES2] player_class")
  PrintTable(data)
end


function trollnelves2:On_player_death (data)
  print("[TROLLNELVES2] player_death")
  PrintTable(data)
end


function trollnelves2:On_player_hurt (data)
  print("[TROLLNELVES2] player_hurt")
  PrintTable(data)
end


function trollnelves2:On_player_chat (data)
  print("[TROLLNELVES2] player_chat")
  PrintTable(data)
end


function trollnelves2:On_player_score(data)
  print("[TROLLNELVES2] player_score")
  PrintTable(data)
end


function trollnelves2:On_player_spawn(data)
  print("[TROLLNELVES2] player_spawn")
  PrintTable(data)
end


function trollnelves2:On_player_shoot(data)
  print("[TROLLNELVES2] player_shoot")
  PrintTable(data)
end


function trollnelves2:On_player_use(data)
  print("[TROLLNELVES2] player_use")
  PrintTable(data)
end


function trollnelves2:On_player_changename(data)
  print("[TROLLNELVES2] player_changename")
  PrintTable(data)
end


function trollnelves2:On_player_hintmessage(data)
  print("[TROLLNELVES2] player_hintmessage")
  PrintTable(data)
end


function trollnelves2:On_player_reconnected (data)
  print("[TROLLNELVES2] player_reconnected")
  PrintTable(data)
end


function trollnelves2:On_game_init(data)
  print("[TROLLNELVES2] game_init")
  PrintTable(data)
end


function trollnelves2:On_game_newmap(data)
  print("[TROLLNELVES2] game_newmap")
  PrintTable(data)
end


function trollnelves2:On_game_start(data)
  print("[TROLLNELVES2] game_start")
  PrintTable(data)
end


function trollnelves2:On_game_end(data)
  print("[TROLLNELVES2] game_end")
  PrintTable(data)
end


function trollnelves2:On_round_start(data)
  print("[TROLLNELVES2] round_start")
  PrintTable(data)
end


function trollnelves2:On_round_end(data)
  print("[TROLLNELVES2] round_end")
  PrintTable(data)
end


function trollnelves2:On_round_start_pre_entity(data)
  print("[TROLLNELVES2] round_start_pre_entity")
  PrintTable(data)
end


function trollnelves2:On_teamplay_round_start(data)
  print("[TROLLNELVES2] teamplay_round_start")
  PrintTable(data)
end


function trollnelves2:On_hostname_changed(data)
  print("[TROLLNELVES2] hostname_changed")
  PrintTable(data)
end


function trollnelves2:On_difficulty_changed(data)
  print("[TROLLNELVES2] difficulty_changed")
  PrintTable(data)
end


function trollnelves2:On_finale_start(data)
  print("[TROLLNELVES2] finale_start")
  PrintTable(data)
end


function trollnelves2:On_game_message(data)
  print("[TROLLNELVES2] game_message")
  PrintTable(data)
end


function trollnelves2:On_break_breakable(data)
  print("[TROLLNELVES2] break_breakable")
  PrintTable(data)
end


function trollnelves2:On_break_prop(data)
  print("[TROLLNELVES2] break_prop")
  PrintTable(data)
end


function trollnelves2:On_npc_spawned(data)
  print("[TROLLNELVES2] npc_spawned")
  PrintTable(data)
end


function trollnelves2:On_npc_replaced(data)
  print("[TROLLNELVES2] npc_replaced")
  PrintTable(data)
end


function trollnelves2:On_entity_killed(data)
  print("[TROLLNELVES2] entity_killed")
  PrintTable(data)
end


function trollnelves2:On_entity_hurt(data)
  print("[TROLLNELVES2] entity_hurt")
  PrintTable(data)
end


function trollnelves2:On_bonus_updated(data)
  print("[TROLLNELVES2] bonus_updated")
  PrintTable(data)
end


function trollnelves2:On_player_stats_updated(data)
  print("[TROLLNELVES2] player_stats_updated")
  PrintTable(data)
end


function trollnelves2:On_achievement_event(data)
  print("[TROLLNELVES2] achievement_event")
  PrintTable(data)
end


function trollnelves2:On_achievement_earned(data)
  print("[TROLLNELVES2] achievement_earned")
  PrintTable(data)
end


function trollnelves2:On_achievement_write_failed(data)
  print("[TROLLNELVES2] achievement_write_failed")
  PrintTable(data)
end


function trollnelves2:On_physgun_pickup(data)
  print("[TROLLNELVES2] physgun_pickup")
  PrintTable(data)
end


function trollnelves2:On_flare_ignite_npc(data)
  print("[TROLLNELVES2] flare_ignite_npc")
  PrintTable(data)
end


function trollnelves2:On_helicopter_grenade_punt_miss(data)
  print("[TROLLNELVES2] helicopter_grenade_punt_miss")
  PrintTable(data)
end


function trollnelves2:On_user_data_downloaded(data)
  print("[TROLLNELVES2] user_data_downloaded")
  PrintTable(data)
end


function trollnelves2:On_ragdoll_dissolved(data)
  print("[TROLLNELVES2] ragdoll_dissolved")
  PrintTable(data)
end


function trollnelves2:On_gameinstructor_draw(data)
  print("[TROLLNELVES2] gameinstructor_draw")
  PrintTable(data)
end


function trollnelves2:On_gameinstructor_nodraw(data)
  print("[TROLLNELVES2] gameinstructor_nodraw")
  PrintTable(data)
end


function trollnelves2:On_map_transition(data)
  print("[TROLLNELVES2] map_transition")
  PrintTable(data)
end


function trollnelves2:On_instructor_server_hint_create(data)
  print("[TROLLNELVES2] instructor_server_hint_create")
  PrintTable(data)
end


function trollnelves2:On_instructor_server_hint_stop(data)
  print("[TROLLNELVES2] instructor_server_hint_stop")
  PrintTable(data)
end


function trollnelves2:On_chat_new_message(data)
  print("[TROLLNELVES2] chat_new_message")
  PrintTable(data)
end


function trollnelves2:On_chat_members_changed(data)
  print("[TROLLNELVES2] chat_members_changed")
  PrintTable(data)
end


function trollnelves2:On_game_rules_state_change(data)
  print("[TROLLNELVES2] game_rules_state_change")
  PrintTable(data)
end


function trollnelves2:On_inventory_updated(data)
  print("[TROLLNELVES2] inventory_updated")
  PrintTable(data)
end


function trollnelves2:On_cart_updated(data)
  print("[TROLLNELVES2] cart_updated")
  PrintTable(data)
end


function trollnelves2:On_store_pricesheet_updated(data)
  print("[TROLLNELVES2] store_pricesheet_updated")
  PrintTable(data)
end


function trollnelves2:On_gc_connected(data)
  print("[TROLLNELVES2] gc_connected")
  PrintTable(data)
end


function trollnelves2:On_item_schema_initialized(data)
  print("[TROLLNELVES2] item_schema_initialized")
  PrintTable(data)
end


function trollnelves2:On_drop_rate_modified(data)
  print("[TROLLNELVES2] drop_rate_modified")
  PrintTable(data)
end


function trollnelves2:On_event_ticket_modified(data)
  print("[TROLLNELVES2] event_ticket_modified")
  PrintTable(data)
end


function trollnelves2:On_modifier_event(data)
  print("[TROLLNELVES2] modifier_event")
  PrintTable(data)
end


function trollnelves2:On_dota_player_kill(data)
  print("[TROLLNELVES2] dota_player_kill")
  PrintTable(data)
end


function trollnelves2:On_dota_player_deny(data)
  print("[TROLLNELVES2] dota_player_deny")
  PrintTable(data)
end


function trollnelves2:On_dota_barracks_kill(data)
  print("[TROLLNELVES2] dota_barracks_kill")
  PrintTable(data)
end


function trollnelves2:On_dota_tower_kill(data)
  print("[TROLLNELVES2] dota_tower_kill")
  PrintTable(data)
end


function trollnelves2:On_dota_roshan_kill(data)
  print("[TROLLNELVES2] dota_roshan_kill")
  PrintTable(data)
end


function trollnelves2:On_dota_courier_lost(data)
  print("[TROLLNELVES2] dota_courier_lost")
  PrintTable(data)
end


function trollnelves2:On_dota_courier_respawned(data)
  print("[TROLLNELVES2] dota_courier_respawned")
  PrintTable(data)
end


function trollnelves2:On_dota_glyph_used(data)
  print("[TROLLNELVES2] dota_glyph_used")
  PrintTable(data)
end


function trollnelves2:On_dota_super_creeps(data)
  print("[TROLLNELVES2] dota_super_creeps")
  PrintTable(data)
end


function trollnelves2:On_dota_item_purchase(data)
  print("[TROLLNELVES2] dota_item_purchase")
  PrintTable(data)
end


function trollnelves2:On_dota_item_gifted(data)
  print("[TROLLNELVES2] dota_item_gifted")
  PrintTable(data)
end


function trollnelves2:On_dota_rune_pickup(data)
  print("[TROLLNELVES2] dota_rune_pickup")
  PrintTable(data)
end


function trollnelves2:On_dota_rune_spotted(data)
  print("[TROLLNELVES2] dota_rune_spotted")
  PrintTable(data)
end


function trollnelves2:On_dota_item_spotted(data)
  print("[TROLLNELVES2] dota_item_spotted")
  PrintTable(data)
end


function trollnelves2:On_dota_no_battle_points(data)
  print("[TROLLNELVES2] dota_no_battle_points")
  PrintTable(data)
end


function trollnelves2:On_dota_chat_informational(data)
  print("[TROLLNELVES2] dota_chat_informational")
  PrintTable(data)
end


function trollnelves2:On_dota_action_item(data)
  print("[TROLLNELVES2] dota_action_item")
  PrintTable(data)
end


function trollnelves2:On_dota_chat_ban_notification(data)
  print("[TROLLNELVES2] dota_chat_ban_notification")
  PrintTable(data)
end


function trollnelves2:On_dota_chat_event(data)
  print("[TROLLNELVES2] dota_chat_event")
  PrintTable(data)
end


function trollnelves2:On_dota_chat_timed_reward(data)
  print("[TROLLNELVES2] dota_chat_timed_reward")
  PrintTable(data)
end


function trollnelves2:On_dota_pause_event(data)
  print("[TROLLNELVES2] dota_pause_event")
  PrintTable(data)
end


function trollnelves2:On_dota_chat_kill_streak(data)
  print("[TROLLNELVES2] dota_chat_kill_streak")
  PrintTable(data)
end


function trollnelves2:On_dota_chat_first_blood(data)
  print("[TROLLNELVES2] dota_chat_first_blood")
  PrintTable(data)
end


function trollnelves2:On_dota_player_update_hero_selection(data)
  print("[TROLLNELVES2] dota_player_update_hero_selection")
  PrintTable(data)
end


function trollnelves2:On_dota_player_update_selected_unit(data)
  print("[TROLLNELVES2] dota_player_update_selected_unit")
  PrintTable(data)
end


function trollnelves2:On_dota_player_update_query_unit(data)
  print("[TROLLNELVES2] dota_player_update_query_unit")
  PrintTable(data)
end


function trollnelves2:On_dota_player_update_killcam_unit(data)
  print("[TROLLNELVES2] dota_player_update_killcam_unit")
  PrintTable(data)
end


function trollnelves2:On_dota_player_take_tower_damage(data)
  print("[TROLLNELVES2] dota_player_take_tower_damage")
  PrintTable(data)
end


function trollnelves2:On_dota_hud_error_message(data)
  print("[TROLLNELVES2] dota_hud_error_message")
  PrintTable(data)
end


function trollnelves2:On_dota_action_success(data)
  print("[TROLLNELVES2] dota_action_success")
  PrintTable(data)
end


function trollnelves2:On_dota_starting_position_changed(data)
  print("[TROLLNELVES2] dota_starting_position_changed")
  PrintTable(data)
end


function trollnelves2:On_dota_money_changed(data)
  print("[TROLLNELVES2] dota_money_changed")
  PrintTable(data)
end


function trollnelves2:On_dota_enemy_money_changed(data)
  print("[TROLLNELVES2] dota_enemy_money_changed")
  PrintTable(data)
end


function trollnelves2:On_dota_portrait_unit_stats_changed(data)
  print("[TROLLNELVES2] dota_portrait_unit_stats_changed")
  PrintTable(data)
end


function trollnelves2:On_dota_portrait_unit_modifiers_changed(data)
  print("[TROLLNELVES2] dota_portrait_unit_modifiers_changed")
  PrintTable(data)
end


function trollnelves2:On_dota_force_portrait_update(data)
  print("[TROLLNELVES2] dota_force_portrait_update")
  PrintTable(data)
end


function trollnelves2:On_dota_inventory_changed(data)
  print("[TROLLNELVES2] dota_inventory_changed")
  PrintTable(data)
end


function trollnelves2:On_dota_item_picked_up(data)
  print("[TROLLNELVES2] dota_item_picked_up")
  PrintTable(data)
end


function trollnelves2:On_dota_inventory_item_changed(data)
  print("[TROLLNELVES2] dota_inventory_item_changed")
  PrintTable(data)
end


function trollnelves2:On_dota_ability_changed(data)
  print("[TROLLNELVES2] dota_ability_changed")
  PrintTable(data)
end


function trollnelves2:On_dota_portrait_ability_layout_changed(data)
  print("[TROLLNELVES2] dota_portrait_ability_layout_changed")
  PrintTable(data)
end


function trollnelves2:On_dota_inventory_item_added(data)
  print("[TROLLNELVES2] dota_inventory_item_added")
  PrintTable(data)
end


function trollnelves2:On_dota_inventory_changed_query_unit(data)
  print("[TROLLNELVES2] dota_inventory_changed_query_unit")
  PrintTable(data)
end


function trollnelves2:On_dota_link_clicked(data)
  print("[TROLLNELVES2] dota_link_clicked")
  PrintTable(data)
end


function trollnelves2:On_dota_set_quick_buy(data)
  print("[TROLLNELVES2] dota_set_quick_buy")
  PrintTable(data)
end


function trollnelves2:On_dota_quick_buy_changed(data)
  print("[TROLLNELVES2] dota_quick_buy_changed")
  PrintTable(data)
end


function trollnelves2:On_dota_player_shop_changed(data)
  print("[TROLLNELVES2] dota_player_shop_changed")
  PrintTable(data)
end


function trollnelves2:On_dota_player_show_killcam(data)
  print("[TROLLNELVES2] dota_player_show_killcam")
  PrintTable(data)
end


function trollnelves2:On_dota_player_show_minikillcam(data)
  print("[TROLLNELVES2] dota_player_show_minikillcam")
  PrintTable(data)
end


function trollnelves2:On_gc_user_session_created(data)
  print("[TROLLNELVES2] gc_user_session_created")
  PrintTable(data)
end


function trollnelves2:On_team_data_updated(data)
  print("[TROLLNELVES2] team_data_updated")
  PrintTable(data)
end


function trollnelves2:On_guild_data_updated(data)
  print("[TROLLNELVES2] guild_data_updated")
  PrintTable(data)
end


function trollnelves2:On_guild_open_parties_updated(data)
  print("[TROLLNELVES2] guild_open_parties_updated")
  PrintTable(data)
end


function trollnelves2:On_fantasy_updated(data)
  print("[TROLLNELVES2] fantasy_updated")
  PrintTable(data)
end


function trollnelves2:On_fantasy_league_changed(data)
  print("[TROLLNELVES2] fantasy_league_changed")
  PrintTable(data)
end


function trollnelves2:On_fantasy_score_info_changed(data)
  print("[TROLLNELVES2] fantasy_score_info_changed")
  PrintTable(data)
end


function trollnelves2:On_player_info_updated(data)
  print("[TROLLNELVES2] player_info_updated")
  PrintTable(data)
end


function trollnelves2:On_game_rules_state_change(data)
  print("[TROLLNELVES2] game_rules_state_change")
  PrintTable(data)
end


function trollnelves2:On_match_history_updated(data)
  print("[TROLLNELVES2] match_history_updated")
  PrintTable(data)
end


function trollnelves2:On_match_details_updated(data)
  print("[TROLLNELVES2] match_details_updated")
  PrintTable(data)
end


function trollnelves2:On_live_games_updated(data)
  print("[TROLLNELVES2] live_games_updated")
  PrintTable(data)
end


function trollnelves2:On_recent_matches_updated(data)
  print("[TROLLNELVES2] recent_matches_updated")
  PrintTable(data)
end


function trollnelves2:On_news_updated(data)
  print("[TROLLNELVES2] news_updated")
  PrintTable(data)
end


function trollnelves2:On_persona_updated(data)
  print("[TROLLNELVES2] persona_updated")
  PrintTable(data)
end


function trollnelves2:On_tournament_state_updated(data)
  print("[TROLLNELVES2] tournament_state_updated")
  PrintTable(data)
end


function trollnelves2:On_party_updated(data)
  print("[TROLLNELVES2] party_updated")
  PrintTable(data)
end


function trollnelves2:On_lobby_updated(data)
  print("[TROLLNELVES2] lobby_updated")
  PrintTable(data)
end


function trollnelves2:On_dashboard_caches_cleared(data)
  print("[TROLLNELVES2] dashboard_caches_cleared")
  PrintTable(data)
end


function trollnelves2:On_last_hit(data)
  print("[TROLLNELVES2] last_hit")
  PrintTable(data)
end


function trollnelves2:On_player_completed_game(data)
  print("[TROLLNELVES2] player_completed_game")
  PrintTable(data)
end

function trollnelves2:On_dota_combatlog(data)
  print("[TROLLNELVES2] dota_combatlog")
  PrintTable(data)
end


function trollnelves2:On_player_reconnected(data)
  print("[TROLLNELVES2] player_reconnected")
  PrintTable(data)
end


function trollnelves2:On_nommed_tree(data)
  print("[TROLLNELVES2] nommed_tree")
  PrintTable(data)
end


function trollnelves2:On_dota_rune_activated_server(data)
  print("[TROLLNELVES2] dota_rune_activated_server")
  PrintTable(data)
end


function trollnelves2:On_dota_player_gained_level(data)
  print("[TROLLNELVES2] dota_player_gained_level")
  PrintTable(data)
end

function trollnelves2:On_dota_player_pick_hero(data)
  print("[TROLLNELVES2] dota_player_pick_hero")
  PrintTable(data)
end

function trollnelves2:On_dota_player_learned_ability(data)
  print("[TROLLNELVES2] dota_player_learned_ability")
  PrintTable(data)
end


function trollnelves2:On_dota_player_used_ability(data)
  print("[TROLLNELVES2] dota_player_used_ability")
  PrintTable(data)
end


function trollnelves2:On_dota_non_player_used_ability(data)
  print("[TROLLNELVES2] dota_non_player_used_ability")
  PrintTable(data)
end


function trollnelves2:On_dota_ability_channel_finished(data)
  print("[TROLLNELVES2] dota_ability_channel_finished")
  PrintTable(data)
end


function trollnelves2:On_dota_holdout_revive_complete(data)
  print("[TROLLNELVES2] dota_holdout_revive_complete")
  PrintTable(data)
end


function trollnelves2:On_dota_player_killed(data)
  print("[TROLLNELVES2] dota_player_killed")
  PrintTable(data)
end


function trollnelves2:On_bindpanel_open(data)
  print("[TROLLNELVES2] bindpanel_open")
  PrintTable(data)
end


function trollnelves2:On_bindpanel_close(data)
  print("[TROLLNELVES2] bindpanel_close")
  PrintTable(data)
end


function trollnelves2:On_keybind_changed(data)
  print("[TROLLNELVES2] keybind_changed")
  PrintTable(data)
end


function trollnelves2:On_dota_item_drag_begin(data)
  print("[TROLLNELVES2] dota_item_drag_begin")
  PrintTable(data)
end


function trollnelves2:On_dota_item_drag_end(data)
  print("[TROLLNELVES2] dota_item_drag_end")
  PrintTable(data)
end


function trollnelves2:On_dota_shop_item_drag_begin(data)
  print("[TROLLNELVES2] dota_shop_item_drag_begin")
  PrintTable(data)
end


function trollnelves2:On_dota_shop_item_drag_end(data)
  print("[TROLLNELVES2] dota_shop_item_drag_end")
  PrintTable(data)
end


function trollnelves2:On_dota_item_purchased(data)
  print("[TROLLNELVES2] dota_item_purchased")
  PrintTable(data)
end


function trollnelves2:On_dota_item_used(data)
  print("[TROLLNELVES2] dota_item_used")
  PrintTable(data)
end


function trollnelves2:On_dota_item_auto_purchase(data)
  print("[TROLLNELVES2] dota_item_auto_purchase")
  PrintTable(data)
end


function trollnelves2:On_dota_unit_event(data)
  print("[TROLLNELVES2] dota_unit_event")
  PrintTable(data)
end


function trollnelves2:On_dota_quest_started(data)
  print("[TROLLNELVES2] dota_quest_started")
  PrintTable(data)
end


function trollnelves2:On_dota_quest_completed(data)
  print("[TROLLNELVES2] dota_quest_completed")
  PrintTable(data)
end


function trollnelves2:On_gameui_activated(data)
  print("[TROLLNELVES2] gameui_activated")
  PrintTable(data)
end


function trollnelves2:On_gameui_hidden(data)
  print("[TROLLNELVES2] gameui_hidden")
  PrintTable(data)
end


function trollnelves2:On_player_fullyjoined(data)
  print("[TROLLNELVES2] player_fullyjoined")
  PrintTable(data)
end


function trollnelves2:On_dota_spectate_hero(data)
  print("[TROLLNELVES2] dota_spectate_hero")
  PrintTable(data)
end


function trollnelves2:On_dota_match_done(data)
  print("[TROLLNELVES2] dota_match_done")
  PrintTable(data)
end


function trollnelves2:On_dota_match_done_client(data)
  print("[TROLLNELVES2] dota_match_done_client")
  PrintTable(data)
end


function trollnelves2:On_set_instructor_group_enabled(data)
  print("[TROLLNELVES2] set_instructor_group_enabled")
  PrintTable(data)
end


function trollnelves2:On_joined_chat_channel(data)
  print("[TROLLNELVES2] joined_chat_channel")
  PrintTable(data)
end


function trollnelves2:On_left_chat_channel(data)
  print("[TROLLNELVES2] left_chat_channel")
  PrintTable(data)
end


function trollnelves2:On_gc_chat_channel_list_updated(data)
  print("[TROLLNELVES2] gc_chat_channel_list_updated")
  PrintTable(data)
end


function trollnelves2:On_today_messages_updated(data)
  print("[TROLLNELVES2] today_messages_updated")
  PrintTable(data)
end


function trollnelves2:On_file_downloaded(data)
  print("[TROLLNELVES2] file_downloaded")
  PrintTable(data)
end


function trollnelves2:On_player_report_counts_updated(data)
  print("[TROLLNELVES2] player_report_counts_updated")
  PrintTable(data)
end


function trollnelves2:On_scaleform_file_download_complete(data)
  print("[TROLLNELVES2] scaleform_file_download_complete")
  PrintTable(data)
end


function trollnelves2:On_item_purchased(data)
  print("[TROLLNELVES2] item_purchased")
  PrintTable(data)
end


function trollnelves2:On_gc_mismatched_version(data)
  print("[TROLLNELVES2] gc_mismatched_version")
  PrintTable(data)
end


function trollnelves2:On_demo_skip(data)
  print("[TROLLNELVES2] demo_skip")
  PrintTable(data)
end


function trollnelves2:On_demo_start(data)
  print("[TROLLNELVES2] demo_start")
  PrintTable(data)
end


function trollnelves2:On_demo_stop(data)
  print("[TROLLNELVES2] demo_stop")
  PrintTable(data)
end


function trollnelves2:On_map_shutdown(data)
  print("[TROLLNELVES2] map_shutdown")
  PrintTable(data)
end


function trollnelves2:On_dota_workshop_fileselected(data)
  print("[TROLLNELVES2] dota_workshop_fileselected")
  PrintTable(data)
end


function trollnelves2:On_dota_workshop_filecanceled(data)
  print("[TROLLNELVES2] dota_workshop_filecanceled")
  PrintTable(data)
end


function trollnelves2:On_rich_presence_updated(data)
  print("[TROLLNELVES2] rich_presence_updated")
  PrintTable(data)
end


function trollnelves2:On_dota_hero_random(data)
  print("[TROLLNELVES2] dota_hero_random")
  PrintTable(data)
end


function trollnelves2:On_dota_rd_chat_turn(data)
  print("[TROLLNELVES2] dota_rd_chat_turn")
  PrintTable(data)
end


function trollnelves2:On_dota_favorite_heroes_updated(data)
  print("[TROLLNELVES2] dota_favorite_heroes_updated")
  PrintTable(data)
end


function trollnelves2:On_profile_closed(data)
  print("[TROLLNELVES2] profile_closed")
  PrintTable(data)
end


function trollnelves2:On_item_preview_closed(data)
  print("[TROLLNELVES2] item_preview_closed")
  PrintTable(data)
end


function trollnelves2:On_dashboard_switched_section(data)
  print("[TROLLNELVES2] dashboard_switched_section")
  PrintTable(data)
end


function trollnelves2:On_dota_tournament_item_event(data)
  print("[TROLLNELVES2] dota_tournament_item_event")
  PrintTable(data)
end


function trollnelves2:On_dota_hero_swap(data)
  print("[TROLLNELVES2] dota_hero_swap")
  PrintTable(data)
end


function trollnelves2:On_dota_reset_suggested_items(data)
  print("[TROLLNELVES2] dota_reset_suggested_items")
  PrintTable(data)
end


function trollnelves2:On_halloween_high_score_received(data)
  print("[TROLLNELVES2] halloween_high_score_received")
  PrintTable(data)
end


function trollnelves2:On_halloween_phase_end(data)
  print("[TROLLNELVES2] halloween_phase_end")
  PrintTable(data)
end


function trollnelves2:On_halloween_high_score_request_failed(data)
  print("[TROLLNELVES2] halloween_high_score_request_failed")
  PrintTable(data)
end


function trollnelves2:On_dota_hud_skin_changed(data)
  print("[TROLLNELVES2] dota_hud_skin_changed")
  PrintTable(data)
end


function trollnelves2:On_dota_inventory_player_got_item(data)
  print("[TROLLNELVES2] dota_inventory_player_got_item")
  PrintTable(data)
end


function trollnelves2:On_player_is_experienced(data)
  print("[TROLLNELVES2] player_is_experienced")
  PrintTable(data)
end


function trollnelves2:On_player_is_notexperienced(data)
  print("[TROLLNELVES2] player_is_notexperienced")
  PrintTable(data)
end


function trollnelves2:On_dota_tutorial_lesson_start(data)
  print("[TROLLNELVES2] dota_tutorial_lesson_start")
  PrintTable(data)
end


function trollnelves2:On_map_location_updated(data)
  print("[TROLLNELVES2] map_location_updated")
  PrintTable(data)
end


function trollnelves2:On_richpresence_custom_updated(data)
  print("[TROLLNELVES2] richpresence_custom_updated")
  PrintTable(data)
end


function trollnelves2:On_game_end_visible(data)
  print("[TROLLNELVES2] game_end_visible")
  PrintTable(data)
end


function trollnelves2:On_antiaddiction_update(data)
  print("[TROLLNELVES2] antiaddiction_update")
  PrintTable(data)
end


function trollnelves2:On_highlight_hud_element(data)
  print("[TROLLNELVES2] highlight_hud_element")
  PrintTable(data)
end


function trollnelves2:On_hide_highlight_hud_element(data)
  print("[TROLLNELVES2] hide_highlight_hud_element")
  PrintTable(data)
end


function trollnelves2:On_intro_video_finished(data)
  print("[TROLLNELVES2] intro_video_finished")
  PrintTable(data)
end


function trollnelves2:On_matchmaking_status_visibility_changed(data)
  print("[TROLLNELVES2] matchmaking_status_visibility_changed")
  PrintTable(data)
end


function trollnelves2:On_practice_lobby_visibility_changed(data)
  print("[TROLLNELVES2] practice_lobby_visibility_changed")
  PrintTable(data)
end


function trollnelves2:On_dota_courier_transfer_item(data)
  print("[TROLLNELVES2] dota_courier_transfer_item")
  PrintTable(data)
end


function trollnelves2:On_full_ui_unlocked(data)
  print("[TROLLNELVES2] full_ui_unlocked")
  PrintTable(data)
end


function trollnelves2:On_client_connectionless_packet(data)
  print("[TROLLNELVES2] client_connectionless_packet")
  PrintTable(data)
end


function trollnelves2:On_hero_selector_preview_set(data)
  print("[TROLLNELVES2] hero_selector_preview_set")
  PrintTable(data)
end


function trollnelves2:On_antiaddiction_toast(data)
  print("[TROLLNELVES2] antiaddiction_toast")
  PrintTable(data)
end


function trollnelves2:On_hero_picker_shown(data)
  print("[TROLLNELVES2] hero_picker_shown")
  PrintTable(data)
end


function trollnelves2:On_hero_picker_hidden(data)
  print("[TROLLNELVES2] hero_picker_hidden")
  PrintTable(data)
end


function trollnelves2:On_dota_local_quickbuy_changed(data)
  print("[TROLLNELVES2] dota_local_quickbuy_changed")
  PrintTable(data)
end


function trollnelves2:On_show_center_message(data)
  print("[TROLLNELVES2] show_center_message")
  PrintTable(data)
end


function trollnelves2:On_hud_flip_changed(data)
  print("[TROLLNELVES2] hud_flip_changed")
  PrintTable(data)
end


function trollnelves2:On_frosty_points_updated(data)
  print("[TROLLNELVES2] frosty_points_updated")
  PrintTable(data)
end


function trollnelves2:On_defeated(data)
  print("[TROLLNELVES2] defeated")
  PrintTable(data)
end


function trollnelves2:On_reset_defeated(data)
  print("[TROLLNELVES2] reset_defeated")
  PrintTable(data)
end


function trollnelves2:On_booster_state_updated(data)
  print("[TROLLNELVES2] booster_state_updated")
  PrintTable(data)
end


function trollnelves2:On_event_points_updated(data)
  print("[TROLLNELVES2] event_points_updated")
  PrintTable(data)
end


function trollnelves2:On_local_player_event_points(data)
  print("[TROLLNELVES2] local_player_event_points")
  PrintTable(data)
end


function trollnelves2:On_custom_game_difficulty(data)
  print("[TROLLNELVES2] custom_game_difficulty")
  PrintTable(data)
end


function trollnelves2:On_tree_cut(data)
  print("[TROLLNELVES2] tree_cut")
  PrintTable(data)
end


function trollnelves2:On_ugc_details_arrived(data)
  print("[TROLLNELVES2] ugc_details_arrived")
  PrintTable(data)
end


function trollnelves2:On_ugc_subscribed(data)
  print("[TROLLNELVES2] ugc_subscribed")
  PrintTable(data)
end


function trollnelves2:On_ugc_unsubscribed(data)
  print("[TROLLNELVES2] ugc_unsubscribed")
  PrintTable(data)
end


function trollnelves2:On_prizepool_received(data)
  print("[TROLLNELVES2] prizepool_received")
  PrintTable(data)
end


function trollnelves2:On_microtransaction_success(data)
  print("[TROLLNELVES2] microtransaction_success")
  PrintTable(data)
end


function trollnelves2:On_dota_rubick_ability_steal(data)
  print("[TROLLNELVES2] dota_rubick_ability_steal")
  PrintTable(data)
end


function trollnelves2:On_compendium_event_actions_loaded(data)
  print("[TROLLNELVES2] compendium_event_actions_loaded")
  PrintTable(data)
end


function trollnelves2:On_compendium_selections_loaded(data)
  print("[TROLLNELVES2] compendium_selections_loaded")
  PrintTable(data)
end


function trollnelves2:On_compendium_set_selection_failed(data)
  print("[TROLLNELVES2] compendium_set_selection_failed")
  PrintTable(data)
end

function trollnelves2:On_community_cached_names_updated(data)
  print("[TROLLNELVES2] community_cached_names_updated")
  PrintTable(data)
end

function trollnelves2:On_dota_team_kill_credit(data)
  print("[TROLLNELVES2] dota_team_kill_credit")
  PrintTable(data)
end

function trollnelves2:On_dota_effigy_kill(data)
  print("[TROLLNELVES2] dota_effigy_kill")
  PrintTable(data)
end

function trollnelves2:On_dota_chat_assassin_announce(data)
  print("[TROLLNELVES2] dota_chat_assassin_announce")
  PrintTable(data)
end


function trollnelves2:On_dota_chat_assassin_denied(data)
  print("[TROLLNELVES2] dota_chat_assassin_denied")
  PrintTable(data)
end


function trollnelves2:On_dota_chat_assassin_success(data)
  print("[TROLLNELVES2] dota_chat_assassin_success")
  PrintTable(data)
end


function trollnelves2:On_player_info_individual_updated(data)
  print("[TROLLNELVES2] player_info_individual_updated")
  PrintTable(data)
end


function trollnelves2:On_dota_player_begin_cast(data)
  print("[TROLLNELVES2] dota_player_begin_cast")
  PrintTable(data)
end


function trollnelves2:On_dota_non_player_begin_cast(data)
  print("[TROLLNELVES2] dota_non_player_begin_cast")
  PrintTable(data)
end


function trollnelves2:On_dota_item_combined(data)
  print("[TROLLNELVES2] dota_item_combined")
  PrintTable(data)
end


function trollnelves2:On_profile_opened(data)
  print("[TROLLNELVES2] profile_opened")
  PrintTable(data)
end


function trollnelves2:On_dota_tutorial_task_advance(data)
  print("[TROLLNELVES2] dota_tutorial_task_advance")
  PrintTable(data)
end


function trollnelves2:On_dota_tutorial_shop_toggled(data)
  print("[TROLLNELVES2] dota_tutorial_shop_toggled")
  PrintTable(data)
end


function trollnelves2:On_ugc_download_requested(data)
  print("[TROLLNELVES2] ugc_download_requested")
  PrintTable(data)
end


function trollnelves2:On_ugc_installed(data)
  print("[TROLLNELVES2] ugc_installed")
  PrintTable(data)
end


function trollnelves2:On_compendium_trophies_loaded(data)
  print("[TROLLNELVES2] compendium_trophies_loaded")
  PrintTable(data)
end


function trollnelves2:On_spec_item_pickup(data)
  print("[TROLLNELVES2] spec_item_pickup")
  PrintTable(data)
end


function trollnelves2:On_spec_aegis_reclaim_time(data)
  print("[TROLLNELVES2] spec_aegis_reclaim_time")
  PrintTable(data)
end


function trollnelves2:On_account_trophies_changed(data)
  print("[TROLLNELVES2] account_trophies_changed")
  PrintTable(data)
end


function trollnelves2:On_account_all_hero_challenge_changed(data)
  print("[TROLLNELVES2] account_all_hero_challenge_changed")
  PrintTable(data)
end


function trollnelves2:On_team_showcase_ui_update(data)
  print("[TROLLNELVES2] team_showcase_ui_update")
  PrintTable(data)
end


function trollnelves2:On_ingame_events_changed(data)
  print("[TROLLNELVES2] ingame_events_changed")
  PrintTable(data)
end


function trollnelves2:On_dota_match_signout(data)
  print("[TROLLNELVES2] dota_match_signout")
  PrintTable(data)
end


function trollnelves2:On_dota_illusions_created(data)
  print("[TROLLNELVES2] dota_illusions_created")
  PrintTable(data)
end


function trollnelves2:On_dota_year_beast_killed(data)
  print("[TROLLNELVES2] dota_year_beast_killed")
  PrintTable(data)
end


function trollnelves2:On_dota_hero_undoselection(data)
  print("[TROLLNELVES2] dota_hero_undoselection")
  PrintTable(data)
end


function trollnelves2:On_dota_challenge_socache_updated(data)
  print("[TROLLNELVES2] dota_challenge_socache_updated")
  PrintTable(data)
end


function trollnelves2:On_party_invites_updated(data)
  print("[TROLLNELVES2] party_invites_updated")
  PrintTable(data)
end


function trollnelves2:On_lobby_invites_updated(data)
  print("[TROLLNELVES2] lobby_invites_updated")
  PrintTable(data)
end


function trollnelves2:On_custom_game_mode_list_updated(data)
  print("[TROLLNELVES2] custom_game_mode_list_updated")
  PrintTable(data)
end


function trollnelves2:On_custom_game_lobby_list_updated(data)
  print("[TROLLNELVES2] custom_game_lobby_list_updated")
  PrintTable(data)
end


function trollnelves2:On_friend_lobby_list_updated(data)
  print("[TROLLNELVES2] friend_lobby_list_updated")
  PrintTable(data)
end


function trollnelves2:On_dota_team_player_list_changed(data)
  print("[TROLLNELVES2] dota_team_player_list_changed")
  PrintTable(data)
end


function trollnelves2:On_dota_player_details_changed(data)
  print("[TROLLNELVES2] dota_player_details_changed")
  PrintTable(data)
end


function trollnelves2:On_player_profile_stats_updated(data)
  print("[TROLLNELVES2] player_profile_stats_updated")
  PrintTable(data)
end


function trollnelves2:On_custom_game_player_count_updated(data)
  print("[TROLLNELVES2] custom_game_player_count_updated")
  PrintTable(data)
end


function trollnelves2:On_custom_game_friends_played_updated(data)
  print("[TROLLNELVES2] custom_game_friends_played_updated")
  PrintTable(data)
end


function trollnelves2:On_custom_games_friends_play_updated(data)
  print("[TROLLNELVES2] custom_games_friends_play_updated")
  PrintTable(data)
end


function trollnelves2:On_dota_player_update_assigned_hero(data)
  print("[TROLLNELVES2] dota_player_update_assigned_hero")
  PrintTable(data)
end


function trollnelves2:On_dota_player_hero_selection_dirty(data)
  print("[TROLLNELVES2] dota_player_hero_selection_dirty")
  PrintTable(data)
end


function trollnelves2:On_dota_npc_goal_reached(data)
  print("[TROLLNELVES2] dota_npc_goal_reached")
  PrintTable(data)
end


function trollnelves2:On_dota_player_selected_custom_team(data)
  print("[TROLLNELVES2] dota_player_selected_custom_team")
  PrintTable(data)
end
