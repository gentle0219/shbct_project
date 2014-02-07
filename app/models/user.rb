class User
  include Mongoid::Document
  include Mongoid::Timestamps

  ROLES = ['admin', 'insights', 'tester', 'content creator', 'publisher', 'master admin']
  SOCIAL_STATE = %w[facebook twitter google]

  mount_uploader :avatar, AvatarUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable
         
  ## Database authenticatable
  field :email,                     :type => String, :default => ""
  field :user_name,                 :type => String, :default => ""
  field :phone,                     :type => String, :default => ""
  field :encrypted_password,        :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,      :type => String
  field :reset_password_sent_at,    :type => Time

  ## Rememberable
  field :remember_created_at,       :type => Time

  ## Trackable
  field :sign_in_count,             :type => Integer, :default => 0
  field :current_sign_in_at,        :type => Time
  field :last_sign_in_at,           :type => Time
  field :current_sign_in_ip,        :type => String
  field :last_sign_in_ip,           :type => String

  ## Confirmable
  # field :confirmation_token,      :type => String
  # field :confirmed_at,            :type => Time
  # field :confirmation_sent_at,    :type => Time
  # field :unconfirmed_email,       :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts,         :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,            :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,               :type => Time
  
  field :avatar,                    :type => String     # profile logo image

  field :role,                      :type => String
  field :active,                    :type => Boolean,   :default => true


  field :auth_token,                :type => String
  field :authentication_token,      :type => String
  before_save :ensure_authentication_token

  # ????
  field :event_messages_to_your_phone,            :type => Boolean,   :default => true
  field :event_invitations_to_your_phone,         :type => Boolean,   :default => false
  field :chat_messages_to_your_phone,             :type => Boolean,   :default => false
  field :legal_notices,                           :type => String,    :default => ""
  field :help_faq,                                :type => String,    :default => ""
  field :basic_notifications,                     :type => String,    :default => ""

  # Settings NOtification
  field :event_reminders,           :type => Boolean,   :default => true
  field :chat_notifications,        :type => Boolean,   :default => false
  field :new_friend_events,         :type => Boolean,   :default => true
  field :people_joining_events,     :type => Boolean,   :default => false
  field :people_leaving_events,     :type => Boolean,   :default => false
  field :event_changes,             :type => Boolean,   :default => true

  has_many :friends
  
  def self.search(search)
    if search.present?      
      users = User.or({ :email => /.*#{search}*./ }, { :user_name => /.*#{search}*./ })
      users.where(:role => nil)
    else
      User.where(:role => nil)
    end
  end

  def avata_url
    if self.avatar.url.nil?
      ""
    else
      if Rails.env.production?
        self.avatar.url
      else
        "http://192.168.0.55:3005" + self.avatar.url.gsub("#{Rails.root.to_s}/public/user/", "/user/")
      end
    end
  end
  
  def self.find_by_token(token)
    User.where(:authentication_token=>token).first
  end  

end
