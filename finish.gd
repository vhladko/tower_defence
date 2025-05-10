extends Area3D

func _on_body_entered(body: Mob):
	State.set_user_hp(State.user_hp - body.damage)
	body.queue_free()
