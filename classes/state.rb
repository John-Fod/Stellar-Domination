require_relative "ship"
require_relative "captain"

=begin
****************************************************************
  This class keeps track of the state of the game.
****************************************************************
=end

class State
	attr_accessor :turn_number, :player, :ai, :game_over

	@@pending_actions = []

	@@approach_moves = []
	@@pass_moves = []
	@@parting_moves = []

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
		#-- Get the attack that is to be made
		while next_attack == nil
			puts "FIRST MATE: How shall we attack ".ljust(30, "-")
			puts "*To cancel attack, give the command 'back'"
			self.player.ship.show_attacks
			command = gets.chomp
			if command == "back"
				return
			else
				next_attack = create_attack(self.player.ship, self.ai.ship, command)
			end
		end
		queue_action(next_attack, @@pending_actions)
	end

	#------------------
	#Turn
	def turn
		system('cls')
		puts "---------------------------------------------\n"
		puts "As your ships approach each other in orbit..."

		#-----Do the attacks
		@@pending_actions.each do |action|
			if action.lifespan > 0
				#Give a message for the action you are doing
				puts "#{action.origin.name} performs a #{action.name.downcase} on #{action.target.name}."
				action.perform
				puts "#{'damage'.ljust(12)}|#{'healing'.ljust(12)}"
				puts "#{action.damage.to_s.ljust(12)}|#{action.heal.to_s.ljust(12)}"
			end
		end

		self.ships

	end


	#----------------------------------------------------------------
	#Queue Action
	#--DESCRIPTION: This adds an action to the array of actions 
	#--  to perform this turn
	#--INPUT:
	#--  action: The action to perform, can be [Attack, Heal]
	#--  action_queue: The array to store the action in [array]
	def queue_action(action, action_queue)
		action_queue.push(action)
		action.origin.energy = action.origin.energy - action.class.stats['energy_cost']
	end


	#----------------------------------------------------------------
	#CREATE ATTACK
	#--DESCRIPTION: This creates an [Attack, Heal] object if
	#--  the ship is capable of such an action and if the ship
	#--  has enough resources [energy] to do so
	#--INPUT:
	#--  origin: The origin of the action [ship]
	#--  target: The target of the action [ship]
	#--  attack_type: The name of the action to take [string]
	def create_attack(origin, target, attack_type)
		if origin.class.available_attacks.include? attack_type
			if origin.energy >= Object.const_get("#{attack_type.delete(' ')}").stats['energy_cost']
				next_attack = Object.const_get("#{attack_type.delete(' ')}").new(origin, target)
				puts "FIRST MATE: Roger that captain, preparing #{attack_type}"
				return next_attack
			else
				puts "FIRST MATE: Sorry captain, we do not have enough energy for a #{attack_type}"
				return nil
			end
		else
			puts "FIRST MATE: Sorry captain, this ship is not capable of that type of attack."
			return nil
		end
	end

end