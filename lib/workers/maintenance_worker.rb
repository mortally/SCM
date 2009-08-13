class MaintenanceWorker < BackgrounDRb::MetaWorker
  set_worker_name :maintenance_worker
  pool_size 10
  
  def create(args = nil)
    add_periodic_timer(3.minutes) { maintain_simulations }
    add_periodic_timer(1.minutes) { queue_simulations }    
    add_periodic_timer(1.minutes) { process_schedulers }
  end
  
  def process_sample(sample_id)
    thread_pool.defer(:process_sample_task,sample_id)
  end
  
  private
  
  def process_sample_task(sample_id)
    begin

      sample = Sample.find sample_id     

      parser = ScoreParser.new

      parser.calculate_payoff sample

    rescue => e
      logger.error "Error processing sample: #{e.message}\n #{e.backtrace.join('n')}"
    end    
  end
  
  def maintain_simulations
    begin
      proxy = NyxProxy.new
      proxy.check_active_simulations
    rescue => e
      logger.error "Error maintaining simulations: #{e.message}\n #{e.backtrace.join('n')}"
    end
  end
  
  def queue_simulations
    begin
      proxy = NyxProxy.new
      proxy.queue_pending_simulations
    rescue => e
      logger.error "Error queueing simulations: #{e.message}\n #{e.backtrace.join('n')}"
    end
  end
  
  def process_schedulers
    begin
      GameScheduler.active.each do |game_scheduler|
        game_scheduler.schedule
      end
    rescue => e
      logger.error "Error processing schedulers: #{e.message}\n #{e.backtrace.join('n')}"
    end
  end
end

