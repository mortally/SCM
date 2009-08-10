class AddIndicesForProfileOptimization < ActiveRecord::Migration
  def self.up
    add_index :three_player_payoffs, :three_player_profile_id
    add_index :three_player_payoffs, :sample_id
    add_index :game_schedulers, :active
    add_index :samples, :profile_id
    add_index :samples, :simulation_id
    add_index :simulations, :profile_id
  end

  def self.down
    remove_index :three_player_payoffs, :three_player_profile_id
    remove_index :three_player_payoffs, :sample_id
    remove_index :game_schedulers, :active
    remove_index :samples, :profile_id
    remove_index :samples, :simulation_id
    remove_index :simulations, :profile_id
  end
end