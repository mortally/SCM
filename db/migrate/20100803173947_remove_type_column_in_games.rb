class RemoveTypeColumnInGames < ActiveRecord::Migration
  def self.up
  	remove_column :games, :type
  end

  def self.down
  end
end
