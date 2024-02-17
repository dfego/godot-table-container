@tool
class_name TableContainer extends VBoxContainer
## A basic extension of [VBoxContainer] that treats [HBoxContainer] children like rows.
##
## The purpose of this class is to keep all nodes within a column the same width.

## Whether or not to auto-update in [method _process] for the editor
@export var auto_update_in_editor: bool = true

## Update interval for the editor, in frames, if [member auto_update_in_editor] is true
@export var update_interval_in_editor: int = 60

## Whether or not to auto-update in [method _process] for the game
@export var auto_update_in_game: bool = true

## Update interval, in frames, if [member auto_update_in_game] is true
@export var update_interval_in_game: int = 60

# Update counter used in [_process] for the editor
var _update_counter_editor: int = 0

# Update counter used in [_process] for the game
var _update_counter_game: int = 0


func _ready() -> void:
	if Engine.is_editor_hint():
		_update_counter_editor = 0
	else:
		_update_counter_game = 0

	refresh_size()


## Update the table based on the exported parameters.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if auto_update_in_editor:
			if _update_counter_editor == 0:
				refresh_size()
			_update_counter_editor = (_update_counter_editor + 1) % update_interval_in_editor
	else:
		if auto_update_in_game:
			if _update_counter_game == 0:
				refresh_size()
			_update_counter_game = (_update_counter_game + 1) % update_interval_in_game


## Update the table size manually.
## This is required in-game if [member auto_update_in_game] is false.
func refresh_size() -> void:
	var children: Array[Node] = get_children()
	var rows: Array[HBoxContainer] = []  # for static typing
	rows.assign(children)

	_clear_custom_column_widths(rows)
	_set_column_widths(rows)


func _clear_custom_column_widths_for_row(row: HBoxContainer) -> void:
	var children: Array[Node] = row.get_children()
	var cells: Array[Control] = []  # for static typing
	cells.assign(children)
	for cell: Control in cells:
		cell.custom_minimum_size = Vector2.ZERO


func _clear_custom_column_widths(rows: Array[HBoxContainer]) -> void:
	for row: HBoxContainer in rows:
		_clear_custom_column_widths_for_row(row)


# TODO handle if there's different columns, probably with a warning
func _set_column_widths(rows: Array[HBoxContainer]) -> void:
	var column_widths: Array[float] = []

	var first_row: bool = true
	for row: HBoxContainer in rows:
		var children: Array[Node] = row.get_children()
		var cells: Array[Control] = []  # for static typing
		cells.assign(children)
		if first_row:
			first_row = false
			for index: int in cells.size():
				var cell: Control = cells[index]
				column_widths.append(cell.get_combined_minimum_size().x)
		else:
			for index: int in cells.size():
				var cell: Control = cells[index]
				var cell_minimum_width: float = cell.get_combined_minimum_size().x
				var column_minimum_width: float = column_widths[index]

				if cell_minimum_width > column_minimum_width:
					column_widths[index] = cell_minimum_width

	for row: HBoxContainer in rows:
		var children: Array[Node] = row.get_children()
		var cells: Array[Control] = []  # for static typing
		cells.assign(children)
		for index: int in cells.size():
			var cell: Control = cells[index]
			cell.custom_minimum_size.x = column_widths[index]
