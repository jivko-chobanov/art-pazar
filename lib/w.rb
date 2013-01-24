watch(%r{(tests|models|controllers)/.*\.rb}) do
  system 'clear'
  success = system 'rspec tests/'

  if success
    puts "OK " * 20 << "\n\n"
  else
    puts "F " * 20 << "\n\n"
  end
end
