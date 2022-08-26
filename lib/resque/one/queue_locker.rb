module Resque
  module One
    class QueueLocker

      PREFIX = 'resque-one'.freeze

      attr_reader :redis, :queue

      def initialize(redis, queue)
        @redis = redis
        @queue = queue
      end

      def locked?(job_info)
        !redis.get(key_for(job_info)).nil?
      end

      def lock(job_info)
        return false if locked? job_info

        job_key = key_for job_info
        redis.set job_key, job_info.id

        true
      end

      def unlock(job_info)
        redis.del key_for(job_info)
      end

      def unlock_all(klass=nil)
        filter = klass ? "#{queue_key}:#{klass.to_s}:*" : "#{queue_key}:*"
        redis.keys(filter).each do |key|
          redis.del key
        end
      end

      private

      def queue_key
        "#{PREFIX}:#{queue}"
      end

      def key_for(job_info)
        "#{queue_key}:#{job_info.key}"
      end

    end
  end
end