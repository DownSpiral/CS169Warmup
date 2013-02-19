class UsersController < ApplicationController

  skip_before_filter :verify_authenticity_token
  respond_to :json, :html

  def login
    msg = {}
    result = Users.login(params[:user], params[:password])

    if result > 1
      msg = { "errCode" => 1, "count" => result}
    else
      msg = { "errCode" => result }
    end

    render json: msg

  end

  def add
    msg = {}
    result = Users.add(params[:user],params[:password])

    if result > 0
     msg = {:errCode => 1, :count => 1 }
    else
      msg = {:errCode => result}
    end

    render json: msg
  end

end
