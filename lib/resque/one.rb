require 'resque'
require 'consty'
require 'class_config'
require_relative 'one/version'
require_relative 'one/job_info'
require_relative 'one/queue_locker'
require_relative 'one/resque_ext'
require_relative 'plugins/one'

module Resque
  extend One::ResqueExt

  module One
    extend ClassConfig

    attr_config :keyspace, 'resque-one'
    attr_config :scan_count, 1000
  end
end