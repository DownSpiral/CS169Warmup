class Users < ActiveRecord::Base

  before_create :default_values

  private
  def default_values
    self.count ||= 1
  end

  SUCCESS = 1
  ERR_BAD_CREDENTIALS = -1
  ERR_USER_EXISTS = -2
  ERR_BAD_USERNAME = -3
  ERR_BAD_PASSWORD = -4
  ERR_DID_NOT_SAVE = -5

  def self.add (_user, _password)
    errCode = SUCCESS

    if _user == nil or _user.length == 0 or _user.length > 128
      errCode = ERR_BAD_USERNAME
    end

    if _password.length > 128
      errCode = ERR_BAD_PASSWORD
    end

    if Users.exists?(:user => _user)
      errCode = ERR_USER_EXISTS
    end

    @user = Users.new(:user => _user, :password => _password)
    if not @user.save
      errCode = ERR_DID_NOT_SAVE
    end

    return errCode

  end

  def self.login(_user, _password)
    @user = Users.find_by_user(_user)

    if @user != nil and @user.password == _password
      @user.update_attribute(:count, @user.count + 1)
      return @user.count
    else
      return ERR_BAD_CREDENTIALS
    end

  end

end