class LibPaths
  attr_reader :absolute_paths

  def initialize
    @root_path = __FILE__.split('/art_pazar/').first << '/art_pazar/lib/'
    @relative_paths = [ 'pipe',
                        'support',
                        'attribute_groups',
                        'runtime_table',
                        'data_objects',
                        'pages/page',
                        'pages/show_page',
                        'pages/update_or_create_page',
                        'data_objects/products',
                        'data_objects/product_specifications',
                        'controllers/home',
                        'controllers/product_show_page',
                        'controllers/product_update_page',
                        'controllers/product_create_page']
    @absolute_paths = @relative_paths.map { |relative_path| @root_path + relative_path + ".rb" }
  end
end

lib_paths = LibPaths.new
lib_paths.absolute_paths.each { |path| require path }
