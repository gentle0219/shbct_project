class Notification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message,					  :type => String
  
  belongs_to :device
  
end
