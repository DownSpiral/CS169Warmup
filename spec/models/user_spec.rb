require 'spec_helper'
require 'rspec'
require_relative '../../app/models/users'

describe Users do

  SUCCESS = 1
  ERR_BAD_CREDENTIALS = -1
  ERR_USER_EXISTS = -2
  ERR_BAD_USERNAME = -3
  ERR_BAD_PASSWORD = -4
  ERR_DID_NOT_SAVE = -5

  u = "uname"
  p = "pass"

  describe "#add" do

    before :each do
      u = "uname"
      p = "pass"
    end

    it "creates a new user and adds it to the database" do

      result = Users.add(u,p)
      result.should eql SUCCESS
    end

    it "user name and password can be 128 chars long" do
      u = "abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde12345678"
      p = "abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde12345678"
      result = Users.add(u,p)
      result.should eql SUCCESS
    end

    it "returns an errCode of -2 if the user already exists" do
      result = Users.add(u,p)
      result = Users.add(u,p)
      result.should eql ERR_USER_EXISTS
    end

    it "returns an errCode of -3 if the user name is empty" do
      u = ""
      result = Users.add(u,p)
      result.should eql  ERR_BAD_USERNAME
    end

    it "returns an errCode of -3 if the user name is longer than 128 chars" do
      u = "abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde123456789"
      result = Users.add(u,p)
      result.should eql  ERR_BAD_USERNAME
    end

    it "returns an errCode of -4 if the password is longer than 128 chars" do
      p = "abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde123456789"
      result = Users.add(u,p)
      result.should eql ERR_BAD_PASSWORD
    end

  end

  describe "#login" do

    before :each do
      u = "uname"
      p = "pass"
    end

    it "returns the count of the user from the database" do
      Users.add(u,p)
      result = Users.login(u,p)
      result.should eql 2
    end

    it "increments the count by 1" do
      Users.add(u,p)
      result = Users.login(u,p)
      result = Users.login(u,p)
      result.should eql 3
    end

    it "returns an errCode of -1 if the user cannot be found" do
      u = "notentered"
      p = "notentered"
      result = Users.login(u,p)
      result.should eql ERR_BAD_CREDENTIALS
    end

    it "returns an errCode of -1 if the password doesn't match what is stored" do
      u = "uname"
      p = "notentered"
      result = Users.login(u,p)
      result.should eql ERR_BAD_CREDENTIALS
    end
  end

end
