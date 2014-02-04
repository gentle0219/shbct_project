class Device
  include Mongoid::Document
  include Mongoid::Timestamps

  DEVICE_PLATFORM=%w[ios android]

  field :token,					  :type => String
  field :enabled,         :type => Boolean
  field :platform,        :type => String


  belongs_to :user
  has_many :notifications

  validates_uniqueness_of :token, :scope => :user_id

  def send_single_notification(msg)
    return false if token.nil?
    
    if platform == DEVICE_PLATFORM[0]    # in case platform is ios
      notification = self.notifications.build(message:msg)
      notification.save
      APNS.send_notification(token,notification.message)
    else
      notification = self.notifications.build(message:msg)
      notification.save
      destination = [token]
      data = {:msg=>notification.message}
      GCM.send_notification(destination,data)
    end

  end

  def send_multiple_notifications( msg, *devices )
    
  end

  def send_more_information

  end
end
