require_relative "ship"
require_relative "captain"

class State
	attr_accessor :turn_number, :player, :ai, :game_over

	@@commands_list = {
		"commands" => "Gives you a list of possible commands",
		"quit" => "Quit the current game.",
		"ships" => "See the status of the ships",
		"captains" => "See the details about your captain."
	}
	
	def self.commands_list
		@@commands_list
	end

	def initialize(player, ai)
		self.player = player
		self.ai = ai
		self.turn_number = 0
		self.game_over = false
	end

	def get_command
		printf "FIRST MATE: What's your order captain?\n:"
		new_command = gets.chomp
		if self.class.commands_list.has_key?(new_command)
			self.send(new_command)
		else
			puts "Sorry, that command could not be understood."
			puts "To see the commands list, type 'commands'"
		end
	end

	#----------------------
	#Show the commands list
	def commands
		self.class.commands_list.each do |name, description|
			printf "#{name.ljust(10)} : #{description}\n"
		end
	end

	#------------
	#End the game
	def quit
		puts "Game Over"
		self.game_over = true
	end

	#----------------------------
	#Show the status of the ships
	def ships
		puts "\n-- Your Ship ".ljust(30,"-")
		self.player.ship.report_status
		puts "\n-- Enemy Ship ".ljust(30,"-")
		self.ai.ship.report_status
		puts
	end

	#-----------------------
	#Show player information
	def captains
		puts "\n-- Your Captain ".ljust(30,"-")
		self.player.show_skills
		puts "\n-- Enemy Captain ".ljust(30,"-")
		self.ai.show_skills
		puts
	end

end