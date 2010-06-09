class GameScheduler < ActiveRecord::Base
  belongs_to :game
  
  named_scope :active, :conditions=>{:active=>true}
  
  validates_numericality_of :min_samples_per_profile, :only_integer=>true, :greater_than_or_equal_to=>0
  
  def schedule
    account = find_account
    
    scheduled_profile = find_profile if account
    
    simulation = nil
    if scheduled_profile
      simulation = Simulation.new
      simulation.account = account
      simulation.profile = scheduled_profile
      simulation.save
    end
    
    simulation
  end
  
  private
  
  def find_account
    account = nil
    #Account.all(:order=> 'RAND()').each do |a|
    Account.all.shuffle.each do |a| # SQLite3 does not support RAND() op.
      if a.schedulable?
        account = a
        break
      end
    end
    
    account
  end
  
  def find_profile
    scheduled_profile = nil
    
    game.profiles.random.each do |profile|
      if profile.three_player_profile.three_player_payoffs.count < min_samples_per_profile
        scheduled_profile = profile.three_player_profile
        break
      end
    end
    
    scheduled_profile
  end
end
