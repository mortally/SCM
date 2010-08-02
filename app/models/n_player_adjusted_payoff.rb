class NPlayerAdjustedPayoff < ActiveRecord::Base
  belongs_to :n_player_profile
  belongs_to :n_player_payoff
  belongs_to :sample
  belongs_to :player
  
  validates_presence_of :n_player_profile_id
  validates_presence_of :sample_id
  validates_presence_of :player_id
  validates_numericality_of :payoff
end
