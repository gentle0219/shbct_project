module Endpoints
  class Events < Grape::API

    resource :events do

      # Events API test
      # /api/v1/events/ping
      # results  'events endpoints'
      get :ping do
        { :ping => 'events ednpoints' }
      end

      # Get Event info
      # GET: /api/v1/events/event
      # parameters:
      #   token:      String *required
      #   event_id:   String *required
      # results: 
      #   return event data json
      get :event do
        user = User.find_by_token params[:token]        
        if user.present?
          
        else
          {:failure => "cannot find user"}
        end
      end

      # Get all my events
      # GET: /api/v1/events/my_events
      # parameters:
      #   token:      String *required      
      # results: 
      #   return my events data json      
      get :my_events do
        user = User.find_by_token params[:token]
        if user.present?
          events = user.events
          if events.present?
            {success: events.map{|e| {name:e.name,user_name:e.user.user_name,date:e.date,location:e.location,img:e.main_img}}}
          else
            {failure: "cannot find your events"}
          end
        else
          {:failure => "cannot find user"}
        end
      end

      # Get upcoming events
      # GET: /api/v1/events/upcoming_events
      # parameters:
      #   token:      String *required
      # results: 
      #   return my events data json
      get :upcoming_events do
        user = User.find_by_token params[:token]
        if user.present?
          events = user.events.upcoming_events
          if events.present?
            {success: events.map{|e| {id:e.id.to_s,name:e.name,user_name:e.user.user_name,date:e.date,location:e.location,img:e.main_img}}}
          else
            {failure: "cannot find your events"}
          end
        else
          {:failure => "cannot find user"}
        end
      end

      # Get previous events
      # GET: /api/v1/events/previous_events
      # parameters:
      #   token:      String *required
      # results: 
      #   return my events data json
      get :previous_events do
        user = User.find_by_token params[:token]
        if user.present?
          events = user.events.previous_events
          if events.present?
            {success: events.map{|e| {id:e.id.to_s,name:e.name,user_name:e.user.user_name,date:e.date,location:e.location,img:e.main_img}}}
          else
            {failure: "cannot find your events"}
          end
        else
          {:failure => "cannot find user"}
        end
      end

      # Get last events
      # GET: /api/v1/events/last_events
      # parameters:
      #   token:      String *required
      # results: 
      #   return my events data json
      get :last_events do
        user = User.find_by_token params[:token]
        if user.present?
          events = user.events.last_events
          if events.present?
            {success: events.map{|e| {id:e.id.to_s,name:e.name,user_name:e.user.user_name,date:e.date,location:e.location,img:e.main_img}}}
          else
            {failure: "cannot find your events"}
          end
        else
          {:failure => "cannot find user"}
        end
      end

      # Get events photos
      # GET: /api/v1/events/event_photos
      # parameters:
      #   token:      String *required
      # results: 
      #   return my event's photo list
      get :event_photos do
        user = User.find_by_token params[:token]
        if user.present?
          events = user.events
          if events.present?
            {success: events.map{|e| {id:e.id.to_s, name:e.name, img:e.main_img}}}
          else
            {failure: "cannot find your events"}
          end
        else
          {:failure => "cannot find user"}
        end
      end

      # Create Event
      # POST: /api/v1/events/create_event
      # parameters:
      #   token:            String *required
      #   save_state:       String *required
      #   name:             String *required
      #   location:         String *required
      #   date:             String *required      2014-1-14,14
      #   description:      String *required
      #   enable_chat:      Boolean *required     true or false
      #   photo:            image data
      #   friend_ids:       String *required
      # results: 
      #   return my events data json
      post :create_event do
        user = User.find_by_token params[:token]
        name          = params[:name]
        location      = params[:location]        
        date          = DateTime.strptime(params[:date].delete(' '),"%Y-%m-%d,%H")        
        friend_ids    = params[:friend_ids].delete(' ')
        description   = params[:description]
        enable_chat   = params[:enable_chat]
        photo         = params[:photo]
        if user.present?
          event = user.events.build(name:name,location:location,event_date:date,friend_ids:friend_ids,description:description,enable_chat:enable_chat)
          if event.save
            if params[:photo].present?
              photo = event.build_photo(photo:photo)
              photo.save
            end
            {success: "created event"}
          else
            {:failure => event.errors.messages}
          end
        else
          {:failure => "cannot find user"}
        end
      end

      # Accept Event
      # POST: /api/v1/events/accept_event
      # parameters:
      #   token:            String *required
      #   event_id:         String *required
      # results: 
      #   return success string
      post :accept_event do
        user  = User.find_by_token params[:token]        
        if user.present?
          event = event.find(params[:event_id])          
          if event.accept(user)
            {success: "successfully accepted event"}
          else
            {:failure => "cannot accept event"}
          end
        else
          {:failure => "cannot find user"}
        end
      end


      # Unaccept Event
      # POST: /api/v1/events/unaccept_event
      # parameters:
      #   token:            String *required
      #   event_id:         String *required
      # results: 
      #   return success string
      post :unaccept_event do
        user  = User.find_by_token params[:token]        
        if user.present?
          event = event.find(params[:event_id])
          if event.unaccept(user)
            {success: "successfully unaccepted event"}
          else
            {:failure => "cannot unaccept event"}
          end
        else
          {:failure => "cannot find user"}
        end
      end

      # Invited friends
      # GET: /api/v1/events/invited_friends
      # parameters:
      #   token:            String *required
      #   event_id:         String *required
      # results: 
      #   return success string
      get :invited_friends do
        user  = User.find_by_token params[:token]        
        if user.present?
          event = event.find(params[:event_id])
          firneds = event.invited_friends.map{|f| {id:f.id.to_s,name:f.name,email:f.email,avatar:f.avatar_url,accepted:f.accepted_event(event)}}
          if friends.present?
            {success: friends}
          else
            {:failure => "cannot find invited friends"}
          end
        else
          {:failure => "cannot find user"}
        end
      end

      # Accepted friends
      # GET: /api/v1/events/accepted_friends
      # parameters:
      #   token:            String *required
      #   event_id:         String *required
      # results: 
      #   return success string
      get :accepted_friends do
        user  = User.find_by_token params[:token]        
        if user.present?
          event = event.find(params[:event_id])
          firneds = event.accepted_friends.map{|f| {id:f.id.to_s,name:f.name,email:f.email,avatar:f.avatar_url,accepted:f.accepted_event(event)}}
          if friends.present?
            {success: friends}
          else
            {:failure => "cannot find accepted friends"}
          end
        else
          {:failure => "cannot find user"}
        end
      end

      # UnAccepted friends
      # GET: /api/v1/events/unaccepted_friends
      # parameters:
      #   token:            String *required
      #   event_id:         String *required
      # results: 
      #   return success string
      get :accepted_friends do
        user  = User.find_by_token params[:token]        
        if user.present?
          event = event.find(params[:event_id])
          firneds = event.unaccepted_friends.map{|f| {id:f.id.to_s,name:f.name,email:f.email,avatar:f.avatar_url,accepted:f.accepted_event(event)}}
          if friends.present?
            {success: friends}
          else
            {:failure => "cannot find unaccepted friends"}
          end
        else
          {:failure => "cannot find user"}
        end
      end

      # Have not rsvp friends
      # GET: /api/v1/events/have_not_rsvp_friends
      # parameters:
      #   token:            String *required
      #   event_id:         String *required
      # results: 
      #   return success string
      get :have_not_rsvp_friends do
        user  = User.find_by_token params[:token]        
        if user.present?
          event = event.find(params[:event_id])
          firneds = event.have_not_rsvp_friends.map{|f| {id:f.id.to_s,name:f.name,email:f.email,avatar:f.avatar_url,accepted:f.accepted_event(event)}}
          if friends.present?
            {success: friends}
          else
            {:failure => "cannot find have not rsvp friends"}
          end
        else
          {:failure => "cannot find user"}
        end
      end


    end
  end
end