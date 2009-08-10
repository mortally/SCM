class CreateThreePlayerPayoffs < ActiveRecord::Migration
  def self.up
    create_table :three_player_payoffs do |t|
      t.references :three_player_profile
      t.float :strategy_one_payoff, :null=>false, :default=>0.0
      t.float :strategy_two_payoff, :null=>false, :default=>0.0
      t.float :strategy_three_payoff, :null=>false, :default=>0.0
      t.references :sample

      t.timestamps
    end
  end

  def self.down
    drop_table :three_player_payoffs
  end
end

