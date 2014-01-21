class SessionsController < Devise::SessionsController
	def new
		super
	end

	def destroy
		current_user.authentication_token = nil
	end

	protected
	def verified_request?
		request.content_type == "application/json" || super
	end
end