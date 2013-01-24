require_relative '../helper'
require_relative '../controllers/home_controller'

class HomeController < ApplicationController
  include HomeControllerInstance
  extend HomeControllerClass
end

describe HomeController do
  it 'abc' do
  end
end
