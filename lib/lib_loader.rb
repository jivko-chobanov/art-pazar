class LibPaths
  attr_reader :absolute_paths

  def initialize
    @root_path = __FILE__.split('/art_pazar/').first << '/art_pazar/lib/'
    @relative_paths = [ 'pipe',
                        'support',
                        'attribute_groups',
                        'runtime_table',
                        'data_objects',
                        'pages/action',
                        'pages/page',
                        'pages/operation',
                        'data_objects/products',
                        'data_objects/product_specifications',
                        'data_objects/users',
                        'data_objects/carts',

                        'pages_for_data_objects/product_list_page',
                        'pages_for_data_objects/product_details_page',
                        'pages_for_data_objects/product_blank_for_create_page',
                        'pages_for_data_objects/product_create_operation',
                        'pages_for_data_objects/product_blank_for_update_page',
                        'pages_for_data_objects/product_update_operation',
                        'pages_for_data_objects/product_delete_operation',

                        'pages_for_data_objects/user_list_page',
                        'pages_for_data_objects/user_details_page',
                        'pages_for_data_objects/user_blank_for_create_page',
                        'pages_for_data_objects/user_create_operation',
                        'pages_for_data_objects/user_blank_for_update_page',
                        'pages_for_data_objects/user_update_operation',
                        'pages_for_data_objects/user_delete_operation',

                        'pages_for_data_objects/cart_list_page',
                        'pages_for_data_objects/cart_details_page',
                        'pages_for_data_objects/cart_blank_for_create_page',
                        'pages_for_data_objects/cart_create_operation',
                        'pages_for_data_objects/cart_blank_for_update_page',
                        'pages_for_data_objects/cart_update_operation',
                        'pages_for_data_objects/cart_delete_operation',

                        'controllers/request_controller',
                        'controllers/user_controller',
                        'controllers/cart_controller',
                      ]
    @absolute_paths = @relative_paths.map { |relative_path| @root_path + relative_path + ".rb" }
  end
end

lib_paths = LibPaths.new
lib_paths.absolute_paths.each { |path| require path }
