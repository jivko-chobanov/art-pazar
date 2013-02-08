class Page
  def initialize
    @is_loaded = false
  end

  def load
    unless loaded?
      @is_loaded = true
      yield if block_given?
    else
      raise "cannot load page twice"
    end
  end

  def html
    if pipe_name_of_txt_if_empty_content
      Pipe.new.get :txt, txt: pipe_name_of_txt_if_empty_content
    elsif loaded?
      yield
    else
      raise "Cannot generate HTML without data to be loaded first."
    end
  end

  def load_and_get_html
    load
    html
  end

  def loaded?
    @is_loaded
  end
end
