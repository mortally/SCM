class ScoreParser
  BIN_PATH=RAILS_ROOT+"/bin"
  SCORE_CMD=BIN_PATH+"/extract-payoffs.py"
  
  def initialize    
  end
    
  def calculate_payoff(sample)
    scores = read_scores_from_file(sample.full_filename) if sample.full_filename
    unless scores
      sample.update_attribute(:clean, false)
      return
    end
    
    three_player_payoff = sample.three_player_payoff
    unless three_player_payoff
      three_player_payoff = sample.build_three_player_payoff      
      three_player_payoff.three_player_profile = sample.profile
    end
    
    for i in 0..2
      player = ThreePlayerProfile::PLAYERS[i]
      payoff = scores[i]
      
      three_player_payoff.send("strategy_#{player}_payoff=", payoff)
    end
    
    three_player_payoff.save
    sample.update_attribute(:clean, true)
  end
  
  private 
    
  def read_scores_from_file(game_file)
    
    f = IO.popen("python #{SCORE_CMD} #{game_file}")
    
    lines = f.readlines if f
    puts lines
    
    f.close if f
    
    YAML.load( lines.join('') )
  end
  
  
end