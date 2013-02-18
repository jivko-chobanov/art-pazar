class Page < Action
  def initialize
    super
  end

  def html
    if pipe_name_of_txt_if_empty_content
      Pipe.new.get :txt, txt: pipe_name_of_txt_if_empty_content
    elsif loaded?
      yield
    else
      raise "cannot generate HTML without data to be loaded first"
    end
  end

  def load_and_get_html
    load
    html
  end
end
