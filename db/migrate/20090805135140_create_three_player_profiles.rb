class CreateThreePlayerProfiles < ActiveRecord::Migration
  def self.up
    create_table :three_player_profiles do |t|
      t.references :server
      t.references :strategy_one
      t.references :strategy_two
      t.references :strategy_three

      t.timestamps
    end
  end

  def self.down
    drop_table :three_player_profiles
  end
end
