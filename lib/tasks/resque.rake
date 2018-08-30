require 'resque/tasks'

namespace :resque do
  task :setup do
    require 'resque'
    puts "-redis-host-and-port--#{ENV['REDIS_HOST_AND_PORT']}"
    Resque.redis = ENV['REDIS_HOST_AND_PORT']
  end
end
