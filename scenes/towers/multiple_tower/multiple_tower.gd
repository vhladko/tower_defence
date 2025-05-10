extends BaseBuilding

var fire_count: int = 3;

func attack() -> void:
	if mobs_in_range.size() == 0:
		return
	mobs_in_range.sort_custom(_sort_by_distance)
	for i in range(fire_count):
		if i >= mobs_in_range.size():
			return
		var target = mobs_in_range[i]
		if is_instance_valid(target):
			var bullet = bullet_prefab.instantiate()
			if bullet is BaseBullet:
				bullet.set_target(target)
				add_child(bullet)
				bullet.global_transform.origin = bullet.global_transform.origin + Vector3(0, 3, 0)
