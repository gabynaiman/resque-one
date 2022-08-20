module Resque
  module One
    module ResqueExt

      def enqueue_to(queue, klass, *args)
        job_info = JobInfo.new klass, args
        queue_locker = QueueLocker.new redis, queue

        if !job_info.one? || queue_locker.lock(job_info)
          super queue, job_info.klass, *args
        else
          nil
        end
      end

      def reserve(queue)
        job = super queue
        return nil if job.nil?

        job_info = JobInfo.parse job.payload

        if job_info.one?
          queue_locker = QueueLocker.new redis, queue
          queue_locker.unlock job_info
        end

        job
      end

      def dequeue(klass, *args)
        job_info = JobInfo.new klass, args

        if job_info.one?
          queue_locker = QueueLocker.new redis, Resque.queue_from_class(job_info.klass)
          if args.empty?
            queue_locker.unlock_all job_info.klass
          else
            queue_locker.unlock job_info
          end
        end

        super job_info.klass, *args
      end

      def remove_queue(queue)
        queue_locker = QueueLocker.new redis, queue
        queue_locker.unlock_all

        super queue
      end

    end
  end
end