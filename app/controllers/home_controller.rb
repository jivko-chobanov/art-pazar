require_relative '../../lib/controllers/home_controller.rb'

class HomeController < ApplicationController
  include HomeControllerInstance
  extend HomeControllerClass
end
