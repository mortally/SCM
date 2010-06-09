class SampleObserver < ActiveRecord::Observer
  def after_save(sample)
    sample.logger.info "SENDING SAMPLE #{sample.id}"
#    MiddleMan.worker(:maintenance_worker).async_process_sample(:arg => sample.id)
    MiddleMan.worker(:maintenance_worker).enq_process_sample(:arg => sample.id, :scheduled_at => Time.now + 15.seconds, :job_key=>"process-sample-#{sample.id}")
  end
end
