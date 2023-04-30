extends Panel
class_name TimeoutPop

signal End
const scene := preload("res://UI/Coms/TimeoutPop.tscn")
@onready var _comKnowBtn:Button = $%KnowBtn 

static func Create(owner:Control) -> TimeoutPop:
	var p := scene.instantiate() as TimeoutPop
	owner.add_child(p)
	return p

func _ready() -> void:
	_comKnowBtn.pressed.connect(_onBtnPressed)

func _onBtnPressed() -> void:
	print("here")
	End.emit()
	queue_free()
