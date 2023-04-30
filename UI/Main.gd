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

enum State {
	IDLE,
	WORKING, 
	RESTING, 
	PAUSED, 
}

var last_state:State = State.IDLE; 
var state:State = State.IDLE :
	set(val): 
		last_state = state 
		state = val
		if last_state == State.IDLE:
			_comPauseBtn.disabled = false
			_comStartBtn.disabled = true  
		
		if state == State.IDLE:
			_comPauseBtn.disabled = true  
			_comStartBtn.disabled = false 
		_update_state_label()
		

var scene_timer 
var remainTime:int = 0:
	set(val):
		remainTime = val 
		_updateTimeShow()

func _ready() -> void:
	remainTime = _comWorkTime.Val * 60  
	_comSecondTimer.timeout.connect(_onTimeOut)

	_comStartBtn.pressed.connect(_onStart)
	_comPauseBtn.pressed.connect(_onPause)
	_comResetBtn.pressed.connect(_onReset)

# Start
func _onStart() -> void: 
	state = State.WORKING; 
	remainTime = _comWorkTime.Val * 60 
	_comSecondTimer.start()

func _onPause() -> void:
	if state == State.IDLE:
		return
	
	if state == State.PAUSED:
		state = last_state; 
		_comSecondTimer.start()
		_comPauseBtn.text = tr("暂停")
	else:
		state = State.PAUSED
		_comPauseBtn.text = tr("恢复")
		_comSecondTimer.stop()

func _onReset() -> void:
	state = State.IDLE 
	_comSecondTimer.stop()
	update_remain_time()

func _updateTimeShow() -> void:
	var minute := remainTime / 60 
	var second := remainTime % 60
	_comTimeShowLabel.text = "%02d:%02d" % [minute, second] 

func _onTimeOut() -> void:
	if remainTime <= 0:
		# 弹窗口
		get_tree().paused = true 
		var popup := TimeoutPop.Create(self)
		await popup.End
		get_tree().paused = false 
		if state == State.WORKING:
			state = State.RESTING
		elif state == State.RESTING:
			state = State.WORKING
		update_remain_time()
		return 		
	remainTime -= 1

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		# var popup := TimeoutPop.Create(self)
		# print(popup)
		grab_focus()

func update_remain_time() -> void:
	if state == State.WORKING || state == State.IDLE:
		remainTime = _comWorkTime.Val * 60 
	else:
		remainTime = _comRestTime.Val * 60 
	print("here state: ", state, " here time:", remainTime)

func _update_state_label() -> void:
	var info := ""
	match state:
		State.IDLE:
			info = tr("等待开始")
		State.WORKING:
			info = tr("工作中")
		State.RESTING:
			info = tr("休息中")
		State.PAUSED:
			info = tr("暂停中")
	_comStateLabel.text = info 