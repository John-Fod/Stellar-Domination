require_relative "ship"

class Captain
	#Define the instance variables and make setters and getters
	attr_accessor :name, :ship, :skills, :skill_points

	#The number of skill points each captain starts with
	@@starting_skill_points = 30
	def self.starting_skill_points
		@@starting_skill_points
	end

	#The maximum number of points each skill can have
	@@max_skill_points = 10
	def self.max_skill_points
		@@max_skill_points
	end

	def initialize
		
		#Set the captain's ship to nil
		self.ship = nil

		#Set each skill to 0
		self.skills = {
			"gunnery" => 0,
			"evasion" => 0,
			"repair" => 0,
			"intelligence" => 0
		}
		
		#Set the number of skill points the captain has
		self.skill_points = Captain.starting_skill_points

	end

	def get_name(captain_name=nil)
		unless captain_name
			print "FIRST MATE: What is your name, Captain? "
			self.name = gets.to_s.chomp()
			puts "FIRST MATE: Glad to have you on board Captain " + self.name + "!"
		else
			self.name = captain_name
		end
	end

	def get_skills(skill_values_array=nil)
		unless skill_values_array
			printf "FIRST MATE: Captain #{self.name}, what is your skillset?\n"
			printf "-- Each skill can have a maximum value of #{Captain.max_skill_points}\n"
			printf "-- Each skill must have at least one point\n"
			printf "--\n"
			self.skills.each do |skill_name, skill_value|
				get_skill(skill_name)
			end
			printf "-- Skill allocation complete, here are the results.\n"
			self.show_skills
		else
			self.skills.each.with_index do |(skill_name, skill_value), index|
				self.skills[skill_name] = skill_values_array[index]
			end
		end
	end

	#Get Ship
	#The user is prompted about the type of ship they want to pilot
	#The user then names their ship and is given a rundown of it
	def get_ship(ship_class_arg = nil, ship_name_arg=nil)
		unless ship_class_arg && ship_name_arg
			printf "FIRST MATE: Captain #{self.name}, what kind of ship is this?\n"
			while self.ship == nil
				printf "-- Please choose a class of ship from the following options.\n"
				puts "|  " + Ship.subclasses.join('  |  ') + "  |"
				ship_class = gets.chomp
				#Ruby will throw a NameError if we try to call const_get on a bad string
				begin
					#We still need to check that the name is indeed a type of ship
					if Ship.subclasses.include? Object.const_get(ship_class)
						self.ship = Object.const_get(ship_class).new
						self.ship.captain = self
					else
						puts "-- Sorry, that class of ship was not found."
					end
				rescue NameError
					puts "-- Sorry, that class of ship was not found."
				end
			end
			#Get the name of the ship
			self.ship.get_name
			self.ship.report_status
		else
			self.ship = Object.const_get(ship_class_arg).new
			self.ship.captain = self
			self.ship.name = ship_name_arg
		end
	end





	def get_skill(skill_name)
		while self.skills[skill_name] == 0
			printf "-- You have #{self.skill_points} left\n"
			printf "-- How many skill points do you want to spend on #{skill_name}? "
			skill_value = gets.chomp.to_i

			#Make sure the skill is a number
			unless skill_value.is_a? Integer
				printf "-- You must enter an integer between 1 and #{Captain.max_skill_points}.\n"
				next
			end
			#Make sure the skill isn't too high
			if skill_value > Captain.max_skill_points
				printf "-- You can allocate a maximum of #{Captain.max_skill_points} to each skill.\n"
				next
			end
			#Make sure the skill isn't too low
			if skill_value < 1
				printf "-- You must enter an integer between 1 and #{Captain.max_skill_points}.\n"
				next
			end
			#Make sure that there are enough skill points to allocate
			if skill_value > self.skill_points
				printf "-- You only have #{self.skill_points} to allocate.\n"
				next
			end

			self.skill_points = self.skill_points - skill_value
			self.skills[skill_name] = skill_value
		end
	end

	def show_skills
		self.skills.each do |skill_name, skill_value|
			puts skill_name.ljust(12) + " : " + skill_value.to_s
		end
	end


end