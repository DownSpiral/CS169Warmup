class User < ActiveRecord::Base
  validates :user, :uniqueness => true
  validates :user, :presence => true
  validates :user, :password, :length =>  { :maximum => 128 }
end
