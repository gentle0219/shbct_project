module Endpoints
  class Accounts < Grape::API

    resource :accounts do

      # Accounts API test
      # /api/v1/accounts/ping
      # results  'gwangming'
      get :ping do
        { :ping => 'gwangming' }
      end

      # Get User account info
      # GET: /api/v1/accounts/user
      # parameters:
      #   token:    String *required
      # results: 
      #   return user data json
      get :user do
        user = User.find_by_token params[:token]        
        if user.present?
          {success: {user_name:user.user_name,email:user.email,phone:user.phone,social:user.from_social.capitalize}}
        else
          {:failure => "cannot find user"}
        end
      end

      # Get User notifications setting info
      # GET: /api/v1/accounts/notifications_setting
      # parameters:
      #   token:    String *required
      # results: 
      #   return user notification settings data json
      get :notifications_setting do
        user = User.find_by_token params[:token]        
        if user.present?
          {success: {event_reminders:user.event_reminders,chat_notifications:user.chat_notifications,new_friend_events:user.new_friend_events,people_joining_events:user.people_joining_events,people_leaving_events:user.people_leaving_events,event_changes:user.event_changes}}
        else
          {:failure => "cannot find user"}
        end
      end

      ##########################################################################################
      #  ACCOUNT SETTINGS                                                                      #
      ##########################################################################################
      
      # Upload image
      # POST: /api/v1/accounts/upload_avatar
      # parameters:
      #   token:    String *required
      #   avatar:   Image Data *required
      # results: 
      #   return success string
      post :upload_avatar do
        user = User.find_by_token params[:token]
        return {failure: 'Please select avatar'} if params[:avatar].blank?
        if user.present?
          user.assign_attributes(avatar:params[:avatar])          
          #if user.avatar.file.size.to_f/(1024*1024) > 0.3
          #  {:failure => 'Please use image of 200 X 200'}
          #else
            if user.save              
              {:success => 'uploaded avatar successfully'}
            else
              {:failure => 'invalid image data'}
            end
          #end          
        else
          {:failure => "cannot find user"}
        end
      end


      # Change User email address
      # /api/v1/accounts/change_email
      # PARAMS(token, email)
      post :change_email do
        user = User.find_by_token params[:token]
        email = params[:email]
        if user.present?
          user.update_attribute(:email, email)
          {success: "successfully changed email"}
        else
          {:failure => "cannot find user"}
        end
      end
      # Change User Name
      # /api/v1/accounts/change_user_name
      # PARAMS(token,user_name)
      post :change_user_name do
        user = User.find_by_token params[:token]
        user_name = params[:user_name]
        if user.present?
          user.update_attribute(:user_name,user_name)
          {success: "successfully changed user name"}
        else
          {:failure => "cannot find user"}
        end
      end

      # Change Phone number
      # POST: /api/v1/accounts/change_phone
      # parameters:
      #   token:    String *required
      #   phone:    String *required
      # results: 
      #   return success string
      post :change_phone do
        user = User.find_by_token params[:token]
        phone = params[:phone]
        if user.present?
          user.update_attribute(phone:phone)
          {success: "successfully changed phone number"}
        else
          {:failure => "cannot find user"}
        end
      end


      # Change Password
      # /api/v1/accounts/change_password
      # PARAMS(token,old_pswd, new_pswd, confirm_pswd)
      post :change_password do
        user = User.find_by_token params[:token]
        old_pswd      = params[:old_pswd]
        new_pswd      = params[:new_pswd]
        confirm_pswd  = params[:confirm_pswd]
        return {failure: "check your new password and confirm password"} if new_pswd != confirm_pswd
        if user.present?
          if user.valid_password?(old_pswd)
            user.password               = new_pswd
            user.password_confirmation  = confirm_pswd
            if user.save
              {success: "successfully changed password"}
            else
              {failure: user.errors.messages}
            end
          end
        else
          {:failure => "cannot find user"}
        end
      end

      # Notification Settings
      # POST: /api/v1/accounts/notifications_setting
      # parameters:
      #   token:                  String  *required
      #   event_reminders         Boolean *required
      #   chat_notifications      Boolean *required
      #   new_friend_events       Boolean *required
      #   people_joining_events   Boolean *required
      #   people_leaving_events   Boolean *required
      #   event_changes           Boolean *required
      # results: 
      #   return success string
      post :notifications_setting do
        user = User.find_by_token params[:token]
        event_reminders         = params[:event_reminders]
        chat_notifications      = params[:chat_notifications]        
        new_friend_events       = params[:new_friend_events]
        people_joining_events   = params[:people_joining_events]        
        people_leaving_events   = params[:people_leaving_events]
        event_changes           = params[:event_changes]
        
        if user.present?
          if user.valid_password?(old_pswd)
            user.update_attributes(
              event_reminders:event_reminders, 
              chat_notifications:chat_notifications, 
              new_friend_events:new_friend_events,
              people_joining_events:people_joining_events,
              people_leaving_events:people_leaving_events,
              event_changes:event_changes
              )
            if user.save
              {success: "successfully changed password"}
            else
              {failure: user.errors.messages}
            end
          end
        else
          {:failure => "cannot find user"}
        end
      end
    end
  end
end