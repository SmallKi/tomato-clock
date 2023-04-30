extends Control

@onready var _comWorkTime:InputLabel = $%WorkTime
@onready var _comRestTime:InputLabel = $%RestTime 
@onready var _comStartBtn:Button = $%StartBtn
@onready var _comPauseBtn:Button = $%PauseBtn
@onready var _comResetBtn:Button = $%ResetBtn 
@onready var _comTimeShowLabel:Label = $%TimeShowLabel 
@onready var _comSecondTimer:Timer = $SecondTimer
@onready var _comStateLabel:Label = $%StateLabel
# Called when the node enters the scene tree for the first time.

var scene_timer 
var remainTime:int = 0:
	set(val):
		remainTime = val 
		_updateTimeShow()
var is_working := true:
	set(val):
		is_working = val 
		_update_state_label()
var is_paused := false:
	set(val) :
		is_paused = val 
		_update_state_label()
var is_start := false:
	set(val):
		is_start = val 
		if is_start:
			_comPauseBtn.disabled = false
			_comStartBtn.disabled = true  
		else:
			_comPauseBtn.disabled = true  
			_comStartBtn.disabled = false 
		_update_state_label()

func _ready() -> void:
	remainTime = _comWorkTime.Val * 60  
	_comSecondTimer.timeout.connect(_onTimeOut)

	_comStartBtn.pressed.connect(_onStart)
	_comPauseBtn.pressed.connect(_onPause)
	_comResetBtn.pressed.connect(_onReset)
	pass # Replace with function body.

func _onStart() -> void:
	is_start = true 
	is_working = true 
	remainTime = _comWorkTime.Val * 60 
	_comSecondTimer.start()

func _onPause() -> void:
	is_paused = !is_paused
	if is_paused:
		_comPauseBtn.text = tr("恢复")
		_comSecondTimer.stop()
	else:
		_comPauseBtn.text = tr("暂停")
		_comSecondTimer.start()

func _onReset() -> void:
	remainTime = _comWorkTime.Val * 60 
	_comSecondTimer.stop()
	is_working = false 
	is_paused = false 
	is_start = false 

func _updateTimeShow() -> void:
	var minute := remainTime / 60 
	var second := remainTime % 60
	_comTimeShowLabel.text = "%02d:%02d" % [minute, second] 

func _onTimeOut() -> void:
	if remainTime <= 0:
		# 弹窗口
		is_working = !is_working 
		get_tree().paused = true 
		var popup := TimeoutPop.Create(self)
		await popup.End
		get_tree().paused = false 
		update_remain_time()
		return 		
	remainTime -= 1

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		# var popup := TimeoutPop.Create(self)
		# print(popup)
		grab_focus()

func update_remain_time() -> void:
	if is_working:
		remainTime = _comWorkTime.Val * 60 
	else:
		remainTime = _comRestTime.Val * 60 

func _update_state_label() -> void:
	var info := ""
	if is_start:
		if is_paused:
			info = tr("暂停中")
		else:
			if is_working:
				info = tr("工作中") 
			else:
				info = tr("休息中") 
	_comStateLabel.text = info 