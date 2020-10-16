class Api::V1::PasswordsController < ApplicationController
    before_action :authorized, except: [:forgot, :reset, :update]
    def forgot
        if params[:email].blank?
            return render json: {error: 'Email not present'}
        end
    
        user = User.find_by(email: params[:email].downcase)
    
        if user.present?
            token = user.generate_password_token!
            ApplicationMailer.send_email(@user, "token", "Hi #{user.username}\nUse this token to reset password#{token}").deliver_now
            render json: {status: 'ok'}, status: :ok
        else
            render json: {error: ['Email address not found. Please check and try again.']}, status: :not_found
        end
    end

    def reset
        token = params[:token].to_s
        
        if params[:email].blank?
            return render json: {error: 'Token not present'}
        end
    
        user = User.find_by(reset_password_token: token)
    
        if user.present? && user.password_token_valid?
            if user.reset_password!(params[:password])
                render json: {status: 'ok'}, status: :ok
            else
                render json: {error: user.errors.full_messages}, status: :unprocessable_entity
            end
        else
            render json: {error:  ['Link not valid or expired. Try generating a new link.']}, status: :not_found
        end
    end

    def update
        if !params[:password].present?
            render json: {error: 'Password not present'}, status: :unprocessable_entity
            return
        end
      
        if current_user.reset_password(params[:password])
            render json: {status: 'ok'}, status: :ok
        else
            render json: {errors: current_user.errors.full_messages}, status: :unprocessable_entity
        end
    end
      
    
end
