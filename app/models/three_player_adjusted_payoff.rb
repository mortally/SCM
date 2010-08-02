class ThreePlayerAdjustedPayoff < ActiveRecord::Base
	belongs_to :three_player_profile
  belongs_to :sample
  
  validates_numericality_of :strategy_one_payoff
  validates_numericality_of :strategy_two_payoff
  validates_numericality_of :strategy_three_payoff
  
  validates_presence_of :sample_id
  validates_uniqueness_of :sample_id
  
  validates_presence_of :three_player_profile_id
  
  def payoff_to_player(player)
    send "strategy_#{player}_payoff"
  end
  
  def payoff_to_strategy(strategy)
    payoffs = []
    
    ThreePlayerProfile::PLAYERS.each do |player|
      payoffs << payoff_to_player(player) if three_player_profile.send("strategy_#{player}_id")==strategy.id
    end
    
    payoffs.sum / payoffs.length.to_f
  end
end
