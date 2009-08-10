class Strategy < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  validates_presence_of :server_index
  validates_numericality_of :server_index, :only_integer=>true
  validates_uniqueness_of :server_index
end
