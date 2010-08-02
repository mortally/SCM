class NPlayerProfile < ActiveRecord::Base
  belongs_to :server
  
  has_many :players, :dependent=>:destroy
  accepts_nested_attributes_for :players
  validates_associated :players
  
  validates_presence_of :server_id
  validates_numericality_of :size, :only_integer=>true
  validates_uniqueness_of :profile_hash, :scope=>:server_id
  validate :size_equal_to_num_players
  
  before_validation_on_create :initialize_players
  
  has_many :samples, :foreign_key=>"profile_id"
  has_many :simulations, :foreign_key=>"profile_id"
  has_many :n_player_payoffs
  has_many :n_player_adjusted_payoffs
  
  def size_equal_to_num_players
    errors.add(:size, "size must equal the number of players") if (size != players.length)
  end 
  
  #initialize_players is triggered before any information is saved to the database.
  #Each player is automatically assigned a profile_index, with lowest index being assigned to
  #lowest strategy_ids. Lastly a profile_hash is generated for n_player_profile, simply to check for uniqueness.   
  def initialize_players
    hash = []
    p = players.sort_by {|player| player.strategy_id }
    p.each.with_index do |u,i|
      u.n_player_profile_id = self
      u.profile_index = i
      hash << u.strategy_id
    end
    write_attribute(:profile_hash, hash.join(',').to_s)
  end
  
  def strategies
    unless @strategies
      @strategies = []
      players.each do |player|
        @strategies << player.strategy
      end
    end
    @strategies
  end
  
  def name
    @name ||= create_name
  end
  
  def strategy_count(s)
    strategies.inject(0) {|sum,strategy| strategy.id==s.id ? sum+1 : sum }
  end
  
  def create_name
    s = "("
    s << self.players.sort_by {|p| p.profile_index}.collect {|p| "#{p.strategy.name}"}.join(",")
    s << ") #{self.server.name}"
    s
  end
  
  def payoff_to_strategy(strategy)
    payoff = []
    
    players.each do |player|
      payoff << player.avg_payoff if player.strategy_id == strategy.id
    end
    
    payoff.sum / payoff.length.to_f
  end

	def adjusted_payoff_to_strategy(strategy)
    payoff = []
    
    players.each do |player|
      payoff << player.avg_adjusted_payoff if player.strategy_id == strategy.id
    end
    
    payoff.sum.to_f / payoff.length.to_f
  end
  
end
