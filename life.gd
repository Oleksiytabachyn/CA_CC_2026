extends Node2D

var board=[]
var board2=[]
var running=false
var rainbow_on=false
var lastcell=[-1,-1]
var firstcell=[0,0]
var menu=true

var alive_cells=0
var dead_cells=0
var cells_born=0
var cells_died=0
var alive_cells_note=0
var dead_cells_note=0
var cells_born_note=0
var cells_died_note=0


var size=50
var cell_size:float
var game_speed=10
var game_speed_sec=game_speed/60.0

var slider1_value=90
var slider2_value=90
var slider3_value=90
var slider4_value=0
var slider5_value=0
var slider6_value=0

var no_x=1010
var no_y=820

var save_location="user://SaveFile.json"
var save_dictionary: Dictionary={
	"example_1":[],
	"charecteristics_1":[50,"1-empty",false,Color.BLACK,Color.WHITE,10],
	"music_1": [true,true,true,true,0,1,2,3], 
	
	"example_2":[],
	"charecteristics_2":[50,"2-empty",false,Color.BLACK,Color.WHITE,10],
	"music_2": [true,true,true,true,0,1,2,3], 
	
	"example_3":[],
	"charecteristics_3":[50,"3-empty",false,Color.BLACK,Color.WHITE,10],
	"music_3": [true,true,true,true,0,1,2,3], 
	
	"example_4":[],
	"charecteristics_4":[50,"4-empty",false,Color.BLACK,Color.WHITE,10],
	"music_4": [true,true,true,true,0,1,2,3], 
	
	"example_5":[],
	"charecteristics_5":[50,"5-empty",false,Color.BLACK,Color.WHITE,10],
	"music_5": [true,true,true,true,0,1,2,3], 
	
	"example_6":[],
	"charecteristics_6":[50,"6-empty",false,Color.BLACK,Color.WHITE,10],
	"music_6": [true,true,true,true,0,1,2,3], 
	
	"example_7":[],
	"charecteristics_7":[50,"7-empty",false,Color.BLACK,Color.WHITE,10],
	"music_7": [true,true,true,true,0,1,2,3], 
	
	"example_8":[],
	"charecteristics_8":[50,"8-empty",false,Color.BLACK,Color.WHITE,10],
	"music_8": [true,true,true,true,0,1,2,3], 
	
	"example_9":[],
	"charecteristics_9":[50,"9-empty",false,Color.BLACK,Color.WHITE,10],
	"music_9": [true,true,true,true,0,1,2,3], 
	
	"example_10":[],
	"charecteristics_10":[50,"10-empty",false,Color.BLACK,Color.WHITE,10],
	"music_10": [true,true,true,true,0,1,2,3], 
}



var check_board=[]

func save_to_file():
	var file=FileAccess.open(save_location,FileAccess.WRITE)
	file.store_var(save_dictionary.duplicate(true))
	file.close()

func load_save():
		var file=FileAccess.open(save_location,FileAccess.READ)
		var data=file.get_var()
		file.close()
		
		var save_data=data.duplicate(true)
		var save_num=$menu/control/OptionButton2.get_selected_id()
		print(save_data["charecteristics_"+str(save_num+1)][0])
		print(save_data["charecteristics_"+str(save_num+1)][1])
		$menu/boardsettings/HSlider.value=save_data["charecteristics_"+str(save_num+1)][0]
		board=save_data["example_"+str(save_num+1)]
		rainbow_on=save_data["charecteristics_"+str(save_num+1)][2]
		if not rainbow_on:
			$menu/boardsettings/ColorPickerButton.color=save_data["charecteristics_"+str(save_num+1)][3]
		$menu/boardsettings/ColorPickerButton2.color=save_data["charecteristics_"+str(save_num+1)][4]
		$menu/control/HSlider.value=save_data["charecteristics_"+str(save_num+1)][5]
		
		

