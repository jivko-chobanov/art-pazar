module HomeControllerInstance
  def index
    @products = Products.latest 10
  end
end

module HomeControllerClass
end
