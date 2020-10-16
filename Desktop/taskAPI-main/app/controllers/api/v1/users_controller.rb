class Api::V1::UsersController < ApplicationController
   
    before_action :authorized, only: [:auto_login, :update, :sign_out]
        #GET /users
        def index
            @users = User.all
      
            if @users
              render json: { is_success: true, message: "users fetched", data: @users }, status: 200
            else
              render json: { is_success: false, message: "unable to fetch users" }, status: 400
            end
        end
      
        #POST /sign_up
        def sign_up
           
        
            @user = User.create(user_params)
      
            if @user.valid?
                payload = { user_email: @user.email}
                token = encode_token(payload)
                subject = 'WelcomeMail'
                body = 'You have successully signed up for the taskAPI. welcome !'
                ApplicationMailer.send_email(@user, subject, body).deliver_now
                render json: { is_success: true, message: "user signup successful", data: @user, token: token }, status: 201
            else
                render json: { is_success: false, message: "Invalid credential" }, status: 400
            end          
        end

    # LOGGING IN
        def login
            @user = User.find_by(email: params[:email])
  
            if @user && @user.authenticate(params[:password])
                payload = { user_email: @user.email }
                token = encode_token(payload)
                render json: { is_success: true, message: "login successful", data: @user, token: token }, status: 200
            else
                render json: { is_success: true, message: "Invalid username or password" }, status: 404
            end
        end
  

        def auto_login
            render json: @user
        end
      
          # update user /users/:id
        def update
            if user_exist
                @user = User.find(params[:id])
                @user.update(user_params)
                render json: { is_success: true, message: "user detail updated", data: @user }, status: 200
            else
                render json: { is_success: false, message: "user not found" }, status: 404
            end
        end
    
        def sign_out
            # Get and authenticate the current user if necessary.
            if user = User.find_by(email: params[:email]) 
              # Delete the authentication token.
                user.authentication_token = nil
                user.save
                render json: {message: 'you logged out successfully'}, status: 200
            else
                render json: {message: 'umauthorized: unable to log out'}, status: 400
            end
        end

        def destroy
            
                if user_exist
                    @user = User.find_by(id: params[:id])
                    @user.destroy
                    render json: { is_success: true, message: "user deleted successfully" }, status: 200
                else
                    render json: { is_success: false, message: "user not found" }, status: 404
                end
            
        end

        private

        def user_exist
             User.exists?(params[:id])
        end

        def user_params
            params.permit( :email, :password, :is_admin, :username)
         end

end
