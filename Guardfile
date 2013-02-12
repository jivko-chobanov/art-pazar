#interactor :off

group :backend do
  guard :bundler do
    watch('Gemfile')
  end
end

group :u do
  guard :rspec, spec_paths: ['spec/lib'] do
    ignore %r{^.+(\.swp$|\.swo$|\~$)}

    watch %r{^spec/lib/.+\.rb$}
    watch(%r{^lib/(.+)\.rb$}) do |filename_without_extension|
      "spec/lib/#{filename_without_extension[1]}_spec.rb"
    end
    callback(:run_on_changes_begin) { puts "---------------------------------------------------------------------------------------------------------------------------------------------------" }
  end
end

group :i do
  guard :rspec, spec_paths: ['spec/integration'] do
    ignore %r{^.+(\.swp$|\.swo$|\~$)}

    watch %r{^spec/integration/.+\.rb$}
    watch(%r{^lib/(.+)\.rb$}) { "spec/lib/integration/home_and_products_spec.rb" }
    callback(:run_on_changes_begin) { puts "===================================================================================================================================================" }
  end
end
