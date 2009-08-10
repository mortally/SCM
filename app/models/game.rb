class Game < ActiveRecord::Base
  belongs_to :server
  
  has_and_belongs_to_many :strategies
  has_many :game_schedulers
  
end
