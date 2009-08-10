class HomeController < ApplicationController

  def index    
    #@clean_sample_count = EightPlayerPayoff.count
    #@sample_count = Sample.count
    #@active_simulation_count = Simulation.active.count
    #@complete_simulation_count = Simulation.complete.count
    #@active_scheduler_count = GameScheduler.active.count
    #@scheduler_count = GameScheduler.count
    @clean_sample_count = 1
    @sample_count = 2
    @active_simulation_count = 3
    @complete_simulation_count = 4
    @active_scheduler_count = 5
    @scheduler_count = 6
  end

end
