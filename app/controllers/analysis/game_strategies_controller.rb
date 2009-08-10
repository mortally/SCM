class Analysis::GameStrategiesController < Analysis::AnalysisController
  before_filter :get_game
  
  def create
    @strategy = Strategy.find params[:strategy_id]
  
    @game.add_strategy @strategy
    
    redirect_to [:analysis, @game]
  end
  
  def destroy
    @strategy = Strategy.find params[:id]
  
    @game.remove_strategy @strategy
    
    redirect_to [:analysis, @game]
  end
  
  private
  
  def get_game
    @game = Game.find params[:game_id]
  end
end
