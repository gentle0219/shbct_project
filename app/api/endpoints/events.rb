module Endpoints
  class Events < Grape::API

    resource :events do

      # Accounts API test
      # /api/v1/accounts/ping
      # results  'gwangming'
      get :ping do
        { :ping => 'events ednpoints' }
      end

    end
  end
end