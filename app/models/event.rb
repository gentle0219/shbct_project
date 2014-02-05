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
  
  field :friend_ids,              :type => String  
  field :accepted_friend_ids,     :type => String
  field :unaccepted_friend_ids,   :type => String
  #field :not_rsvp_friend_ids,     :type => String

  belongs_to :user

  has_one :photo,  		  :as => :photoble,       dependent: :destroy
  
  validates_presence_of :name, :location, :event_date, :description, :friend_ids

  scope :upcomming_events, -> {where(:created_at.gte => Time.zone.now).order_by('created_at ASC')}
  scope :previous_events, -> {where(:created_at.lt => Time.zone.now).order_by('created_at DESC')}
  scope :last_events, -> {order_by('created_at DESC')}
  
  def friends
    if friend_ids.present?
      Friend.in(id:friend_ids.split(","))
    else
      []
    end
  end

  def invited_friends
  	self.friends
  end


  def accepted_friends
    if accepted_friend_ids.present?
      Friend.in(id:accepted_friend_ids.split(","))
    else
      []
    end
  end

  def unaccepted_friends
    if unaccepted_friend_ids.present?
      Friend.in(id:unaccepted_friend_ids.split(","))
    else
      []
    end
  end

  def have_not_rsvp_friends
    f_ids = friend_ids.split(",")
    af_ids = accepted_friend_ids.split(",")
    uf_ids = unaccepted_friend_ids.split(",")
    not_rsvp_friend_ids =  f_ids - (af_ids or uf_ids)
    Friend.in(id:not_rsvp_friend_ids.split(","))
  end

  def accept(user)
    event = Event.find(self.id.to_s)
    af_ids = event.accepted_friend_ids.split(",")
    uf_ids = event.unaccepted_friend_ids.split(",")
    af_ids.delete(user.id.to_s)
    uf_ids.delete(user.id.to_s)          
    af_ids << user.id.to_s
    event.update_attributes(accepted_friend_ids:af_ids.join(","),unaccepted_friend_ids:uf_ids.join(","))    
  end

  def unaccept(user)
    event = Event.find(self.id.to_s)
    af_ids = event.accepted_friend_ids.split(",")
    uf_ids = event.unaccepted_friend_ids.split(",")
    af_ids.delete(user.id.to_s)
    uf_ids.delete(user.id.to_s)          
    uf_ids << user.id.to_s
    event.accepted_friend_ids = af_ids.join(",")
    event.unaccepted_friend_ids = uf_ids.join(",")
    event.save
  end

  def date
    dt = self.event_date
    if dt.present?
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