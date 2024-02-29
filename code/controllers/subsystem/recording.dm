/datum/controller/subsystem/recording
	name = "Recording"
	flags = SS_BACKGROUND
	init_order = INIT_ORDER_RECORDING
	var/list/recorded_rounds = list()

	/datum/controller/subsystem/recording/Initialize(timeofday)
		. = ..()
		// Initialization code here, if necessary

	/datum/controller/subsystem/recording/fire()
		record_game_state()

	/datum/controller/subsystem/recording/proc/record_game_state()
		var/list/game_state = list()
		for(var/mob/player_mob in GLOB.player_list)
			if(player_mob.client) // Ensure the mob is player-controlled
				game_state.Add(serialize_mob(player_mob))
		recorded_rounds.Add(world.time, game_state)
		var/json_data = json_encode(game_state)
		write_data_to_file(json_data)

	/datum/controller/subsystem/recording/proc/serialize_mob(mob/M)
		var/list/mob_data = list(
			"x" = M.x,
			"y" = M.y,
			"z" = M.z,
			"name" = M.name,
			"icon" = M.icon,
			"icon_state" = M.icon_state,
			// Add more fields as necessary
		)
		return mob_data

	/datum/controller/subsystem/recording/proc/write_data_to_file(json_data)
		var/file_path = "data/recorded_rounds/[world.time].json"
		fdel(file_path) // Ensure we're not appending to an old file
		text2file(json_data, file_path)

	/proc/file_directory_listing(directory)
		var/list/file_list = list()
		var/dir = directory
		if(!fexists(dir))
			return file_list
		for(var/f in flist(dir))
			file_list += f
		return file_list

	/proc/read_data_from_file(file_path)
		if(!fexists(file_path))
			return null
		var/json_data = file2text(file_path)
		return json_decode(json_data)


GLOBAL_VAR_INIT(subsystem_recording, /datum/controller/subsystem/recording)
