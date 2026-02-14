extends Control
#Created by Asher Petersen for Godot.


var idOfScore
@export var LeaderboardName = "Demo"


#Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#This function asks if there is a leaderboard with 
	#the name stored in leaderboardName. By default, that is 
	#"Demo" just to show you how this works. If there is not a 
	#leaderboard with that name, create a new leaderboard
	#with the name "Demo" (This is how you should create a
	#leaderboard with code. In the example, there is already
	#a leaderbaord with the name "Demo")
	if not await Leaderboard.leaderboard_exists(LeaderboardName):
		#Create a leaderboard with the name "Demo"
		Leaderboard.create_leaderboard(LeaderboardName)
		#Default order direction is Ascending
		
		#This would create a leaderboard with the name "Demo" that 
		#would sort in descending order, except for text, wich don't
		#get sorted.
		#Leaderboard.create_leaderboard("Demo", "Descending")
		
		#This would create a leaderboard with the name "Demo" that 
		#doesn't change the order of scores. That means that it 
		#will be in the order they were scored.
		#Leaderboard.create_leaderboard("Demo", "NoChange")
	
	#This function lets the script know that the leaderboard with 
	#the name "Demo" is the leaderboard you are using. Replace
	#"Demo" with the name of the leaderboad you are using, or the
	#id of it.
	Leaderboard.set_leaderboard(LeaderboardName)
	
	#When data is recieved, call the function "recieved_data"
	Leaderboard.recieved_data.connect(recieved_data)
	
	#Because we have the function "recived_data" setup to 
	#update the leaderboard if the data is a list of scores,
	#when you call this function it will update the 
	#leaderboard according to the scores.
	Leaderboard.get_scores()

func recieved_data(data):
	if "Scores" in data: #This means that it is a list of scores
		#Put the scores onto the leaderboard.
		$BaseLeaderboard.scores = data["Scores"]
	elif "Score id" in data: #This means it is returning a score's
		#id
		
		#Set the variable "idOfScore" to the id recieved.
		idOfScore = data["Score id"]


func _on_add_score_pressed() -> void:
	#This adds a score to the leaderboard with the name being one
	#of the line edits, and the score being the other.
	Leaderboard.add_score($Buttons/Name.text, $Buttons/Score.text)


func _on_edit_pressed() -> void:
	#This edits a score that we know the id of. It sets either the
	#score or the name, depending on what we put as the editing 
	#value. This will not edit the score if it is not in the set 
	#leaderboard.
	Leaderboard.edit_score($Buttons/EditId.text, $Buttons/Data.text,
		$Buttons/Editing.text)


func _on_delete_pressed() -> void:
	#Delete a score with the id given. Note: for security reasons,
	#if this score is not in the leaderboard set, it will not 
	#delete.
	Leaderboard.delete_score($Buttons/DeleteId.text)


func _on_set_pressed() -> void:
	#This will set the leaderboard we are using to the leaderboard
	#with the matching name or id. The id can be a int or string.
	Leaderboard.set_leaderboard($Buttons/SetName.text)


func _on_create_pressed() -> void:
	#Create a new leaderboard with the name given. This is mostly to
	#be used so you don't have to go to a website to create the new
	#leaderboard.
	Leaderboard.create_leaderboard($Buttons/CreateName.text, 
			$Buttons/Direction.text)


func _on_delete_board_pressed() -> void:
	#Delete leaderboard with the id given. Please be careful with 
	#this as this is permanent. This will delete the leaderboard and
	#all of it's scores. Please only delete leaderboards you 
	#created. I am not responsible for any lost data.
	Leaderboard.delete_leaderboard($Buttons/DeleteBoardId.text)


func _on_check_pressed() -> void:
	#This function checks if a leaderboard with the given id/name 
	#exists. This can be used to check before creating a 
	#leaderboard.
	$Buttons/Output.text = str(await Leaderboard.leaderboard_exists(
			$Buttons/BoardName.text))


func _on_update_pressed() -> void:
	#This will get all scores in the set leaderboard, and because 
	#the function connected to the signal 
	#"Leaderboard.recieved_data" is setup to put the scores onto 
	#the visible leaderboard, this will also update the leaderboard.
	Leaderboard.get_scores()
