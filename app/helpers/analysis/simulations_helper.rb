module Analysis::SimulationsHelper
  def process_all_samples(sim_id)
    @simulation = Simulation.find(sim_id)
    @samples = @simulation.samples.all
    
    @samples.each do |sample|
      MiddleMan.worker(:maintenance_worker).async_process_sample(:arg => sample.id)
    end
  end
  
  def finish_and_update_size(sim_id)
    @simulation = Simulation.find(sim_id)
    @samples = @simulation.samples.all
    
    @simulation.update_attribute(:size, @samples.size)
    @simulation.send("finish!")
  end
    
end
