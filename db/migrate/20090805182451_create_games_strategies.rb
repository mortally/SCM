class CreateGamesStrategies < ActiveRecord::Migration
  def self.up
    create_table :games_strategies, :id=>false do |t|
      t.references :strategy
      t.references :game
    end
    
    add_index :games_strategies, :strategy_id
    add_index :games_strategies, :game_id
  end

  def self.down
    remove_index :games_strategies, :strategy_id
    remove_index :games_strategies, :game_id
    
    drop_table :games_strategies
  end
end
