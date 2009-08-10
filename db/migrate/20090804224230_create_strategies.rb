class CreateStrategies < ActiveRecord::Migration
  def self.up
    create_table :strategies do |t|
      t.string :name, :null=>false
      t.text :description
      t.integer :server_index, :null=>false

      t.timestamps
    end
    
    add_index :strategies, :server_index
  end

  def self.down
    remove_index :strategies, :server_index
    
    drop_table :strategies
  end
end
