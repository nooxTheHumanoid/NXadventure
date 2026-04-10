extends Node2D

@onready var numbers = $YourNumber
@onready var TestBossNum = $BossNumbers
@onready var playerHPBar = $PlayerHP
@onready var bossHPBar = $BossHP
@onready var hitButton = $Hit
@onready var passButton = $Pass
@onready var NextCardText = $NextCard
@onready var thinktimer = $Timer
@onready var StreakText = $WinStreak
@onready var PassText = $PassOppText
@onready var GuessCardText = $GuessingBossNumbers
@onready var LoserText = $LoserText
@onready var playerHPnum = $PlayerHPnum
@onready var oppHPnum = $BossHPnum
@onready var BGmusic = $AudioStreamPlayer2D

@export_group("Game Settings")
@export var playerTurn = true
@export var playerHP = 21
@export var oppHP = 35
@export var maxcards = 21
@export var PickUpCardNumMin = 1
@export var PickUpCardNumMax = 11
@export var playerCards = 0
@export var oppCards = 0
@export var dmg = 5
@export var dmgCrit = 10
@export var dmgloss = 3
@export var dmgCritloss = 6
@export_group("")
@export_group("Cheats")
@export var SeeNextCard = false
@export var SeeOppsCardCount = false
@export_group("")
@export_group("End Game")
@export var PlayerWin = "res://Levels/card_game.tscn"
@export var PlayerLoss = "res://Levels/card_game.tscn"
@export_group("")

var oppPass = false
var oppStartCard = 0
var nextCard = randi_range(PickUpCardNumMin,PickUpCardNumMax)
var nextcardguess = randi_range(PickUpCardNumMin,PickUpCardNumMax)
var estematedValue = oppCards + nextcardguess
var currentWinStreak = 0
func _ready() -> void:
	playerCards = randi_range(2,10)
	oppCards = randi_range(2,10)
	oppStartCard = oppCards
	numbers.text = str(playerCards) + '/' + str(maxcards)
	TestBossNum.text = str(oppCards) + '/' + str(maxcards)
	GuessCardText.text = '?+' + str(oppCards-oppStartCard) + '/' + str(maxcards)
	NextCardText.text = "Next Card is: " + str(nextCard)
	StreakText.text = "Winstreak: " + str(currentWinStreak)
	playerHPnum.text = str(playerHP)
	oppHPnum.text = str(oppHP)
	playerHPBar.max_value = playerHP
	bossHPBar.max_value = oppHP
	PassText.visible = false
	LoserText.visible = false
	BGmusic.playing = global.Music_Enabled
	if SeeNextCard:
		NextCardText.visible = true
	else:
		NextCardText.visible = false
	if SeeOppsCardCount:
		TestBossNum.visible = true
		GuessCardText.visible = false
	else:
		TestBossNum.visible = false
		GuessCardText.visible = true
	if not playerTurn:
		thinktimer.start()



func _process(_delta: float) -> void:
	numbers.text = str(playerCards) + '/' + str(maxcards)
	TestBossNum.text = str(oppCards) + '/' + str(maxcards)
	GuessCardText.text = '?+' + str(oppCards-oppStartCard) + '/' + str(maxcards)
	NextCardText.text = "Next Card is: " + str(nextCard)
	StreakText.text = "Winstreak: " + str(currentWinStreak)
	playerHPnum.text = str(playerHP)
	oppHPnum.text = str(oppHP)
	playerHPBar.value = playerHP
	bossHPBar.value = oppHP
	estematedValue = oppCards + nextcardguess
	if SeeNextCard:
		NextCardText.visible = true
	else:
		NextCardText.visible = false
	if SeeOppsCardCount:
		TestBossNum.visible = true
		GuessCardText.visible = false
	else:
		TestBossNum.visible = false
		GuessCardText.visible = true
	if playerTurn:
		passButton.visible = true
		if not LoserText.visible:
			hitButton.visible = true
	else:
		passButton.visible = false
		hitButton.visible = false
	if oppPass:
		PassText.visible = true
	else:
		PassText.visible = false
	if playerHP <= 0:
		get_tree().change_scene_to_file(PlayerLoss)
	if oppHP <= 0:
		get_tree().change_scene_to_file(PlayerWin)


func _on_hit_pressed() -> void:
	if playerCards <= maxcards:
		playerCards += nextCard
		nextCard = randi_range(PickUpCardNumMin,PickUpCardNumMax)
		nextcardguess = randi_range(PickUpCardNumMin,PickUpCardNumMax)
		playerTurn = false
		thinktimer.start()
	else:
		LoserText.visible = true
		playerTurn = false
		thinktimer.start()


func _on_pass_pressed() -> void:
	playerTurn = false
	if not oppPass:
		thinktimer.start()
	
	if oppPass:
		if (playerCards == oppCards): #just damage both if their cards are equal
			playerHP -= dmgloss
			oppHP -= (dmg + currentWinStreak)
			currentWinStreak = 0
		elif (playerCards > oppCards && playerCards == maxcards):
			oppHP -= (dmgCrit + currentWinStreak)
			currentWinStreak += 1
		elif (playerCards > oppCards && playerCards < maxcards && playerCards != maxcards):
			oppHP -= (dmg + currentWinStreak)
			currentWinStreak += 1
		elif (playerCards < oppCards && oppCards == maxcards):
			playerHP -= dmgloss
			currentWinStreak = 0
		elif (playerCards < oppCards && oppCards < maxcards && oppCards != maxcards):
			playerHP -= dmgCritloss
			currentWinStreak = 0
		elif (playerCards < oppCards && oppCards > maxcards && oppCards != maxcards):
			oppHP -= (dmg + currentWinStreak)
			currentWinStreak += 1
		elif (playerCards > oppCards && playerCards > maxcards && playerCards != maxcards):
			playerHP -= dmgloss
			currentWinStreak = 0
		elif (playerCards > oppCards && playerCards > maxcards && oppCards > maxcards && playerCards != maxcards && oppCards != maxcards): #who's closer to 21
			playerHP -= dmgloss
			currentWinStreak = 0
		elif (playerCards < oppCards && playerCards > maxcards && oppCards > maxcards && playerCards != maxcards && oppCards != maxcards):
			oppHP -= (dmg + currentWinStreak)
			currentWinStreak += 1
		elif (oppCards > maxcards && oppCards != maxcards): # This will check if anyone has more than 21 cards (Incase if no damage was dealt in the previous ones)
			oppHP -= (dmg + currentWinStreak)
			currentWinStreak += 1
		elif (playerCards > maxcards && playerCards != maxcards):
			playerHP -= dmgloss
			currentWinStreak = 0
		oppPass = false
		playerTurn = true
		playerCards = randi_range(2,10)
		oppCards = randi_range(2,10)
		oppStartCard = oppCards
		LoserText.visible = false


func _on_timer_timeout() -> void:
	if (oppCards < maxcards && estematedValue <= maxcards) && oppCards != maxcards:
		oppCards += nextCard
		nextCard = randi_range(PickUpCardNumMin,PickUpCardNumMax)
		nextcardguess = randi_range(PickUpCardNumMin,PickUpCardNumMax)
		estematedValue = oppCards + nextcardguess
		oppPass = false
		playerTurn = true
	else:
		oppPass = true
		playerTurn = true
