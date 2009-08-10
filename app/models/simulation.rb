class Simulation < ActiveRecord::Base
  include AASM
  
  belongs_to :account
  belongs_to :profile, :class_name=>'ThreePlayerProfile'
  
  named_scope :queued, :conditions=> {:state=>'queued'}
  named_scope :running, :conditions=> {:state=>'running'}
  named_scope :complete, :conditions=> {:state=>'complete'}
  named_scope :failed, :conditions=> {:state=>'failed'}
  named_scope :active, :conditions=> ["(state='queued' or state ='running')"]
  named_scope :scheduled, :conditions=> ["(state='pending' or state='queued' or state ='running')"]
  has_many :samples
  
  validates_numericality_of :size, :only_integer=>true, :greater_than=>0
  
  aasm_column :state
  aasm_initial_state :pending

  aasm_state :pending
  aasm_state :queued
  aasm_state :running
  aasm_state :complete
  aasm_state :failed
  
  aasm_event :queue do
    transitions :to => :queued, :from => [:pending]
  end

  aasm_event :fail do
    transitions :to => :failed, :from => [:pending, :queued, :running]
  end
  
  aasm_event :start do
    transitions :to => :running, :from => [:queued]
  end
  
  aasm_event :finish do
    transitions :to => :complete, :from => [:pending, :queued, :running, :failed]
  end
end
