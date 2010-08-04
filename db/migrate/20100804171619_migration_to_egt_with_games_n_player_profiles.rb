class MigrationToEgtWithGamesNPlayerProfiles < ActiveRecord::Migration
  def self.up
  	# Migration for Games_N_Player_Profiles
    ThreePlayerGame.all.each do |game|
    	tp_profiles = game.three_player_profiles
    	
    	tp_profiles.each do |tpp|
    		np_id = map[tpp.id]
    		game.n_player_profiles << NPlayerProfile.find(np_id)
    	end
    	game.save!
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
