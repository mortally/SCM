require 'net/ssh'

class NyxProxy
#  BATCH_CMD = "ruby /home/wellmangroup/computer-poker-analysis/current/script/batch"
  BATCH_CMD = "/home/wellmangroup/opt/local/bin/ruby /home/wellmangroup/tac_scm_analysis/script/batch"
  QSTAT_CMD = "/usr/local/torque/bin/qstat"
  def initialize
  end
  
  def submit_simulation(simulation)
    
    account = simulation.account
    #puts "submit_simulatin #{simulation} #{account.username}"
    Net::SSH.start(account.host, account.username) do |ssh|
      simulation.logger.info ssh.exec!("#{BATCH_CMD} #{simulation.id}")
      # puts "#{BATCH_CMD} #{simulation.id}"
      # puts ssh.exec!("#{BATCH_CMD} #{simulation.id}")
    end
    
  end
  
  def check_simulation(simulation)
    
    account = simulation.account
    
    Net::SSH.start(account.host, account.username) do |ssh|
    
      if simulation.job
        
        output = ssh.exec!("#{QSTAT_CMD} -f -1 #{simulation.job}")
  
        if output =~ /Unknown Job Id/
          simulation.fail!
        elsif output =~ /Job Id:/
          # Simulation still good
        else
          simulation.fail!
        end
        
      end
      
    end
  
  end
  
  
  
  
  def check_simulation_new
    
    account = Account.all.shuffle.first
    simulations = Simulation.active
    if simulations.length > 0
      Net::SSH.start(account.host, account.username) do |ssh|
        output = ssh.exec!("#{QSTAT_CMD} -a | grep tacscm")
        outputs = output.split("\n")
        job_id = []
        
        outputs.each do |job|
          job_id << job.split(".").first
        end
        
        simulations.each do |simulation|
          unless job_id.include?(simulation.job)
            simulation.fail!
          end
        end
      end
    end


  end

  def check_active_simulations
    #puts "active simulation! " + Simulation.active.length
    #Simulation.active.each do |simulation|
    #
    #   check_simulation simulation
    #
    #end
    if Simulation.active.length > 0
      check_simulation_new
    end
  end
  
  def queue_pending_simulations
    #puts "pending simulation!" 
    
    Simulation.pending.each do |simulation|
     # puts "pending simulation"
      account = simulation.account
      
      active_simulations = Simulation.active.count :conditions=>{:account_id=>account.id}
      
      available_slots = account.max_concurrent_simulations - active_simulations
      
      submit_simulation(simulation) if available_slots > 0
      
    end
    
  end
  
end
