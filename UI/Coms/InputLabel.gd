extends HBoxContainer
class_name InputLabel 

signal ValChanged(val:int)

@onready var _comEdit:SpinBox = $SpinBox

var Val:int:
    get:
        return int(_comEdit.value)

# func _ready() -> void:
#     # _comLineEdit.text_changed.connect(_onValChanged)
#     _comEdit.text_submitted.connect(_onValChanged)

# func _onValChanged(val:String) -> void:
#     var iVal := int(val)
#     _comLineEdit.text = "%d" % iVal
#     ValChanged.emit(int(val)) 
#     _comLineEdit.release_focus()
#     pass 