func initialize_save():
	if FileAccess.file_exists(save_location):
		var file=FileAccess.open(save_location,FileAccess.READ)
		var data=file.get_var()
		file.close()
		
		var save_data=data.duplicate(true)
	
		for i in range(10):
			$menu/control/OptionButton.set_item_text(i,save_data["charecteristics_"+str(i+1)][1])
			$menu/control/OptionButton2.set_item_text(i,save_data["charecteristics_"+str(i+1)][1])
			for j in range(len(save_dictionary["charecteristics_"+str(i+1)])):
				save_dictionary["charecteristics_"+str(i+1)][j]=save_data["charecteristics_"+str(i+1)][j]
			
			save_dictionary["example_"+str(i+1)]=save_data["example_"+str(i+1)].duplicate(true)
	else:
		for i in range(10):
			save_dictionary["example_"+str(i+1)]=board.duplicate(true)
			
			var text="empty"
			$menu/control/OptionButton.set_item_text(i,str(i+1)+"-"+text)
			$menu/control/OptionButton2.set_item_text(i,str(i+1)+"-"+text)
			save_to_file()
		
		

func create_check_board():
	check_board=[]
	for i in range(size):
		var row=[]
		for j in range(size):
			row.append(false)
		check_board.append(row)
	
func change_instrument(channel, instrument):
	var midi_event = InputEventMIDI.new()
	midi_event.channel = channel
	midi_event.message = MIDI_MESSAGE_PROGRAM_CHANGE
	midi_event.instrument = instrument
	$MidiPlayer.receive_raw_midi_message(midi_event)

func play_note(note, duration, channel):
	
	
	
	var m = InputEventMIDI.new()
	m.message = MIDI_MESSAGE_NOTE_ON
	m.pitch = note
	m.velocity = 100
	m.channel = channel		
	$MidiPlayer.receive_raw_midi_message(m)	
	await get_tree().create_timer(duration).timeout
	m = InputEventMIDI.new()
	m.message = MIDI_MESSAGE_NOTE_OFF
	m.pitch = note
	m.velocity = 100
	m.channel = channel		
	$MidiPlayer.receive_raw_midi_message(m)	
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	var r=get_viewport_rect()
	cell_size=r.size.y/float(size)
	create_board()
	initialize_save()
	create_count_board()
	create_check_board()
	change_instrument(1,40)
	change_instrument(2,24)
	initialize_save()
	
	
	pass # Replace with function body.

func create_board():
	board=[]
	for i in range(size):
		var row=[]
		for j in range(size):
			row.append(false)
		board.append(row)
		
func randomize_board():
	randomize()
	for i in range(size):
		for j in range(size):
			var ran=randi_range(0,1)
			if ran==1:
				board[i][j]=true
			else:
				board[i][j]=false
				
func draw_board():
	var vs=get_viewport_rect().size
	for r in size:
		for c in size:
			var x = remap(c, 0, size, 0, vs.y)
			var y = remap(r, 0, size, 0, vs.y)
			var col = $menu/boardsettings/ColorPickerButton2.color
			
			if board[r][c]==true:
				if rainbow_on:
					col=Color.from_hsv((r+c)/float(size*2),1,1)
				else:
					col=$menu/boardsettings/ColorPickerButton.color
			
			draw_rect(Rect2(x, y, cell_size,cell_size), col)
			
func count_neigbours(r,c):
	var count=0
	for i in range(3):
		for j in range(3):
			if r+1-i>size-1 or r+1-i<0 or c+1-j<0 or c+1-j>size-1:
				continue
			count+=1 if board[r+1-i][c+1-j] else 0
	if board[r][c]:
		count-=1
	return count
			
func create_count_board():
	board2=[]
	for i in range(size):
		var row=[]
		for j in range(size):
			row.append(count_neigbours(i,j))
		board2.append(row)

func update_count_board():
	for i in range(size):
		for j in range(size):
			board2[i][j]=count_neigbours(i,j)
		

