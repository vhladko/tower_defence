extends Area3D

func _on_body_entered(body: BaseMob):
	print(body.damage)
	State.set_user_hp(State.user_hp - body.damage)
	body.die()
