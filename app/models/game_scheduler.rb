class GameScheduler < ActiveRecord::Base
  belongs_to :game
  belongs_to :three_player_profile
  
  named_scope :active, :conditions=>{:active=>true}
  
  validates_numericality_of :min_samples_per_profile, :only_integer=>true, :greater_than_or_equal_to=>0
  validates_presence_of :scheduler_type
  
  
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
  
  def find_profile
    scheduled_profile = nil
    
    if self.scheduler_type == "All"
      game.profiles.shuffle.each do |profile| # shuffle vs random? - is this okay? what are the differences?
	if profile.three_player_profile.three_player_payoffs.count < min_samples_per_profile
	  scheduled_profile = profile.three_player_profile
	  break
	end
      end
    elsif self.scheduler_type == "Deviation"
      game.get_deviated_profiles(ThreePlayerProfile.find(self.profile_id), 1).shuffle.each do |profile|
	if profile.three_player_profile.three_player_payoffs.count < min_samples_per_profile
	  scheduled_profile = profile.three_player_profile
	  break
	end
      end
    else
      if ThreePlayerProfile.find(self.profile_id).three_player_profile.three_player_payoffs.count < min_samples_per_profile
	scheduled_profile = ThreePlayerProfile.find(self.profile_id)
      end
    end
    
    scheduled_profile
  end
  
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
  

  
end
