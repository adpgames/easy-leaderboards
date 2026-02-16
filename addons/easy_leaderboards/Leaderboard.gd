extends Control
#Created by Asher Petersen for Godot.

signal recieved_data(data) #Signal for when data is recieved
var leaderboard = null #Variable for the set leaderboard

var error_message = "No leaderboard set. Use Leaderboard.set_leaderboard(NameOrId), replacing NameOrId with the name of the leaderboard or id of the leaderboard."


#Use this function to set the data of your leaderboard. The data
#can be the name or the id of the leaderboard, the id being either
#a integer or a string. Both work fine.
func set_leaderboard(data):
	if data is int or data is String:
		leaderboard = data
	else:
		printerr("Leaderboard data must be name of leaderboard or id of leaderboard")
		leaderboard = null


#Use this function to get all of the scores from the set 
#leaderboard. This returns a dictionary with the key "Score" 
#being a list of dictionaries, the dictionaries representing 
#the data of the score.
func get_scores():
	if leaderboard != null:
		var data = {
			"LeaderboardData" : leaderboard,
		}
		_request_data("https://themaker6.pythonanywhere.com/get-scores", data)
	else:
		printerr(error_message)


#This adds (submits) a new score to the leaderboard. Use this 
#when you want to add a score.
func add_score(Name, Score):
	if leaderboard != null:
		var data = {
			"Name" : Name,
			"Score" : Score,
			"LeaderboardData" : leaderboard,
		}
		_request_data("https://themaker6.pythonanywhere.com/new-score", data)
	else:
		printerr(error_message)


#This function edits the score with the id given, but only if it
#is in the set leaderboard. If it is not, it will not edit and
#return that it was not in the leaderboard. You can edit the data
#(being the score), and the name for the score. Set "editing" to
#"Name" to edit the name of the score.
func edit_score(id, data, editing = "Score"):
	if leaderboard != null:
		var body = {
			"ScoreId" : id,
			"Data" : data,
			"Editing" : editing,
			"LeaderboardData" : leaderboard,
		}
		_request_data("https://themaker6.pythonanywhere.com/edit-score", body)
	else:
		printerr(error_message)


#Delete the score with the given id. This will only delete 
#successfully if the score is in the set leaderboard.
func delete_score(id):
	if leaderboard != null:
		var data = {
			"ScoreId" : id,
			"LeaderboardData" : leaderboard,
		}
		_request_data("https://themaker6.pythonanywhere.com/delete-score", data)
	else:
		printerr(error_message)


#This checks if a leaderboard exists with the given name. This is
#used to check if the name is in use before creating a new 
#leaderboard with code. You need to call this with 
#await Leaderboard.leaderboard_exists(NameOfLeaderboard).
func leaderboard_exists(Name): #This is a special function
	var HTTP = HTTPRequest.new() #Create a new HTTPRequest node
	add_child(HTTP) #Add the node to the scene tree
	
	var body = {
		"LeaderboardData" : Name,
	}
	
	var new_body = JSON.stringify(body) #Turn the data into a string to send over
	var error = HTTP.request("https://themaker6.pythonanywhere.com/check-leaderboard", [], HTTPClient.METHOD_POST, new_body) #Request and check for errors
	
	if error != OK: #If an error occured,
		printerr("An error occurred in the HTTP request: ", error) #Tell the user that something happened.
	
	var data = await HTTP.request_completed
	
	HTTP.queue_free() #Delete the node
	
	var result = data[0]
	var response_code = data[1]
	var recieved_body = data[3]
	
	if result == HTTPRequest.RESULT_SUCCESS and response_code == 200:
		# Parse the response body (assuming it's JSON)
		var json = JSON.new()
		var json_result = json.parse(recieved_body.get_string_from_utf8())
		
		if json_result == OK:
			var recieved = json.data
			return recieved["Exists"]
		else:
			printerr("Failed to parse JSON: ", json_result.error_string)
			return
	else:
		printerr("HTTP request failed with code: ", response_code)
		return


#Create a new leaderboard with the name provided. This will do
#nothing if the name is in use. Set "direction" to the
#disired direction the scores will be sorted. This can be 
#"Ascending", "Descending" or "NoChange". For Ascending, the 
#scores will be sorted lowest to heighest, but for text, it will
#not be sorted. Descending will sort highest to lowest. NoChange 
#will not sort the scores, so they will be returned however they 
#were put in, which is technically sorted by when they were added.
func create_leaderboard(Name, direction = "Ascending"):
	var data = {
		"Name" : Name,
		"Direction" : direction,
	}
	
	_request_data("https://themaker6.pythonanywhere.com/new-leaderboard", data)


#Deletes specific leaderboard. Please be careful with this and
#do not delete anybody else's leaderboards, as I am not 
#responsible for any lost data. This will permanently delete
#the leaderboard and any scores associated with it. "data", as
#with everything else, can be the name of the leaderboard, or
#the id of the leaderboard.
func delete_leaderboard(data):
	var body = {
		"LeaderboardData" : data,
	}
	
	_request_data("https://themaker6.pythonanywhere.com/delete-leaderboard", body)


func _request_data(url: String, data):
	var HTTP = HTTPRequest.new() #Create a new HTTPRequest node
	add_child(HTTP) #Add the node to the scene tree
	HTTP.request_completed.connect(_request_completed) #Connect the signal so you know when it is completed.
	
	var body = JSON.stringify(data) #Turn the data into a string to send over
	var error = HTTP.request(url, [], HTTPClient.METHOD_POST, body) #Request and check for errors
	
	if error != OK: #If an error occured,
		printerr("An error occurred in the HTTP request: ", error) #Tell the user that something happened.
	
	await HTTP.request_completed
	HTTP.queue_free()


func _request_completed(result, response_code, _headers, body):
	# Check if the request was successful
	if result == HTTPRequest.RESULT_SUCCESS and response_code == 200:
		# Parse the response body (assuming it's JSON)
		var json = JSON.new()
		var json_result = json.parse(body.get_string_from_utf8())
		
		if json_result == OK:
			var data = json.data
			recieved_data.emit(data)
		else:
			printerr("Failed to parse JSON: ", json_result.error_string)
	else:
		printerr("HTTP request failed with code: ", response_code)
