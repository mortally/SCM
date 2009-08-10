xml.instruct! :xml, :version=>"1.0"
xml.nfg(:name=>@three_player_game.name, :description=>@three_player_game.description) do |nfg|
  nfg.players do |players|
    [:one,:two,:three].each do |player_name|
      players.player(:id=>player_name)
    end
  end
  nfg.actions do |actions|
    @three_player_game.strategies.each do |strategy|
      actions.action(:id=>strategy.name)
    end
  end
  nfg.payoffs do |payoffs|
    @three_player_game.three_player_profiles.each do |profile|
      payoffs.payoff do |payoff|
        profile.strategies.uniq.each do |strategy|
          payoff.outcome(:action=>strategy.name,
                         :count=>profile.strategy_count(strategy),
                         :value=>profile.payoff(strategy))
        end
      end
    end
  end
end