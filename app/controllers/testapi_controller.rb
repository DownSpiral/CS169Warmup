class TestapiController < ApplicationController

  skip_before_filter :verify_authenticity_token
  respond_to :json, :html

  def resetFixture
    Users.destroy_all()
    @msg = { 'errCode' => 1 }
    render json: @msg
  end

  def unitTests
    f = IO.popen("rake spec SPEC=spec\\models\\user_spec.rb")
    s = f.read

    totalTests = -1
    nrFailed = -1

    examplesMatch = /(?<num>\d+) examples/.match(s)
    numFailedMatch = /(?<num>\d+) failure/.match(s)

    if not examplesMatch == nil
      totalTests = Integer(examplesMatch[:num])
    end

    if not numFailedMatch == nil
      nrFailed = Integer(numFailedMatch[:num])
    end

    @msg = { 'totalTests' => totalTests, 'nrFailed' => nrFailed, 'output' => s }
    render json: @msg
  end

end
