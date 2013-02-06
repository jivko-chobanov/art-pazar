module ShowPage
  attr_reader :is_loaded
  alias loaded? is_loaded

  def initialize_show_page
    @is_loaded = false
  end

  def load_show_page
    unless loaded?
      @is_loaded = true
      yield if block_given?
    else
      raise "cannot load home twice"
    end
  end

  def html_of_show_page(pipe_name_of_txt_for_empty_result_if_empty = false)
    if pipe_name_of_txt_for_empty_result_if_empty
      Pipe.new.get :txt, txt: pipe_name_of_txt_for_empty_result_if_empty
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
end
