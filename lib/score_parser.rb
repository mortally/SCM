class ScoreParser
  SCORE_BIN_PATH=RAILS_ROOT+"/bin/scmlogtool/examples"
  SCORE_CMD=SCORE_BIN_PATH+"/runexample.sh"
  CHECK_BIN_PATH=RAILS_ROOT+"/bin/game-checker"
  CHECK_CMD=CHECK_BIN_PATH+"/checkgame.pl"
  
  def initialize    
  end
    
  def calculate_payoff(sample)
    check = check_file_clean(sample.full_filename) if sample.full_filename
    #puts check
    unless check.first == "0"
      sample.update_attribute(:clean, false)
      return
    end

    scores = read_scores_from_file(sample.full_filename) if sample.full_filename
    #puts scores
    #puts scores[0]
    unless scores
      sample.update_attribute(:clean, false)
      return
    end
    
    payoffs = []
    
    for i in 0..2
      payoffs[i] = 0
    end
    
    parsed_scores = scores.last(6)
       
    for i in 1..6
      id, agent, payoff = parsed_scores[i-1].split("|")
      unless id == "AGENT"
        sample.update_attribute(:clean, false)
        return
      end
      index = agent.last.to_i
      payoffs[(index+1)/2-1] += payoff.to_i
    end
    
    three_player_payoff = sample.three_player_payoff
    unless three_player_payoff
      three_player_payoff = sample.build_three_player_payoff      
      three_player_payoff.three_player_profile = sample.profile
    end
           
    for i in 0..2
      player = ThreePlayerProfile::PLAYERS[i]
      payoff = payoffs[i] / 2  
      puts "strategy_#{player}_payoff=", payoff
      three_player_payoff.send("strategy_#{player}_payoff=", payoff)
    end
    
    three_player_payoff.save
    sample.update_attribute(:clean, true)
  end
  
  private 
    
  def read_scores_from_file(game_file)
    
    f = IO.popen("sh #{SCORE_CMD} -file #{game_file}")
    
    lines = f.readlines if f
    puts lines
    
    f.close if f
    return lines
    #YAML.load( lines.join('') )
  end
  
  def check_file_clean(game_file)
#    puts "perl #{CHECK_CMD} #{game_file}"
    f = IO.popen("perl #{CHECK_CMD} #{game_file}")
    
    lines = f.readlines if f
    puts lines
    
    f.close if f
    return lines  
  end
  
  
end
