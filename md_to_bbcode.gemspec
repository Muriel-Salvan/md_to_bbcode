require File.expand_path("#{__dir__}/lib/md_to_bbcode/version")
require 'date'

Gem::Specification.new do |s|
  s.name = 'md_to_bbcode'
  s.version = MdToBbcode::VERSION
  s.date = Date.today.to_s
  s.authors = ['Muriel Salvan']
  s.email = ['muriel@x-aeon.com']
  s.summary = 'Convert Markdown text to Bbcode'
  s.description = 'Provides an API and an executable to convert Markdown text to BBCode format'
  s.homepage = 'https://github.com/Muriel-Salvan/md_to_bbcode'
  s.license = 'BSD-3-Clause'

  s.files = Dir['{bin,lib,spec}/**/*']
  Dir['bin/**/*'].each do |exec_name|
    s.executables << File.basename(exec_name)
  end

  # Dependencies

  # Development dependencies (tests, debugging)
  # Test framework
  s.add_development_dependency 'rspec', '~> 3.10'
end
