class User < ApplicationRecord
    has_many :tasks

    #hashes password
    has_secure_password

    validates :email, uniqueness:true, presence:true
    validates :password_digest, :username, presence:true

    def generate_password_token!#gives detailed error description

        token = generate_token

        self.reset_password_token = token
        self.reset_password_sent_at = Time.now.utc
                
        save!
        token
    end
      
    def password_token_valid?
        (self.reset_password_sent_at + 4.hours) > Time.now.utc
    end
      
    def reset_password!(password)
        self.reset_password_token = nil
        self.password = password
        save!
    end
      
    private
      
    def generate_token
        #generates a random string (token)
        SecureRandom.hex(10)
    end
end
