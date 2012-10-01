source :rubygems
gemspec

gem 'pry', github: 'pry'

case RUBY_PLATFORM
when /linux/i; gem 'rb-inotify'
when /darwin/i; gem 'rb-fsevent'
end
