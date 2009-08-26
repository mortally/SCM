class OldSimulationUploader
  #This may have to be called several times
  def process_all_samples(sim_id)
    simulation = Simulation.find(sim_id)
    samples = simulation.samples.all
    
    parser = ScoreParser.new
    samples.each do |sample|
      #if the sample is clean, ignore
      #if the sample is dirty, ignore
      if sample.clean.nil?
        begin
          parser.calculate_payoff(sample)
        rescue => e
          logger.error "Error processing sample: #{e.message}\n #{e.backtrace.join('n')}"
        end
      end
    end
      
    puts "Done"  
  end
  
  def finish_and_update_size(sim_id)
    @simulation = Simulation.find(sim_id)
    @samples = @simulation.samples.all
    
    @simulation.update_attribute(:size, @samples.size)
    @simulation.send("finish!")
  end
  
end