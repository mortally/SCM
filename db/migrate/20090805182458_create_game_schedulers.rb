class CreateGameSchedulers < ActiveRecord::Migration
  def self.up
    create_table :game_schedulers do |t|
      t.references :game
      t.boolean :active, :null=>false, :default=>false
      t.integer :min_samples_per_profile, :null=>false, :default=>0

      t.timestamps
    end
    
    add_index :game_schedulers, :game_id
  end

  def self.down
    remove_index :game_schedulers, :game_id
    
    drop_table :game_schedulers
  end
end
