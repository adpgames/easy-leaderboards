extends Control
#Created by Asher Petersen for Godot.
#This script and the scene "leaderboardTemplate" is essentially the same thing as the
#node BaseLeaderboard. This is for if you wanted to change anything about the node, and
#this is just the same stuff.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Leaderboard.set_leaderboard("Demo") #Set the leaderboard to "Demo"
	Leaderboard.get_scores() #Get the scores
	Leaderboard.recieved_data.connect(recieved_data)

func recieved_data(data):
	#Delete all scores so they don't get duplicated
	for score in $Leaderboard/ScrollContainer/VBoxContainer.get_children():
		if score.name != "Space":
			score.queue_free()
	
	var scores = data.Scores
	
	var i = 1 #Create a index variable
	for score in scores: #Loop through all of the data
		var new_score = $Leaderboard/Score.duplicate() #Create a new row for a score 
		$Leaderboard/ScrollContainer/VBoxContainer.add_child(new_score) #Add the new row to the visible leaderboard 
		new_score.visible = true #Make it visible (It starts invisible by default)
		new_score.get_child(0).text = str(i) #Update the placement
		new_score.get_child(1).text = score.Name #Update the name for the score
		new_score.get_child(2).text = str(score.Score) #Update the score for the score
		new_score.get_child(3).text = str(score.id) #Show the id for the score
		i += 1 #Update the index variable
