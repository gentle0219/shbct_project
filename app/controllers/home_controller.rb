class HomeController < ApplicationController
  
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token

  def index
  end


  def create_session
  	resource = User.find_for_database_authentication(:email => params[:email])
    if resource.nil?
			render :json => {faild:'No Such User'}, :status => 401
		else      
			if resource.valid_password?(params[:password])
				user = sign_in(:user, resource)
        render :json => {:success => resource.authentication_token}
			else
				render :json => {faild: params[:password]}, :status => 401
			end
		end
	end

	def delete_session
		resource = User.find_for_database_authentication(:email => params[:email])
		if resource.nil?
			render :json => {faild:'No Such User'}, :status => 401
		else			
      sign_out(resource)
			render :json => {:success => 'sign out'}
		end
	end

	def create_account
		headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
    if User.where(email:params[:email]).first.present?      
		  render json:{failure: 'This email already exist. Please try another email'} and return 
    end
		o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
		pswd = (0...12).map{ o[rand(o.length)] }.join        
		user = User.new(email:params[:email], password:pswd, first_name:params[:name])
		if user.save
			user = sign_in(:user, user)
      UserMailer.welcome(user).deliver      
			render json: {:success => user.authentication_token}
		else
			render json: {:failure => 'failure not created'}
		end     
	end

	def create
		email        = params[:email].downcase
    from_social  = params[:social].downcase
    if params[:token].present?          
      password   = params[:token][0..10]
      user_name  = params[:user_name]
      phone      = params[:phone]
      user = User.any_of({:email=>email},{:auth_token => params[:token]}).first
      if user.present?
        user.update_attributes( user_name:user_name, phone:phone, )
        if sign_in(:user, user)
          user_info={id:user.id.to_s, user_name:user.user_name,email:user.email,token:user.auth_token, auth_id:user.authentication_token,social:user.from_social}
          render json: {:success => user_info}
        else
          render json: {:failure => 'cannot login'}
        end
      else
          user = User.new(email:email,
              auth_token:params[:token],
              password:password,
              user_name:user_name,
              from_social:from_social,
              phone:phone)
        if user.save
        	if sign_in(:user, user)
            user_info={id:user.id.to_s, user_name:user.user_name,email:user.email,token:user.auth_token, auth_id:user.authentication_token,social:user.from_social}
            render json: {:success => user_info}
          else
            render json: {:failure => 'cannot login'}
          end
        else
          render :json => {:failure => user.errors.messages}
        end
      end
    else
      if User.where(email:email).first.present?
        render json:{failure: 'This email already exists. Please try another email'} and return 
      end
      user = User.new(email:email,password:params[:password], user_name:user_name, phone:phone)
      if user.save
      	if sign_in(:user, user)
          user_info={id:user.id.to_s, user_name:user.user_name,email:user.email,token:user.auth_token, auth_id:user.authentication_token,social:user.from_social}
          render :json => {:success => user_info}
        else
          render json: {:failure => 'cannot login'}
        end        
      else
        render :json => {:failure => 'failure not created'}
      end
    end
	end
end