func board_update():
	update_count_board()
	dead_cells=0
	cells_died=0
	cells_born=0
	alive_cells=0
	for i in range(size):
		for j in range(size):
			if (board2[i][j]<2 or board2[i][j]>3) and board[i][j]:
				board[i][j]=false
				cells_died+=i*int(size)+j
			elif board[i][j]==false and board2[i][j]==3:
				board[i][j]=true
				cells_born+=i*int(size)+j
			elif board[i][j]==false and board2[i][j]!=3:
				dead_cells+=i*int(size)+j		
			else:
				alive_cells+=i*int(size)+j		
			
	
	
	
	
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	paint()
	queue_redraw()
	if Engine.get_frames_drawn()%game_speed==0 and running:
		board_update()
		play_music()
	
	

func _draw() -> void:
	draw_board()
	pass


func _on_button_pressed() -> void:
	if running:
		running=false
		$Button3.text="Start"
	else:
		running=true
		$Button3.text="Stop"
	


func _on_randomize_pressed() -> void:
	randomize_board()
	pass # Replace with function body.
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed :
		if no_x<get_viewport().get_mouse_position().x and no_y>get_viewport().get_mouse_position().y:
			return 
		var vs=get_viewport_rect().size
		var x=get_viewport().get_mouse_position().x
		var y=get_viewport().get_mouse_position().y
		
		var r=floor(remap(y,0,vs.y,0,size))
		var c=floor(remap(x,0,vs.y,0,size))
		if c<size:
			if board[r][c]:
				board[r][c]=false
			else:
				board[r][c]=true
	'''if Input.is_action_just_pressed("stop"):
		if running:
			running=false
			$Button3.text="Start"
		else:
			running=true
			$Button3.text="Stop"
	if Input.is_action_just_pressed("menu"):
		if menu:
			$Button2.text="Menu"
			$menu.visibility_layer=false
			menu=false
			no_x=1070
			no_y=90
		else:
			$Button2.text="Hide Menu"
			$menu.visibility_layer=true
			menu=true
			no_x=1010
			no_y=820'''
		
		
func paint():
	if no_x<get_viewport().get_mouse_position().x and no_y>get_viewport().get_mouse_position().y:
		return 
		
	
	if Input.is_action_just_pressed("paint"):
		
		var vs=get_viewport_rect().size
		var x=get_viewport().get_mouse_position().x
		var y=get_viewport().get_mouse_position().y
		var r=floor(remap(y,0,vs.y,0,size))
		var c=floor(remap(x,0,vs.y,0,size))
		firstcell=[r,c]
		if [r,c]==firstcell and c<size:
			if not board[r][c]:
				board[r][c]=false
			else:
				board[r][c]=true
		
	if Input.is_action_pressed("paint"):
		
		var vs=get_viewport_rect().size
		var x=get_viewport().get_mouse_position().x
		var y=get_viewport().get_mouse_position().y
		var r=floor(remap(y,0,vs.y,0,size))
		var c=floor(remap(x,0,vs.y,0,size))
		if c<size and [r,c]!=firstcell:
			
			board[r][c]=true 
			

func create_notes():
	alive_cells_note=alive_cells%61 if $menu/musicalsettings/allivecells/CheckBox9.button_pressed else alive_cells%128
	dead_cells_note=dead_cells%61 if $menu/musicalsettings/deadcells/CheckBox9.button_pressed else dead_cells%128
	cells_born_note=cells_born%61 if $menu/musicalsettings/borncells/CheckBox4.button_pressed else cells_born%128
	cells_died_note=cells_died%61 if $menu/musicalsettings/Cellsdied/CheckBox9.button_pressed else cells_died%128
	pass
	
