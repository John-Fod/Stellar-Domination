=begin
***************************************************

***************************************************
=end

class Ship
	attr_accessor :captain, :name, :hull_integrity_max, :hull_integrity, :sheild_integrity_max, :sheild_integrity, :energy_max, :energy


	def self.subclasses
		ObjectSpace.each_object(Class).select { |klass| klass < self }
	end

	def get_name
		puts "FIRST MATE: What is the name of this ship?"
		self.name = gets.to_s.chomp
	end

	def report_status
		puts "#{self.name} Status Report"
		puts "#{"Captain".ljust(17)} : #{self.captain.name}"
		puts "#{"Energy".ljust(17)} : #{self.energy}/#{self.energy_max}"
		puts "#{"Hull Integrity".ljust(17)} : #{self.hull_integrity}/#{self.hull_integrity_max}"
		puts "#{"Sheild Integrity".ljust(17)} : #{self.sheild_integrity}/#{self.sheild_integrity_max}"
	end

	def show_attacks
		puts "-----#{'name'.ljust(16, '-')}|#{'damage'.ljust(16, '-')}|#{'energy cost'.ljust(16, '-')}"
		Attack.subclasses.each do |attack|
			if self.class.available_attacks.include? attack.stats['name']
				puts "#{attack.stats['name'].ljust(21)}|#{attack.stats['damage'].to_s.ljust(16)}|#{attack.stats['energy'].to_s.ljust(16)}"
			end
		end
	end

	def queue_move move_queue_array

	end

	def take_damage(attack_damage = 0)
		if(self.sheild_integrity > 0)
			self.sheild_integrity = self.sheild_integrity - attack_damage
		else
			self.hull_integrity = self.hull_integrity - attack_damage
		end

		return attack_damage
	end

end




class Battleship < Ship

	@@stats = {
		"cannon_count" => 200,
		"cannon_accuracy" => 70,
		"cannon_damage" => 29
	}
	def self.stats
		@@stats
	end

	@@available_attacks = [
		"Cannon Volley",
		"Broadside"
	]
	def self.available_attacks
		@@available_attacks
	end

	def initialize
		self.hull_integrity_max = 10000
		self.sheild_integrity_max = 10000
		self.energy_max = 100
		self.hull_integrity = self.hull_integrity_max
		self.sheild_integrity = self.sheild_integrity_max
		self.energy = self.energy_max
	end

end




class Cruiser < Ship

	@@stats = {
		"cannon_count" => 100,
		"cannon_accuracy" => 85,
		"cannon_damage" => 25
	}
	def self.stats
		@@stats
	end

	@@available_attacks = [
		"Cannon Volley",
		"Broadside"
	]
	def self.available_attacks
		@@available_attacks
	end

	def initialize
		self.hull_integrity_max = 5000
		self.sheild_integrity_max = 5000
		self.energy_max = 200
		self.hull_integrity = self.hull_integrity_max
		self.sheild_integrity = self.sheild_integrity_max
		self.energy = self.energy_max/2
	end

end