# Easy Leaderboards
A great and easy way to make leaderboards in any Godot game. Just add it to the game and use the simple built-in functions to create your leaderboard and add scores to it effortlessly, within a few seconds.

# Discription
EasyLeaderboards allows you to effortlessly create leaderboards, add scores to those leaderboards, has a built-in BaseLeaderboard node, and is completely free for as many leaderboards as you'd like!
With the included functions, you can add, edit, or delete scores, get all of the scores in a leaderboard, create new leaderboards, delete leaderboards, and check if a leaderboard exists. 
With the custom node, you just add it to the scene and set scores when you receive them. The BaseLeaderboard node is customizable to have different themes, colors, headers, and max scores to display.


# How to use:
There is a demo scene in the files, but here is how you do it yourself:

To get started download the asset and enable it, then go to either adpgames.com/leaderboards or themaker6.pythonanywhere.com/leaderboards and create your first leaderboard, or run Leaderboard.create_leaderboard(nameOfLeaderboard) replacing "nameOfLeaderboard" with the name as a string. There is a optional parameter for this function: "direction". 
"direction" can be "Ascending" "Descending" or "NoChange" where ascending sorts the scores lowest to highest, but no sorting will be done for string values. Descending sorts the opposite of ascending. "NoChange" will not change the order, so it is whatever order you put the scores in.

You might want to check if there is already a leaderboard with that name already, and you can do that by adding an if statement before creating a leaderboard that says, "if not await Leaderboard.leaderboard_exists(nameOfLeaderboard):", still replacing "nameOfLeaderboard" with the desired name of your leaderboard.

Then, to tell the script that you want to connect with a leaderboard, call Leaderboard.set_leaderboard(DataOfLeaderboard) in your "_ready()" function and replace "DataOfLeaderboard" with either the id or name of your leaderboard.

You're all set up! Now, whenever you want to add a new score, you can just call Leaderboard.add_score(name, score) replacing the values with what you need.

Whenever you'd like to get scores from a leaderboard, make sure a leaderboard is set, and a function is connected to "Leaderboard.recieved_data". Then call Leaderboard.get_scores(), and in the function connected to the signal "recieved_data", set the scores value of the BaseLeaderboard node to the variable "data" that was sent in the signal.

And that's it! There are more functions and comments on how to use them in the addon as well.
