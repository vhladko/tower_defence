extends Label

func _process(_delta):
	self.text = 'Gold %d' % State.gold
