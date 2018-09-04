# frozen_string_literal: true

workers Integer(ENV.fetch('WEB_CONCURRENCY', 4))
threads_count = Integer(ENV.fetch('MAX_THREADS', 5))
threads(threads_count, threads_count)

preload_app!

if ENV['ANSIBLE_PROVISIONED']
  shared_path = "#{ENV['APP_DIR']}/shared"
  bind "unix://#{shared_path}/tmp/sockets/puma.sock"
  state_path "#{shared_path}/tmp/pids/puma.state"
  pidfile "#{shared_path}/tmp/pids/puma.pid"
  stdout_redirect "#{shared_path}/log/puma.access.log",
                  "#{shared_path}/log/puma.error.log",
                  true
else
  port ENV.fetch('PORT', 8787)
end

#environment ENV.fetch('RACK_ENV', 'development')
environment ENV.fetch("RAILS_ENV") { "production" }

before_fork do
  ::ActiveRecord::Base.connection_pool.disconnect!
  ::I18n.backend.send(:init_translations) unless ::I18n.backend.initialized?
end

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

#on_worker_boot do
  #ActiveRecord::Base.establish_connection
#end
