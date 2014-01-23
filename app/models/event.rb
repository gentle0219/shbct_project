class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  EVENT_STATE = ["live"]
  
  field :name,          :type => String
  field :location,			:type => String
  field :event_date,		:type => String
  field :description, 	:type => String

  field :rsvp_state,		:type => String					# event status

  belongs_to :user

  has_many :photos, 		:as => :photoble,       dependent: :destroy
  has_many :friends


  def invited_friends
  	self.friends
  end
end