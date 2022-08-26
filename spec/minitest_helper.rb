require 'coverage_helper'
require 'minitest/autorun'
require 'minitest/colorin'
require 'pry-nav'
require 'resque-one'
require 'resque-status'
require 'jobs'

Resque::One.configure do |config|
  config.lock_ttl = 1
end

class Minitest::Spec

  def setup
    Resque.redis.redis.flushdb
  end

  def default_queue
    Jobs::DEFAULT_QUEUE
  end

  def queued_in(queue)
    Resque.peek queue, 0, 0
  end

  def build_job_payload(klass, args)
    {
      'class' => klass.name,
      'args' => args
    }
  end

end