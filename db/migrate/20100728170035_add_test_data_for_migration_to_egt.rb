class AddTestDataForMigrationToEgt < ActiveRecord::Migration
  def self.up
  	# Create Server
  	s = Server.new
  	s.name = "Server_1"
  	s.description = "The Server!"
  	s.version = "99.9"
  	s.server_index = 1
  	s.save!
  
  	# Create Strategies
  	for i in 1..6
  		s = Strategy.new
  		s.name = "Strategy_#{i}"
  		s.description = "temp"
  		s.server_index = i
  		s.save!
  	end
  	
  	# Create ThreePlayerProfiles
  	count = 0
  	for i in 1..10
  		t = ThreePlayerProfile.new
  		t.server_id = 1
  		t.strategy_one_id = rand(6) + 1
  		t.strategy_two_id = rand(6) + 1
  		t.strategy_three_id = rand(6) + 1
  		if t.save
  			count += 1
  		end
  	end
  	
  	# Create Sample & Simulations
  	for i in 1..20
  		sample = Sample.new
  		simul = Simulation.new
  		
			simul.account_id = 1
			simul.profile_id = rand(count) + 1
			simul.size = 1
			simul.state = "Completed"
			simul.job = (rand * 1000000).to_i.to_s
			simul.completed_at = Time.now
			simul.save!
			
			sample.size = (rand * 10000000).to_i
			sample.content_type = "application/gzip"
			sample.filename = "Sample_#{i}"
			sample.simulation_id = i
			sample.profile_id = simul.profile_id
			sample.clean = true
			sample.save!
  	end
  	
  	# Create ThreePlayerPayoffs
  	for i in 1..20
  		p = ThreePlayerPayoff.new
  		s = Sample.find(i)
#  		p.three_player_profile_id = rand(count)+1
			p.three_player_profile_id = s.profile_id
  		p.strategy_one_payoff = rand * 100000
  		p.strategy_two_payoff = rand * 100000
  		p.strategy_three_payoff = rand * 100000
  		p.sample_id = s.id
  		p.adjusted = false
  		p.save
  	end
  end

  def self.down
  end
end
