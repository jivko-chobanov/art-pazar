interactor :off

group :backend do
  guard :bundler do
    watch('Gemfile')
  end

  guard :rspec do
    ignore %r{^.+(\.swp$|\.swo$|\~$)}

    watch %r{^spec/.+\.rb$}
    watch(%r{^lib/(.+)\.rb$}) do |filename_without_extension|
      "spec/lib/#{filename_without_extension[1]}_spec.rb"
    end
    callback(:run_on_changes_begin) { puts "---------------------------------------------------------------------------------------------------------------------------------------------------" }
  end
end
