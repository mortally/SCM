class CreateSamples < ActiveRecord::Migration
  def self.up
    create_table :samples do |t|
      t.integer :size
      t.string :content_type
      t.string :filename
      t.references :simulation
      t.references :profile
      t.boolean :clean

      t.timestamps
    end
  end

  def self.down
    drop_table :samples
  end
end

