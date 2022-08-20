module Resque
  module One
    class JobInfo

      attr_reader :klass, :id, :args

      def self.parse(job_payload)
        new job_payload['class'], job_payload['args']
      end

      def initialize(klass, args)
        @klass = klass.is_a?(Class) ? klass : Consty.get(klass)

        if include_plugin_status?
          @id = args.first
          @args = args[1..-1]
        else
          @id = nil
          @args = args
        end
      end

      def key
        @key ||= "#{klass.name}:#{args_digest}"
      end

      def one?
        klass.respond_to?(:one?) ? klass.one? : false
      end

      private

      def args_digest
        Digest::SHA1.hexdigest JSON.dump(args)
      end

      def include_plugin_status?
        klass.ancestors.include? Resque::Plugins::Status
      end

    end
  end
end