func play_music():
	var chan1_modif=slider1_value-slider6_value+1
	var chan2_modif=slider2_value-slider5_value+1
	var chan3_modif=slider3_value-slider4_value+1
	create_notes()
	
	if $menu/musicalsettings/CheckBox8.button_pressed:
		if $menu/musicalsettings/allivecells/CheckBox.button_pressed:
			play_note(alive_cells_note%chan1_modif+slider6_value,game_speed_sec,0)
			
		elif $menu/musicalsettings/allivecells/CheckBox1.button_pressed:
			play_note(alive_cells_note%chan2_modif+slider5_value,game_speed_sec,1)
			
		elif $menu/musicalsettings/allivecells/CheckBox2.button_pressed:
			play_note(alive_cells_note%chan3_modif+slider4_value,game_speed_sec,2)
			
		else:
			play_note(alive_cells_note,game_speed_sec,9)
			
	if $menu/musicalsettings/CheckBox.button_pressed:
		
		if $menu/musicalsettings/borncells/CheckBox.button_pressed:
			play_note(cells_born_note%chan1_modif+slider6_value,game_speed_sec,0)
			
		elif $menu/musicalsettings/borncells/CheckBox2.button_pressed:
			play_note(cells_born_note%chan2_modif+slider5_value,game_speed_sec,1)
			
		elif $menu/musicalsettings/borncells/CheckBox3.button_pressed:
			play_note(cells_born_note%chan3_modif+slider4_value,game_speed_sec,2)
			
		else:
			play_note(cells_born_note,game_speed_sec,9)
			
	if $menu/musicalsettings/CheckBox2.button_pressed:
		
		if $menu/musicalsettings/Cellsdied/CheckBox.button_pressed:
			play_note(cells_died_note%chan1_modif+slider6_value,game_speed_sec,0)
			
		elif $menu/musicalsettings/Cellsdied/CheckBox1.button_pressed:
			play_note(cells_died_note%chan2_modif+slider5_value,game_speed_sec,1)
			
		elif $menu/musicalsettings/Cellsdied/CheckBox2.button_pressed:
			play_note(cells_died_note%chan3_modif+slider4_value,game_speed_sec,2)
			
		else:
			play_note(cells_died_note,game_speed_sec,9)
			
	if $menu/musicalsettings/CheckBox3.button_pressed:
		if $menu/musicalsettings/deadcells/CheckBox.button_pressed:
			play_note(dead_cells_note%chan1_modif+slider6_value,game_speed_sec,0)
			
		elif $menu/musicalsettings/deadcells/CheckBox1.button_pressed:
			play_note(dead_cells_note%chan2_modif+slider5_value,game_speed_sec,1)
			

		elif $menu/musicalsettings/deadcells/CheckBox2.button_pressed:
			play_note(dead_cells_note%chan3_modif+slider4_value,game_speed_sec,2)
			
		else:
			play_note(dead_cells_note,game_speed_sec,9)
			
	pass

func _on_button_2_pressed() -> void:
	for i in range(size):
		for j in range(size):
			board[i][j]=false
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	if rainbow_on:
		rainbow_on=false
		$menu/boardsettings/Button3.text="Alive Tiles:\nClick to set to rainbow"
		$menu/boardsettings/ColorPickerButton.visible=true
	else:
		rainbow_on=true
		$menu/boardsettings/Button3.text="Alive Tiles: Rainbow\nClick to pick custom color"
		$menu/boardsettings/ColorPickerButton.visible=false
	pass # Replace with function body.


func _on_h_slider_value_changed(value: float) -> void:
	size=$menu/boardsettings/HSlider.value
	$menu/boardsettings/Label2.text="Board size: "+str(int(size))
	var r=get_viewport_rect()
	cell_size=r.size.y/float(size)
	create_board()
	create_count_board()
	create_check_board()
	pass # Replace with function body.


func _on_game_speed_value_changed(value: float) -> void:
	game_speed=int($menu/control/HSlider.value)
	game_speed_sec=game_speed/60.0
	$menu/control/Label2.text="Game speed:\nevery "+str(int($menu/control/HSlider.value))+" frames"
	pass # Replace with function body.


func _on_check_box_toggled(toggled_on: bool) -> void:
	$menu/musicalsettings/borncells.visible=toggled_on
	pass # Replace with function body.


func _on_check_box_2_toggled(toggled_on: bool) -> void:
	$menu/musicalsettings/Cellsdied.visible=toggled_on
	pass # Replace with function body.


func _on_check_box_3_toggled(toggled_on: bool) -> void:
	$menu/musicalsettings/deadcells.visible=toggled_on
	pass # Replace with function body.


func _on_check_box_8_toggled(toggled_on: bool) -> void:
	$menu/musicalsettings/allivecells.visible=toggled_on
	pass # Replace with function body.





