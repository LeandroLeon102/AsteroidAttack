extends Node

var default_settings = ConfigFile


	
func load_settings():
	pass

func save_settings():
	pass
	
func check_settings_file():
	var directory = Directory.new();
	var doFileExists = directory.file_exists(str(OS.get_user_data_dir())+'/config/settings.cfg')

	if not doFileExists:
		create_settings_file()

func create_settings_file():
	create_conf_dir()
	var default_settings = ConfigFile.new()
	default_settings.set_value('Display', 'Resolution', Vector2(1280, 720))
	default_settings.save(str(OS.get_user_data_dir())+'/config/settings.cfg')
	
func create_conf_dir():
	var dir = Directory.new()
	dir.open(OS.get_user_data_dir())
	dir.make_dir('config')
