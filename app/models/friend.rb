class Friend
  include Mongoid::Document
  include Mongoid::Timestamps

  SOCIAL_STATE = %w[facebook twitter google]
  mount_uploader :avatar, AvatarUploader

  field :email,         :type => String,  :default => ""
  field :avatar,        :type => String  

  field :from_social,   :type => String

  belongs_to :user
end
