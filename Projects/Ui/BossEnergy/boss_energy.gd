class_name BossEnergy extends Control


var energy: int = 100 :
	set(e):
		energy = e
		$Bar.value = energy
