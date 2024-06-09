#_______________________________________Inventory system____________________________________________
#for this to work either preload all the item icons here or add the "Global.gd"
#as an autoload, i called it add_item in my project, and i used it to to compre the path 
#of icons, if the path matches with the icon i need, i do the effect of the specific item 
#i also use the same autoload to add items to inventory 
onready var inventory_grid = $UI/GUI/Inventory/ScrollContainer/InventoryGrid
onready var gui = $UI/GUI

func setInventoryOwner():
	for child in inventory_grid.get_children():
		if child.is_in_group("Inventory"):
			child.get_node("Icon").player = self 
func connectInventoryButtons():
	$UI/GUI/Inventory/SplitFirstSlot.connect("pressed", self, "splitFirstSlot") 
	var combine_slots_button = $UI/GUI/Inventory/CombineSlots
	combine_slots_button.connect("pressed", self, "combineSlots")
	for child in inventory_grid.get_children():
		if child.is_in_group("Inventory"):
			var index_str = child.get_name().split("InventorySlot")[1]
			var index = int(index_str)
			child.connect("pressed", self, "inventorySlotPressed", [index])
			child.connect("mouse_entered", self, "inventoryMouseEntered", [index])
			child.connect("mouse_exited", self, "inventoryMouseExited", [index])

#these two variables are for double pressing inventory slot, old feature, it worked fine but wasn't fun to use 
var last_pressed_index: int = -1 
var last_press_time: float = 0.0

export var double_press_time_inv: float = 0.4
func inventorySlotPressed(index):
	var button = inventory_grid.get_node("InventorySlot" + str(index))# this get's the name of whatever nodes and splits it into the actual name and the number of the slot 
	var icon_texture_rect = button.get_node("Icon")
	var icon_texture = icon_texture_rect.texture	
	if icon_texture != null:
		if  icon_texture.get_path() == "res://UI/graphics/SkillIcons/empty.png":
				button.quantity = 0
		var current_time = OS.get_ticks_msec() / 1000.0
		if last_pressed_index == index and current_time - last_press_time <= double_press_time_inv:
			print("Inventory slot", index, "pressed twice")
			if icon_texture.get_path() == autoload.red_potion.get_path():
				autoload.consumeRedPotion(self,button,inventory_grid,false,null)

			#I preloaded all the icon images in a singleton and called it "autoload"
			#check if the icon texture matches with any of the images in the preload file... you can also check if they match directly in this script by using if icon_texture.get_path() == "res://Potions/Red potion.png": 

			elif icon_texture.get_path() == autoload.strawberry.get_path(): 
					#Do_your_item_functions_here()

					kilocalories +=1
					health += 5
					water += 2
					button.quantity -=1
			elif icon_texture.get_path() == autoload.raspberry.get_path():
					kilocalories += 4
					health += 3
					water += 3
					button.quantity -=1
			elif icon_texture.get_path() == autoload.beetroot.get_path():
					kilocalories += 32
					health += 15
					water += 71.8
					button.quantity -=1
			elif icon_texture.get_path() == "res://UI/graphics/SkillIcons/empty.png":
				button.quantity = 0
		else:
			print("Inventory slot", index, "pressed once")
		last_pressed_index = index
		last_press_time = current_time
		savePlayerData()
#__Hover inventory slots
func inventoryMouseEntered(index):
	var button = inventory_grid.get_node("InventorySlot" + str(index))
	var icon_texture = button.get_node("Icon").texture
	var instance = preload("res://tooltip.tscn").instance()
	UniversalToolTip(icon_texture,instance)

func inventoryMouseExited(index):
	deleteTooltip()

func callToolTipSkills(instance,title,total_value,base_value,cost,cooldown,description):
		gui.add_child(instance)
		instance.showTooltip(title,total_value,base_value,cost,cooldown,description)
func callToolTip(instance,title,text):
		gui.add_child(instance)
		instance.showTooltip(title,text)
# Function to combine slots when pressed
func combineSlots():
	savePlayerData()
	saveSkillBarData()
	saveInventoryData()
	var combined_items = {}  # Dictionary to store combined items
	for child in inventory_grid.get_children():
		if child.is_in_group("Inventory"):
			if child.stackable == true:
				var icon = child.get_node("Icon")
				if icon.texture != null:
					var item_path = icon.texture.get_path()
					if combined_items.has(item_path):
						combined_items[item_path] += child.quantity
						icon.texture = null  # Set texture to null for excess slots
						child.quantity = 0  # Reset quantity
					else:
						combined_items[item_path] = child.quantity
	# Update quantities based on combined_items
	for child in inventory_grid.get_children():
		if child.is_in_group("Inventory"):
			var icon = child.get_node("Icon")
			var item_path = icon.texture.get_path() if icon.texture != null else null
			if item_path in combined_items:
				child.quantity = combined_items[item_path]

func splitFirstSlot():#Activated by button press
	savePlayerData()
	saveInventoryData()
	var first_slot = $UI/GUI/Inventory/ScrollContainer/InventoryGrid/InventorySlot1
	if first_slot.is_in_group("Inventory"):
		var first_icon = first_slot.get_node("Icon")
		if first_icon.texture != null:
			var original_quantity = first_slot.quantity
			if original_quantity > 1:
				for child in inventory_grid.get_children():
					if child.is_in_group("Inventory"):
						var icon = child.get_node("Icon")
						if icon.texture == null:
							icon.texture = first_icon.texture
							child.quantity += original_quantity / 2
							var new_quantity = original_quantity / 2  # Calculate the new quantity
							first_slot.quantity = original_quantity - new_quantity  # Update the quantity of the first slot
							break
