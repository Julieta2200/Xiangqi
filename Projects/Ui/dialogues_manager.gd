class_name DialoguesManager

# Manager for all karma table dialogues
# All dialogue texts use translation keys for localization

static func get_level_1_dialog() -> Array[DialogSystem.DialogText]:
	return [
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_1_DIALOG_1"), DialogSystem.CHARACTERS.Jakat),
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_1_DIALOG_2"), DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_1_DIALOG_3"), DialogSystem.CHARACTERS.Jakat),
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_1_DIALOG_4"), DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_1_DIALOG_5"), DialogSystem.CHARACTERS.Jakat),
	]

static func get_level_1_bonus_dialog() -> Array[DialogSystem.DialogText]:
	return [
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_1_BONUS_DIALOG_1"), DialogSystem.CHARACTERS.Jakat),
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_1_BONUS_DIALOG_2"), DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_1_BONUS_DIALOG_3"), DialogSystem.CHARACTERS.Jakat),
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_1_BONUS_DIALOG_4"), DialogSystem.CHARACTERS.Ashes),
	]

static func get_level_2_dialog() -> Array[DialogSystem.DialogText]:
	return [
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_2_DIALOG_1"), DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_2_DIALOG_2"), DialogSystem.CHARACTERS.Jakat),
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_2_DIALOG_3"), DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_2_DIALOG_4"), DialogSystem.CHARACTERS.Jakat),
	]

static func get_level_2_bonus_dialog() -> Array[DialogSystem.DialogText]:
	return [
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_2_BONUS_DIALOG_1"), DialogSystem.CHARACTERS.Jakat),
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_2_BONUS_DIALOG_2"), DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_2_BONUS_DIALOG_3"), DialogSystem.CHARACTERS.Jakat),
	]

static func get_level_3_dialog() -> Array[DialogSystem.DialogText]:
	return [
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_3_DIALOG_1"), DialogSystem.CHARACTERS.Jakat),
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_3_DIALOG_2"), DialogSystem.CHARACTERS.Jakat),
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_3_DIALOG_3"), DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_3_DIALOG_4"), DialogSystem.CHARACTERS.Jakat),
	]

static func get_level_3_bonus_dialog() -> Array[DialogSystem.DialogText]:
	return [
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_3_BONUS_DIALOG_1"), DialogSystem.CHARACTERS.Jakat),
		DialogSystem.DialogText.new(TranslationServer.translate("KARMA_TABLE_LEVEL_3_BONUS_DIALOG_2"), DialogSystem.CHARACTERS.Ashes),
	]

# Returns a dictionary mapping level names to their dialogue arrays
static func get_all_dialogs() -> Dictionary:
	return {
		"1": get_level_1_dialog(),
		"1_bonus": get_level_1_bonus_dialog(),
		"2": get_level_2_dialog(),
		"2_bonus": get_level_2_bonus_dialog(),
		"3": get_level_3_dialog(),
		"3_bonus": get_level_3_bonus_dialog(),
	}

