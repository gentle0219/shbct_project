class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  EVENT_STATE = ["live"]
  
  field :name,          :type => String
  field :location,			:type => String
  field :event_date,		:type => DateTime
  field :description, 	:type => String
  field :enable_chat,   :type => Boolean
  field :save_state,    :type => Boolean
  field :rsvp_state,		:type => String					# selected status
  
  field :event_state,   :type => String         #published? or draft?
  field :friend_ids,    :type => String

  belongs_to :user

  has_one :photo,  		  :as => :photoble,       dependent: :destroy

  validates_presence_of :name, :location, :event_date, :description, :friend_ids

  scope :upcomming_events, -> {where(:created_at.gte => Time.zone.now).order_by('created_at ASC')}
  scope :previous_events, -> {where(:created_at.lt => Time.zone.now).order_by('created_at DESC')}
  scope :last_events, -> {order_by('created_at DESC')}
  

  def invited_friends
  	self.friends
  end

  def date
    dt = self.event_date
    if dt.present
      dt.strftime("%d %B %H:%M%P")
    else
      ""
    end
  end

  def main_img
    self.photos.first.photo_url
  end

  def photo_url
    return '' if self.photo.nil?
    photo = self.photo
    if photo.present?
      if Rails.env.development?
        return "http://192.168.0.55:3005" + photo.photo_url
      else
        return photo.photo_url
      end      
    else
      url = ''
    end
  end

  #def upcomming_events
  #end

  #def previously_events
  #end
end