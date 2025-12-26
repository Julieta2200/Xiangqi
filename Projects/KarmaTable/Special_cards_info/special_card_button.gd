extends Button

signal card_select(type,number)

@export var type: SpecialCardInfo.SpecialType
@export var image: Texture
@export var number: int
@export var active : bool:
	set(a):
		active = a
		#disabled = !active
		$name_icon.visible = !active

func _ready() -> void:
	if type == SpecialCardInfo.SpecialType.NONE:
		change_button_to_image()
		active = false
	if type == SpecialCardInfo.SpecialType.TREE_TRUNK or type == SpecialCardInfo.SpecialType.SNAKE_CHAIN \
	or type == SpecialCardInfo.SpecialType.DISCONNECTION_MIST:
		$icon.position = Vector2(47,50)
		$icon.scale = Vector2(0.3,0.3)
	elif type == SpecialCardInfo.SpecialType.WATER_PORTAL:
		$icon.position = Vector2(26,29)
		$icon.scale = Vector2(0.3,0.3)
	else:
		$icon.size = Vector2(44,56)
		#text = ""
		$icon.position = Vector2(62,58)
		$icon.scale = Vector2.ONE
	$icon.texture = image

func _on_special_card_pressed() -> void:
	print("click")
	emit_signal("card_select", type, number)

func change_button_to_image():
	# 1. Ստեղծում ենք նոր StyleBoxTexture
	var new_style = StyleBoxTexture.new()
	
	# 2. Բեռնում ենք նկարը (Texture)
	var image = preload("res://Assets/UI/Ability info/Ability Slot(Locked).png")
	
	# 3. Նկարը տեղադրում ենք ոճի մեջ
	new_style.texture = image
	
	# (Լրացուցիչ) Եթե ուզում ես, որ նկարը չձգվի սխալ ձևով, կարող ես սահմանել margin-ները (9-patch)
	# new_style.texture_margin_left = 10
	# new_style.texture_margin_right = 10
	
	# 4. Կիրառում ենք կոճակի "normal" (սովորական) վիճակի վրա
	add_theme_stylebox_override("normal", new_style)
	add_theme_stylebox_override("hover", new_style)
