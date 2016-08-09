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
		puts "Captain          : #{self.captain.name}"
		puts "Energy           : #{self.energy}/#{self.energy_max}"
		puts "Hull Integrity   : #{self.hull_integrity}/#{self.hull_integrity_max}"
		puts "Sheild Integrity : #{self.sheild_integrity}/#{self.sheild_integrity_max}"
	end

end

class Battleship < Ship

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

	def initialize
		self.hull_integrity_max = 5000
		self.sheild_integrity_max = 5000
		self.energy_max = 200
		self.hull_integrity = self.hull_integrity_max
		self.sheild_integrity = self.sheild_integrity_max
		self.energy = self.energy_max/2
	end

end