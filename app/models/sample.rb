class Sample < ActiveRecord::Base
  belongs_to :simulation
  belongs_to :profile, :class_name=>'ThreePlayerProfile'
  has_one :three_player_payoff, :dependent=>:destroy
  
  named_scope :clean, :conditions=>{:clean=>true}
  
  #TODO:Change
  has_attachment :storage => :file_system, 
                 :max_size => 20.megabytes, 
                 :content_type => ['application/xml',
                                   'text/xml']

  validates_as_attachment                                                              
end
