#class SampleObserver < ActiveRecord::Observer
#  def after_save(sample)
#    sample.logger.info "SENDING SAMPLE #{sample.id}"
#    MiddleMan.worker(:maintenance_worker).async_process_sample(:arg => sample.id)
#  end
#end
