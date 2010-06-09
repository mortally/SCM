class Analysis::AnalysisController < ApplicationController
  layout 'analysis/analysis'
  require_role 'analyst'
  
  before_filter :get_status, :except=>[:create, :update, :destroy]
  
  protected
  
  def get_status    
    #@clean_sample_count = EightPlayerPayoff.count
    #@sample_count = Sample.count
    #@active_simulation_count = Simulation.active.count
    #@complete_simulation_count = Simulation.complete.count
    #@active_scheduler_count = GameScheduler.active.count
    #@scheduler_count = GameScheduler.count
    #@clean_sample_count = ThreePlayerPayoff.count
    @clean_sample_count = Sample.find_all_by_clean(true).count
    @sample_count = Sample.count
    @active_simulation_count = Simulation.active.count
    @complete_simulation_count = Simulation.complete.count
    @active_scheduler_count = GameScheduler.active.count
    @scheduler_count = GameScheduler.count
    
  end
end
