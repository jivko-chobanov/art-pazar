require(__FILE__.split('art_pazar/').first << '/art_pazar/lib/lib_loader.rb')

class Home
  attr_reader :loaded_data
  
  def initialize
    @loaded_data = {}
  end

  def load
    @loaded_data[:products] = Pipe.get(:data,
      data_obj_class: Main::Product,
      attribute_group: :list,
      order: :last,
      limit: 10
    )
  end

  def html
    if ready_for_html?
      Pipe.get :html, data: @loaded_data
    else
      raise "load before getting html"
    end
  end

  def ready_for_html?
    if @loaded_data.empty?
      false
    else
      true
    end
  end
end
