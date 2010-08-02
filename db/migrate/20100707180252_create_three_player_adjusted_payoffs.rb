class CreateThreePlayerAdjustedPayoffs < ActiveRecord::Migration
  def self.up
    create_table :three_player_adjusted_payoffs do |t|
      t.references :sample
      t.float :strategy_one_payoff, :null=>false, :default=>0.0
      t.float :strategy_two_payoff, :null=>false, :default=>0.0
      t.float :strategy_three_payoff, :null=>false, :default=>0.0
      t.references :three_player_profile

      t.timestamps
    end
    add_column :three_player_payoffs, :adjusted, :boolean
  end

  def self.down
    drop_table :three_player_adjusted_payoffs
  end
end
