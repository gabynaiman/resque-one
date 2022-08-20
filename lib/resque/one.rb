require 'resque'
require 'consty'
require_relative 'one/version'
require_relative 'one/job_info'
require_relative 'one/queue_locker'
require_relative 'one/resque_ext'
require_relative 'plugins/one'

module Resque
  extend One::ResqueExt
end