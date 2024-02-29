/datum/controller/subsystem/playback
	name = "Playback"
	flags = SS_BACKGROUND
	init_order = INIT_ORDER_PLAYBACK

	var/list/current_game_states
	var/client/current_client
	var/current_index = 1

	/datum/controller/subsystem/playback/proc/start_playback(list/game_states, client/player_client)
		current_game_states = game_states
		current_client = player_client
		current_index = 1
		playback_tick()

	/datum/controller/subsystem/playback/proc/playback_tick()
		if(!current_game_states || !current_client)
			return

		var/list/mob_state = current_game_states[current_index]
		var/mob/observer/ghost/G = current_client.mob
		if(istype(G))
			G.forceMove(get_turf_from_state(mob_state))
			G.setDir(mob_state["dir"])
			// Additional state application as needed

		current_index++
		if(current_index > length(current_game_states))
			current_index = 1 // Loop back to the beginning

		// Schedule the next tick
		addtimer(CALLBACK(src, .proc/playback_tick), 1 SECONDS, TIMER_STOPPABLE)

GLOBAL_VAR_INIT(SSplayback, /datum/controller/subsystem/playback)
