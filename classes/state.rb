require_relative "ship"
require_relative "captain"

=begin
****************************************************************
  This class keeps track of the state of the game.
****************************************************************
=end

class State
	attr_accessor :turn_number, :player, :ai, :game_over

	@@pending_attacks = []
	@@pending_heals = []
	@@pending_status_effects = []

	@@commands_list = {
		"commands" => "Gives you a list of possible commands",
		"quit" => "Quit the current game.",
		"ships" => "See the status of the ships",
		"captains" => "See the details about your captain.",
		"attack" => "Attack the enemy ship.",
		"turn" => "Advances the turn, commencing all attacks."
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

	#-------------
	#Attack
	def attack
		next_attack = nil
		while next_attack == nil
			puts "FIRST MATE: How shall we attack ".ljust(30, "-")
			self.player.ship.show_attacks
			attack_type = gets.chomp
			if self.player.ship.class.available_attacks.include? attack_type
				next_attack = Object.const_get("#{attack_type.delete(' ')}").new(self.player.ship, self.ai.ship)
				@@pending_attacks.push(next_attack)
				puts "FIRST MATE: Roger that captain, preparing #{next_attack.class.stats['name']} attack."
			else
				puts "FIRST MATE: Sorry captain, this ship is not capable of that type of attack."
			end
		end
	end

	#------------------
	#Turn
	def turn
		system('cls')
		puts "---------------------------------------------\n"
		puts "As your ships approach each other in orbit..."

		#-----Do the status effects
		@@pending_status_effects.each do |effect|

		end

		#-----Do the heals
		@@pending_heals.each do |heal|

		end

		#-----Do the attacks
		@@pending_attacks.each do |attack|
			if attack.lifespan > 0
				#Give a message for the attack you are doing
				puts "#{attack.origin.name} attacks #{attack.target.name} with a #{attack.name.downcase}."
				attack.perform
				puts "#{'damage'.ljust(12)}|#{'healing'.ljust(12)}"
				puts "#{attack.damage.to_s.ljust(12)}|#{attack.heal.to_s.ljust(12)}"
			end
		end

		self.ships

	end

end