class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.references :server
      t.string :name
      t.text :description
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
