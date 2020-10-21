class Api::V1::PasswordsController < ApplicationController

    before_action :authorized, only: [:update], except: [:forgot, :reset]

    def forgot
        if params[:email].blank?
            return render json: {error: 'Email not present'}, status: 400
        end
    
        user = User.find_by(email: params[:email].downcase)
    
        if user.present?
            token = user.generate_password_token!
            subject = "Password Reset Token"
            body = "use the token: #{token} to reset your password"

            ApplicationMailer.send_email(user, subject, body).deliver_now

            render json: {status: 'token has been sent to your email'}, status: 200
        else
            render json: {error: 'Email address not found. Please check and try aain.'}, status: 404
        end
    end

    def reset
        token = params[:token].to_s
        
        if params[:email].blank?
            return render json: {error: 'email not found'}
        end
    
        user = User.find_by(reset_password_token: token)
    
        if user.present? && user.password_token_valid?
            if user.reset_password!(params[:password])
                render json: {status: 'password reset successfully'}, status: 200
            else
                render json: {error: user.errors.full_messages}, status: :unprocessable_entity
            end
        else
            render json: {error:  'Link not valid or expired. Try generating a new link.'}, status: 404
        end
    end

    def update
        user = User.find_by(email: params[:email])
        if user
            if !params[:password].present?
                render json: {error: 'Password not present'}, status: :unprocessable_entity
                return
            end
          
            if user.reset_password(params[:password])
                render json: {status: 'password updated successfully'}, status: 200
            else
                render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
            end
        else
            render json: {error: 'Email does not match'}, status:400
        end
        
    end
      
    
end
