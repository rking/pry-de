source 'http://rubygems.org'

def hubgem user_repo, branch = 'master'
  user, repo = user_repo.split ?/
  gem repo, git: "git@github.com:#{user}/#{repo}", branch: branch
end

hubgem 'pry/pry'
hubgem 'guard/guard', 'interactor/pry'
gem 'pry-full'

group :development do
  gem 'rspec'
  gem 'yard'
  gem 'rdoc'
  gem 'bundler'
  gem 'jeweler'
end
