class User < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }

  has_secure_password

  def self.authenticate_with_credentials(email, password)
    user = find_by("LOWER(email) = ?", email.strip.downcase)
    puts user
    user if user && user.authenticate(password)
  end
  
  
end
