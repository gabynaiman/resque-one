module Resque
  module One
    class QueueLocker

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
        redis.expire job_key, Resque::One.lock_ttl if Resque::One.lock_ttl

        true
      end

      def unlock(job_info)
        redis.del key_for(job_info)
      end

      def unlock_all(klass=nil)
        filter = klass ? "#{queue_key}:#{klass.to_s}:*" : "#{queue_key}:*"
        redis.scan_each(match: filter, count: Resque::One.scan_count) do |key|
          redis.del key
        end
      end

      private

      def queue_key
        "#{Resque::One.keyspace}:#{queue}"
      end

      def key_for(job_info)
        "#{queue_key}:#{job_info.key}"
      end

    end
  end
end