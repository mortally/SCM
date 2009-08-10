class Server < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  validates_presence_of :version
  validates_uniqueness_of :version
  
  validates_presence_of :server_index
  validates_uniqueness_of :server_index
end
