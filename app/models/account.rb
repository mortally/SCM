class Account < ActiveRecord::Base
  validates_presence_of     :username, :host  
  
  has_many :simulations
  
  def schedulable?
    max_concurrent_simulations>simulations.scheduled.count
  end
end
