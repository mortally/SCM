class AddMaxConcurrentSimulationsToAccounts < ActiveRecord::Migration
  def self.up
    change_table :accounts do |t|
      t.integer :max_concurrent_simulations, :null=>false, :default=>0
    end
  end

  def self.down
    change_table :accounts do |t|
      t.remove :max_concurrent_simulations
    end
  end
end
