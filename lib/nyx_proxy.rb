require 'net/ssh'

class NyxProxy
  BATCH_CMD = "/home/wellmangroup/tac_aa_analysis/current/script/batch"
  QSTAT_CMD = "/usr/local/torque/bin/qstat"
  def initialize
  end
  
  def submit_simulation(simulation)
    
    account = simulation.account
    
    Net::SSH.start(account.host, account.username) do |ssh|
      simulation.logger.info ssh.exec!("#{BATCH_CMD} #{simulation.id}")
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
  
  def check_active_simulations
    
    Simulation.active.each do |simulation|
    
      check_simulation simulation
    
    end
    
  end
  
  def queue_pending_simulations
    
    Simulation.pending.each do |simulation|
      
      account = simulation.account
      
      active_simulations = Simulation.active.count :conditions=>{:account_id=>account.id}
      
      available_slots = account.max_concurrent_simulations - active_simulations
      
      submit_simulation(simulation) if available_slots > 0
      
    end
    
  end
  
end