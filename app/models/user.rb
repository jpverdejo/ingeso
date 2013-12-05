class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  validates_uniqueness_of :email, :allow_blank => false
  validates_format_of :email, with: Devise::email_regexp

  validate :email_uniqueness

  def email_uniqueness
    self.errors.add(:base, 'User with same email already exists. Please try with another email address.') if User.where(:email => self.email).exists?
  end
end
