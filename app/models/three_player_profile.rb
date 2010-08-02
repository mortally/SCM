class ThreePlayerProfile < ActiveRecord::Base
  PLAYERS = [:one, :two, :three]
  
  belongs_to :server
  belongs_to :strategy_one, :class_name => "Strategy"
  belongs_to :strategy_two, :class_name => "Strategy"
  belongs_to :strategy_three, :class_name => "Strategy"
  
  validates_numericality_of :strategy_one_id, :only_integer=>true
  validates_numericality_of :strategy_two_id, :only_integer=>true
  validates_numericality_of :strategy_three_id, :only_integer=>true
  
  validates_uniqueness_of :server_id, :scope => [:strategy_one_id, 
                                                 :strategy_two_id, 
                                                 :strategy_three_id]
  before_save :sort_strategies
  
  has_many :samples, :foreign_key=>"profile_id"
  has_many :simulations, :foreign_key=>"profile_id"
  has_many :three_player_payoffs
  has_many :three_player_adjusted_payoffs
  
  has_many :game_schedulers, :foreign_key=>"profile_id"
  
  named_scope :random, :order=>'RAND()'
  
  def three_player_profile
    self
  end
  
  def strategy(player)
    send "strategy_#{player}"
  end
  
  def name
    @name ||= create_name
  end
  
  def strategies
    @strategies = []
    PLAYERS.each do |player|
      @strategies << strategy(player)
    end
    @strategies
  end
  
  def strategies=(s)
    s = s.collect {|i| i.to_i}
    s.sort!
    
    for i in 0..(s.length-1)
      sym = "strategy_#{PLAYERS[i]}_id".to_sym
      write_attribute(sym, s[i])
    end
  end
  
  def strategy_count(s)
    strategies.inject(0) {|sum,strategy| strategy.id==s.id ? sum+1 : sum }
  end
  
  def payoff(strategy)
    payoffs = []
    
    three_player_payoffs.each do |payoff|
      payoffs << payoff.payoff_to_strategy(strategy)
    end
          
    payoffs.sum / payoffs.length.to_f
  end

	def adjusted_payoff(strategy)
    adjusted_payoffs = []
    
    three_player_adjusted_payoffs.each do |payoff|
      adjusted_payoffs << payoff.payoff_to_strategy(strategy)
    end
          
    adjusted_payoffs.sum / adjusted_payoffs.length.to_f
  end
  
  private
  
  def create_name
    s = "("
    s << PLAYERS.collect do |player|
      "#{strategy(player).name}"
    end.join(',')
    s << ") #{server.version}"
    
    s
  end
  
  def sort_strategies
    self.strategies=[self.strategy_one_id, 
                     self.strategy_two_id, 
                     self.strategy_three_id]
    
    true
  end
end
