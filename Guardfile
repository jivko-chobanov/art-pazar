#interactor :off

group :backend do
  guard :bundler do
    watch('Gemfile')
  end
end

adjustments = {:all_after_pass => false, :all_on_start => false, :focus_on_failed => true}

group :u do
  guard :rspec, {spec_paths: ['spec/lib']}.merge(adjustments) do
    ignore %r{^.+(\.swp$|\.swo$|\~$)}

    watch %r{^spec/lib/.+\.rb$}
    watch(%r{^lib/(.+)\.rb$}) do |filename_without_extension|
      "spec/lib/#{filename_without_extension[1]}_spec.rb"
    end
    callback(:run_on_changes_begin) { puts "---------------------------------------------------------------------------------------------------------------------------------------------------" }
  end
end

group :i do
  guard :rspec, {spec_paths: ['spec/integration']}.merge(adjustments) do
    ignore %r{^.+(\.swp$|\.swo$|\~$)}

    watch %r{^spec/integration/.+\.rb$}
    watch(%r{^lib/(.+)\.rb$}) { "spec/lib/integration/products_spec.rb" }
    watch(%r{^lib/(.+)\.rb$}) { "spec/lib/integration/users_spec.rb" }
    callback(:run_on_changes_begin) { puts "===================================================================================================================================================" }
  end
end
