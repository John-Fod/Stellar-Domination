require_relative "classes/captain"
require_relative "classes/ship"
require_relative "classes/state"




introduction = <<EOM
Welcome to Steller Domination, where you must pilot
your spacecraft to victory over the rebels controlling
a distant star.
EOM

#--------------------------
#Set up the AI and its ship
enemy = Captain.new
enemy.get_name("Dread Pirate Roberts")
enemy.get_skills([8,8,7,7])
enemy.get_ship("Battleship","Revenge")

#--------------------------------
#Set up the player and their ship
player = Captain.new
player.get_name("Blackthorne")
player.get_skills([8,8,7,7])
player.get_ship("Cruiser","Erasmus")

#-----------------------
#Set up the current game
cur_game = State.new(player, enemy)

while !cur_game.game_over
	cur_game.get_command
end
