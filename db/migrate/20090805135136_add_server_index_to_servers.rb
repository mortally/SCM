class AddServerIndexToServers < ActiveRecord::Migration
  def self.up
    change_table :servers do |t|
      t.string :server_index, :null=>true # false originally
    end
  end

  def self.down
    change_table :servers do |t|
      t.string :server_index, :null=>false
    end
  end
end
