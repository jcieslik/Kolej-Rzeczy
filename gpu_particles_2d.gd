extends GPUParticles2D

enum MovementState {
	IDLE,
	RUNNING,
	DASHING
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = false
	one_shot = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var parent = get_parent()
	
	if parent.current_state == MovementState.DASHING:
		emitting = true
		
