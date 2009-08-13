class HomeController < ApplicationController

  def index    
    @clean_sample_count = ThreePlayerPayoff.count
    @sample_count = Sample.count
    @active_simulation_count = Simulation.active.count
    @complete_simulation_count = Simulation.complete.count
    @active_scheduler_count = GameScheduler.active.count
    @scheduler_count = GameScheduler.count
  end

end
