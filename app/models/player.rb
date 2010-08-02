#Created by n_player_profile, no client access.

class Player < ActiveRecord::Base
  belongs_to :strategy
  belongs_to :n_player_profile
  has_many :n_player_payoffs
  has_many :n_player_adjusted_payoffs
  
  validates_presence_of :n_player_profile_id
  validates_presence_of :strategy_id
  validates_numericality_of :profile_index, :only_integer=>true
  
  alias_method :payoffs, :n_player_payoffs
  alias_method :adjusted_payoffs, :n_player_adjusted_payoffs
  
  #TODO- Why is this failing? 
  #validates_each :profile_index do |model, attr, val|
    #model.errors.add(attr, 'profile_index must be between 0 and (n_player_profile.size-1)') if 
      #(val < 0) or (val > (model.n_player_profile.size - 1))
  #end
  
  #sum up the average payoff over all n_player_payoffs associated with this player  
  def avg_payoff
      payoff = []
      n_player_payoffs.each do |p|
        payoff << p.payoff 
      end
      
      payoff.sum / payoff.length.to_f
  end

	#similar to avg_payoff but only uses adjusted payoffs
  def avg_adjusted_payoff
  	payoff = []
  	n_player_adjusted_payoffs.each do |p|
  		payoff << p.payoff
  	end

  	payoff.sum.to_f / payoff.length.to_f
  end
end
