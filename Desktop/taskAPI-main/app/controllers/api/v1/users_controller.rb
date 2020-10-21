class Api::V1::UsersController < ApplicationController

    before_action :authorized, only: [:auto_login, :update, :destroy, :sign_out]
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
                payload = { user_email: @user.email, isadmin: @user.isadmin}
                token = encode_token(payload)
                subject = 'WelcomeMail'
                
                body = 'You have successully signed up for the taskAPI. visit the link below to sign in. https://api/v1/users/login'

                ApplicationMailer.send_email(@user, subject, body).deliver_now
                render json: { is_success: true, message: "user signup successful", data: @user, token: token }, status: 201
            else
                render json: { is_success: false, message: "user already exists" }, status: 400
            end          
        end

    # LOGGING IN
        def login
            @user = User.find_by(email: params[:email])
            
            if @user && @user.authenticate(params[:password])
                payload = { user_email: @user.email, isadmin: @user.isadmin}
                token = encode_token(payload)
                render json: { is_success: true, message: "login successful", data: @user,token: token }, status: 200
            else
                render json: { is_success: true, message: "Invalid username or password" }, status: 404
            end
        end
  

        def auto_login
            render json: @user
        end
      
          # update user /users/:id
        def update
            if @user
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
            if is_admin
                @user = User.find(params[:id])
                if @user
                    @user.destroy
                    render json: { is_success: true, message: "user deleted successfully" }, status: 200
                else
                    render json: { is_success: false, message: "user not found" }, status: 404
                end
            else
                render json: {message: 'You are not authorised to perform this task'}, status: 401
            end    
        end

        private

        def find_user
             @user = User.find(params[:email])
        end

        def user_params
            params.permit( :email, :password, :isadmin, :username)
        end

end
