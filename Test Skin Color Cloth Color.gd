extends Spatial

onready var body = $body
var skin_type = "leo"
# skin textures
onready var m_panthera_habilis_tigris_alb =  preload("res://testing stuff/Pantera tigris albino.png")
onready var m_panthera_habilis_leo =  preload("res://testing stuff/Panthera leo.png")
onready var m_panthera_habilis_ruby =  preload("res://testing stuff/Panthera leo ruby.png")
onready var m_panthera_habilis_snow_leo =  preload("res://testing stuff/Panthera leopard snow.png")
var jacket_type = "white"
# cloth texture 
onready var set0_color_blue =  preload("res://testing stuff/Set0.png")
onready var set0_color_white =  preload("res://testing stuff/Set1.png")

func _ready():
	loadPlayerData()
	switch()
	switchJakect()
	
func switchJakect():
	var newMaterial = SpatialMaterial.new()
	match skin_type:
		"blue":
			newMaterial.albedo_texture = set0_color_blue
			newMaterial.flags_unshaded = true
			body.set_surface_material(1, newMaterial)
		"white":
			newMaterial.albedo_texture = set0_color_white
			newMaterial.flags_unshaded = true
			body.set_surface_material(1, newMaterial)

func switch():
	var newMaterial = SpatialMaterial.new()
	match skin_type:
		"leo":
			newMaterial.albedo_texture = m_panthera_habilis_leo
			newMaterial.flags_unshaded = true
			body.set_surface_material(0, newMaterial)
		"ruby":
			newMaterial.albedo_texture = m_panthera_habilis_ruby
			newMaterial.flags_unshaded = true
			body.set_surface_material(0, newMaterial)
		"snow":
			newMaterial.albedo_texture = m_panthera_habilis_snow_leo
			newMaterial.flags_unshaded = true
			body.set_surface_material(0, newMaterial)
		"albino tiger":
			newMaterial.albedo_texture = m_panthera_habilis_tigris_alb
			newMaterial.flags_unshaded = true
			body.set_surface_material(0, newMaterial)
		
	
func _on_Button_pressed():
	# Define the sequence of skin types
	var skin_types = ["leo", "ruby", "snow", "albino tiger"]
	
	# Find the index of the current skin type
	var current_index = skin_types.find(skin_type)
	
	# Calculate the index of the next skin type
	var next_index = (current_index + 1) % skin_types.size()
	
	# Update the skin type
	skin_type = skin_types[next_index]
	
	# Apply the new skin
	switch()
	
	# Save the player data
	savePlayerData()

func _on_Button2_pressed():
	# Define the sequence of skin types
	var jacket_types = ["blue", "white"]
	
	# Find the index of the current skin type
	var current_index = jacket_types.find(skin_type)
	
	# Calculate the index of the next skin type
	var next_index = (current_index + 1) % jacket_types.size()
	
	# Update the skin type
	skin_type = jacket_types[next_index]
	
	# Apply the new skin
	switchJakect()
	
	# Save the player data
	savePlayerData()

var entity_name: String = "testing textures"
const SAVE_DIR: String = "user://saves/"
var save_path: String = SAVE_DIR + entity_name + "save.dat"
func savePlayerData():
	var data = {
		"skin_type": skin_type,
		"jacket_type":jacket_type
		
		}
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	var file = File.new()
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, "P@paB3ar6969")
	if error == OK:
		file.store_var(data)
		file.close()
		
func loadPlayerData():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open_encrypted_with_pass(save_path, File.READ, "P@paB3ar6969")
		if error == OK:
			var player_data = file.get_var()
			file.close()
			if "skin_type" in player_data:
				skin_type = player_data["skin_type"]
			if "jacket_type" in player_data:
				jacket_type = player_data["jacket_type"]

