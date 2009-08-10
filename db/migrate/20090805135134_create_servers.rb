class CreateServers < ActiveRecord::Migration
  def self.up
    create_table :servers do |t|
      t.string :name, :null=>false
      t.text :description
      t.string :version, :null=>false

      t.timestamps
    end
  end

  def self.down
    drop_table :servers
  end
end
