# -*- coding: utf-8 -*-
# HELLO!

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'rubygems'
require 'webapi'
require 'rack/cors'

Webapi::Configurations.load Webapi::Configurations::Webapi

Webapi.run_initializers('sequel')

if defined?(::Unicorn)
  require 'unicorn/oob_gc'
  use Unicorn::OobGC

  require 'unicorn/worker_killer'
  # Max requests per worker: 1000 reqs - 1200 reqs
  use Unicorn::WorkerKiller::MaxRequests, 1000, 1200
  # Max memory size (RSS) per worker: 300MB - 500MB
  use Unicorn::WorkerKiller::Oom, ((300) * (1024**2)), ((500) * (1024**2))
end

map '/api' do
  use Rack::Cors do
    allow do
      origins '*'
      resource '*', :headers => :any, :methods => [:get, :post, :put, :delete, :options]
    end
  end

  map '/0.0.1' do
    run Webapi::Endpoints::V001::Webapi.new
  end
end
