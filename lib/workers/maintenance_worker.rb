class MaintenanceWorker < BackgrounDRb::MetaWorker
  set_worker_name :maintenance_worker
  pool_size 10
  
  def create(args = nil)
    #puts "maintenence_worker started"
    logger.info "maintenance_worker started"
    add_periodic_timer(15.minutes) { maintain_simulations }
    add_periodic_timer(1.minutes) { queue_simulations }    
    add_periodic_timer(1.minutes) { process_schedulers }
    add_periodic_timer(1.minutes) { maintain_job_queue } 
    add_periodic_timer(5.minutes) { process_dirty_samples }
    
#    add_periodic_timer(3.minutes) { maintain_simulations }
#    add_periodic_timer(10.seconds) { queue_simulations }    
#    add_periodic_timer(10.seconds) { process_schedulers }
  end
  
  def process_dirty_samples
    samples = Sample.find_all_by_clean(nil)
    unless samples.count == 0
      a_sample = samples[rand(samples.size)]
      process_sample(a_sample.id)    
    end
  end
  
  def process_sample(sample_id)
    #sleep 3
    #thread_pool.defer(:process_sample_task,sample_id)
    thread_pool.defer(:process_sample_task,sample_id)
  end
  
  private
  
  def process_sample_task(sample_id)
    begin

      sample = Sample.find sample_id     

      parser = ScoreParser.new

      clean = parser.calculate_payoff sample

      if clean != false

      	parser.calculate_adjusted_payoff sample

      end

    rescue => e
      logger.error "Error processing sample: #{e.message}\n #{e.backtrace.join('n')}"
    end
    persistent_job.finish!    
  end
  
  def maintain_job_queue
    begin
      jobs = BdrbJobQueue.find_all_by_taken_and_finished true, true, :limit=>100
        
      jobs.each do |job|
        job.destroy
      end
    rescue => e
      logger.error "Error maintaining job queue: #{e.message}\n #{e.backtrace.join('n')}"
    end
  end
  
  def maintain_simulations
    begin
      logger.info "maintain_simulations"
      proxy = NyxProxy.new
      proxy.check_active_simulations
    rescue => e
      logger.error "Error maintaining simulations: #{e.message}\n #{e.backtrace.join('n')}"
    end
  end
  
  def queue_simulations
    begin
      #puts "queue_simulations"
      logger.info "queue_simulations"
      proxy = NyxProxy.new
      proxy.queue_pending_simulations
    rescue => e
      logger.error "Error queueing simulations: #{e.message}\n #{e.backtrace.join('n')}"
    end
  end
  
  def process_schedulers
  
   # begin
   #   another_pass = true
   #   while another_pass
   #     another_pass = false
   #     GameScheduler.active.random.each do |game_scheduler|
   #       another_pass = true if game_scheduler.schedule
   #     end
   #   end 
   # rescue => e
   #   logger.error "Error processing schedulers: #{e.message}\n #{e.backtrace.join('n')}"
   # end
  
    begin
      logger.info "process_schedulers"
      GameScheduler.active.each do |game_scheduler|
        game_scheduler.schedule
      end
    rescue => e
      logger.error "Error processing schedulers: #{e.message}\n #{e.backtrace.join('n')}"
    end
  end
end

