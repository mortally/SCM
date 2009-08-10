class ThreePlayerGame < Game
  has_and_belongs_to_many :three_player_profiles
  
  alias_method :profiles, :three_player_profiles
  
  def add_strategy(strategy)
    unless strategies.exists? strategy
      self.strategies << strategy 
      ensure_profiles
    end
  end
  
  def remove_strategy(strategy)
    if strategies.exists? strategy
      self.strategies.delete strategy 
      prune_profile strategy
    end
  end
  
  private
  
  def ensure_profiles
    ids = self.strategies.collect {|s| s.id}
    ids.sort!
    
    for i in 0..(ids.length-1)
      for j in i..(ids.length-1)
        for k in j..(ids.length-1)
                    profile = three_player_profiles.first :conditions=>{:strategy_one_id=>ids[i], 
                                                                        :strategy_two_id=>ids[j],
                                                                        :strategy_three_id=>ids[k]}
                    #TODO:What the hell does this line mean?
                    unless profile
                      self.three_player_profiles << ThreePlayerProfile.find_or_create_by_server_id_and_strategy_three_id_and_strategy_one_id_and_strategy_two_id(self.server_id,ids[k], ids[i], ids[j])
                    end
        end
      end
    end
  end
  
  def prune_profile(strategy)
    removable_profiles = []
    three_player_profiles.each do |profile|
      removable_profiles << profile if profile.strategy_one_id == strategy.id || 
                                       profile.strategy_two_id == strategy.id || 
                                       profile.strategy_three_id == strategy.id
    end
    removable_profiles.each do |profile|
      three_player_profiles.delete(profile)
    end
  end
end