func _on_option_button_item_selected(index: int) -> void:
	
	change_instrument(0,index*8)
	pass # Replace with function body.


func _on_option_button_2_item_selected(index: int) -> void:
	
	change_instrument(1,index*8)
	pass # Replace with function body.


func _on_option_button_3_item_selected(index: int) -> void:
	
	change_instrument(2,index*8)
	pass # Replace with function body.


func _on_channel_0_value_changed(value: float) -> void:
	slider1_value=int($menu/musicalsettings/channels/HSlider.value)
	$menu/musicalsettings/channels/Label10.text="Highest note "+str(slider1_value)
	$menu/musicalsettings/channels/HSlider6.max_value=slider1_value
	pass # Replace with function body.


func _on_channel_2_value_changed(value: float) -> void:
	slider2_value=int($menu/musicalsettings/channels/HSlider2.value)
	$menu/musicalsettings/channels/Label11.text="Highest note "+str(slider2_value)
	$menu/musicalsettings/channels/HSlider5.max_value=slider2_value
	pass # Replace with function body.


func _on_h_slider_3_value_changed(value: float) -> void:
	slider3_value=int($menu/musicalsettings/channels/HSlider3.value)
	$menu/musicalsettings/channels/Label12.text="Highest note "+str(slider3_value)
	$menu/musicalsettings/channels/HSlider4.max_value=slider3_value
	pass # Replace with function body.


func _on_menu_pressed() -> void:
	if menu:
		$Button2.text="Menu"
		$menu.visibility_layer=false
		menu=false
		no_x=1070
		no_y=90
	else:
		$Button2.text="Hide Menu"
		$menu.visibility_layer=true
		menu=true
		no_x=1010
		no_y=820
		
	pass # Replace with function body.


func _on_h_slider_4_value_changed(value: float) -> void:
	slider4_value=int($menu/musicalsettings/channels/HSlider4.value)
	$menu/musicalsettings/channels/Label13.text="Lowest note "+str(slider4_value)
	$menu/musicalsettings/channels/HSlider3.min_value=slider4_value
	pass # Replace with function body.


func _on_h_slider_5_value_changed(value: float) -> void:
	slider5_value=int($menu/musicalsettings/channels/HSlider5.value)
	$menu/musicalsettings/channels/Label14.text="Lowest note "+str(slider5_value)
	$menu/musicalsettings/channels/HSlider2.min_value=slider5_value
	pass # Replace with function body.


func _on_h_slider_6_value_changed(value: float) -> void:
	slider6_value=int($menu/musicalsettings/channels/HSlider6.value)
	$menu/musicalsettings/channels/Label15.text="Lowest note "+str(slider6_value)
	$menu/musicalsettings/channels/HSlider.min_value=slider6_value
	pass # Replace with function body.
	


func _on_save_pressed() -> void:
	var layout_num=$menu/control/OptionButton.get_selected_id()
	save_dictionary["example_"+str(layout_num+1)]=board
	save_dictionary["charecteristics_"+str(layout_num+1)][0]=size
	var text=$menu/control/TextEdit.text if $menu/control/TextEdit.text!="" else "layout "+str(layout_num+1)
	if board==check_board:
		text="empty"
		
		
		
		
	$menu/control/OptionButton.set_item_text(layout_num,str(layout_num+1)+"-"+text)
	$menu/control/OptionButton2.set_item_text(layout_num,str(layout_num+1)+"-"+text)
	save_dictionary["charecteristics_"+str(layout_num+1)][1]=str(layout_num+1)+"-"+text
	save_dictionary["charecteristics_"+str(layout_num+1)][2]=rainbow_on
	save_dictionary["charecteristics_"+str(layout_num+1)][3]=$menu/boardsettings/ColorPickerButton.color
	save_dictionary["charecteristics_"+str(layout_num+1)][4]=$menu/boardsettings/ColorPickerButton2.color
	save_dictionary["charecteristics_"+str(layout_num+1)][5]=$menu/control/HSlider.value
	save_to_file()
	
	pass # Replace with function body.


func _on_load_pressed() -> void:
	load_save()
	pass # Replace with function body.
