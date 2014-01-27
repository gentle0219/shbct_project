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
            {success: events.map{|e| {name:e.name,user_name:e.user.user_name,date:e.date,location:e.location,img:e.main_img}}}
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
            {success: events.map{|e| {name:e.name,user_name:e.user.user_name,date:e.date,location:e.location,img:e.main_img}}}
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
            {success: events.map{|e| {name:e.name,user_name:e.user.user_name,date:e.date,location:e.location,img:e.main_img}}}
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




    end
  end
end