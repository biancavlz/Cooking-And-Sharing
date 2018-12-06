class User < ApplicationRecord
  before_save { self.email = email.downcase }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :password, presence: true, length: { minimum: 4 }, allow_nil: true
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, 
                    length: { maximum: 245 }, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_many :recipes, dependent: :destroy
  has_secure_password                  
end
