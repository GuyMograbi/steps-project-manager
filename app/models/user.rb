class User < ActiveRecord::Base
  
#  validates_presence_of :name
#  validates_uniqueness_of :name 
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable
  
  attr_accessible :email, :password, :password_confirmation
  
  
#  attr_accessor :password_confirmation
#  validates_confirmation_of :password
#  
#  
#  validate :password_non_blank
#  
#  def password
#    @password
#  end
#  
#  
#  def password=(pwd)
#    @password=pwd
#    return if pwd.blank?
#    create_new_salt
#    self.hashed_password = User.encrypt_password(self.password, self.salt)
#  end
#  
#  
#  def self.authenticate(name,password)
#    user =self.find_by_name(name)
#    if user
#      expected_password = self.encrypt_password(password, user.salt)
#      if user.hashed_password != expected_password
#        user = nil
#      end
#    end
#    user
#  end
#  
#  def self.encrypt_password(password,salt)
#    string_to_hash = password + "wibble" + salt
#    Digest::SHA1.hexdigest(string_to_hash);
#  end
#  
#  private 
#  
#  def create_new_salt
#    self.salt = self.object_id.to_s + rand.to_s
#  end
#  
#  def password_non_blank
#    errors.add(:password,"Missing password") if hashed_password.blank?
#  end
#  
end
