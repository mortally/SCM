class CreateSimulations < ActiveRecord::Migration
  def self.up
    create_table :simulations do |t|
      t.references :account
      t.references :profile
      t.integer :size, :null=>false, :default=>1
      t.string :state
      t.string :job
      t.datetime :completed_at

      t.timestamps
    end
  end

  def self.down
    drop_table :simulations
  end
end
