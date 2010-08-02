class MigrateToEgt < ActiveRecord::Migration
  def self.up
  	# Modification to the existing table
  	add_column :games, :size, :integer, :null => false
  	
  	# Create new tables
  	create_table :features do |t|
      t.string :name

      t.timestamps
    end
    
    create_table :feature_samples do |t|
      t.references :feature
      t.references :sample
      t.float :value

      t.timestamps
    end
    
    create_table :n_player_payoffs do |t|
      t.references :n_player_profile
      t.references :sample
      t.integer :player_id
      t.float :payoff, :null=>false, :default=>0.0
      t.boolean :adjusted, :default=>false

      t.timestamps
    end  	
    
    create_table :n_player_profiles do |t|
      t.integer :size, :null=>false
      t.references :server
      t.string :profile_hash
      
      t.timestamps 
    end

    create_table :n_player_adjusted_payoffs do |t|
      t.references :n_player_profile
      t.references :sample
      t.references :n_player_payoff
      t.integer :player_id, :null=>false
      t.float :payoff, :null=>false, :default=>0.0

      t.timestamps
    end
    
    create_table :players do |t|
      t.references :strategy
      t.references :n_player_profile
      t.integer :profile_index, :null=>false

      t.timestamps
    end
    
    create_table :profile_schedulers do |t|
      t.references :n_player_profile
      t.boolean :active, :null=>false, :default=>false
      t.integer :min_samples_per_profile, :null=>false, :default=>0
      t.timestamps
    end
    
    add_index :profile_schedulers, :n_player_profile_id 
    
    
##### Data migration #####
    
    # Every game in TAC/SCM has size of 3
    games = Game.all
    games.each do |game|
    	game.write_attribute(:size, 3)
    end
    
    map = []
    syms = ["strategy_one","strategy_two","strategy_three"]
    profiles = ThreePlayerProfile.all
    profiles.each do |profile|
    	
    	hash = []
    	hash << profile.strategy_one_id
    	hash << profile.strategy_two_id
    	hash << profile.strategy_three_id
    	np = NPlayerProfile.find_by_profile_hash_and_server_id(hash.join(",").to_s, profile.server_id)
    	
    	# profile_hash is unique in the scope of server_id
    	unless np
    		new_np = NPlayerProfile.new
    		new_np.size = 3
    		new_np.server_id = profile.server_id
    		p = []
    		    		
    		# Create players for the profile
    		for i in 0..2
    			p[i] = Player.new
    			sym = "#{syms[i]}_id".to_sym
    			p[i].strategy_id = profile.read_attribute(sym)
    			new_np.players << p[i]
    		end
    		
    		# Initialize players in NPlayerProfile
    		new_np.initialize_players
    		for i in 0..2
    			p[i].save!
    		end
    		new_np.save!
    		map[profile.id] = new_np.id		
    	end
    	
    end
    
    payoffs = ThreePlayerPayoff.all
    payoffs.each do |payoff|
#    	npp = NPlayerPayoff.new # Needs three NPPayoffs for one TPP
    	tpp_id = payoff.three_player_profile_id
    	np_id = map[tpp_id] # This should not be nil.
    	tpp = ThreePlayerProfile.find(tpp_id)
    	
#    	st_ids = []
    	for i in 0..2
    		id_sym = "#{syms[i]}_id".to_sym
    		payoff_sym = "#{syms[i]}_payoff".to_sym
    		st_id = tpp.read_attribute(id_sym)
    		
    		p = Player.find_by_n_player_profile_id_and_strategy_id_and_profile_index(np_id, st_id, i)
    		
    		npp = NPlayerPayoff.new
    		npp.n_player_profile_id = np_id
    		npp.sample_id = payoff.sample_id
  		  npp.payoff = payoff.read_attribute(payoff_sym)
  		  npp.player = p
  		  npp.adjusted = false
  		  npp.save! 		
    	end
    end
    
    # Clean up obsolete tables
    drop_table :three_player_adjusted_payoffs
    drop_table :three_player_payoffs
    drop_table :three_player_games_three_player_profiles
    drop_table :three_player_profiles
  end

  def self.down
  end
end
