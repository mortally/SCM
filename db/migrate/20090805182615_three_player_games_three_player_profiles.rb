class ThreePlayerGamesThreePlayerProfiles < ActiveRecord::Migration
  def self.up
    create_table :three_player_games_three_player_profiles, :id=>false do |t|
      t.references :three_player_game
      t.references :three_player_profile
    end
    
    add_index :three_player_games_three_player_profiles, :three_player_game_id, :name=> :three_players_game_id
    add_index :three_player_games_three_player_profiles, :three_player_profile_id, :name=> :three_players_profile_id
  end

  def self.down
    remove_index :three_player_games_three_player_profiles, :name=>:three_players_game_id
    remove_index :three_player_games_three_player_profiles, :name=>:three_players_profile_id
    
    drop_table :three_player_games_three_player_profiles
  end
end