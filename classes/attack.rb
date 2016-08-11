require_relative "ship"

class Attack
	#Define the instance variables and make setters and getters
	attr_accessor :origin, :target, :lifespan, :stats, :name, :energy_cost, :damage, :heal

	def self.subclasses
		ObjectSpace.each_object(Class).select { |klass| klass < self }
	end

	def initialize(origin, target)
		self.origin = origin
		self.target = target
		self.lifespan = self.class.stats['duration']
		self.damage = self.class.stats['damage']
		self.energy_cost = self.class.stats['energy_cost']
		self.heal = self.class.stats['heal']
		self.name = self.class.stats['name']
	end

	def drain_energy
		self.origin.energy = self.origin.energy - self.energy_cost
	end

	def fire_cannon(accuracy_boost = 0, damage_boost = 0)
		accuracy = self.origin.class.stats['cannon_accuracy'] * (1 + accuracy_boost)
		hit_roll = 1 + rand(100)
		if hit_roll <= accuracy
			damage_done = self.target.take_damage(self.origin.class.stats['cannon_damage'])
			self.damage = self.damage + damage_done
		end

	end


end


class Broadside < Attack

	@@stats = {
		"name" => "Broadside",
		"damage" => 0,
		"heal" => 0,
		"energy_cost" => 50,
		"description" => "Fire all cannons the exact moment you come side to side with your enemy.",
		"delay" => 500,
		"duration" => 1
	}

	def self.stats
		@@stats
	end

	def perform
		self.drain_energy

		#----Make the attack
		if self.target.sheild_integrity > 0
			self.target.sheild_integrity = self.target.sheild_integrity - self.damage
			puts "#{self.origin.name} hits the shields of #{self.target.name} for #{self.damage} damage."
		else
			self.target.hull_integrity = self.target.hull_integrity - self.damage
			puts "#{self.origin.name} hits the hull of #{self.target.name} for #{self.damage} damage."
		end

		self.lifespan = self.lifespan - 1

	end

end


#CANNON VOLLEY
#----  This attack simply fires every cannon
#----on the ship at the enemy with no damage
#----or accuracy boost.
class CannonVolley < Attack

	@@stats = {
		"name" => "Cannon Volley",
		"damage" => 0,
		"heal" => 0,
		"energy_cost" => 30,
		"description" => "Fire a volley at your enemy as you approach.",
		"delay" => 1000,
		"duration" => 1
	}

	def self.stats
		@@stats
	end


	def perform
		self.drain_energy

		#----Make the attack
		i = 0
		while i < self.origin.class.stats['cannon_count']
			self.fire_cannon
			i = i + 1
		end

		self.lifespan = self.lifespan - 1
	end

end