class ApplicationController < ActionController::API
  before_action :authorized

  def encode_token(payload)
    exp = 59.minutes.from_now
    payload[:exp] = exp.to_i
    JWT.encode(payload, "t0d0@pi")
  end

  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.headers["Authorization"]
  end

  def decoded_token
    if auth_header
      token = auth_header.split(" ")[1]
      # header: { 'Authorization': 'Bearer <token>' }
      begin
        JWT.decode(token, "t0d0@pi", true, algorithm: "HS256")
      rescue JWT::DecodeError
        nil
      end
    end 
  end

  #checking if the user is admin
  def is_admin
    decoded_token[0]["isadmin"]
  end

  def logged_in_user
    if decoded_token
      user_email = decoded_token[0]["user_email"]
      @user = User.find_by(email: user_email)
    end
  end

  def logged_in?
    !!logged_in_user
  end

  def authorized
    render json: { is_success: false, message: "Please log in first" }, status: 401 unless logged_in?
  end
end
