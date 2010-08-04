class Game < ActiveRecord::Base
  belongs_to :server
  
  has_and_belongs_to_many :strategies
  has_and_belongs_to_many :n_player_profiles
  has_many :game_schedulers
  
end
