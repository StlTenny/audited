module Audited
  module Async
    class AuditActiveJob
      @queue = :audit

      # Allow override in initializer
      def self.queue=(queue)
        @queue = queue.to_sym
      end

      def self.enqueue(klass_name, audits_attrs)
        AuditWorker.perform_later(klass_name, audits_attrs)
      end
    end

    class AuditWorker < ActiveJob::Base
      queue_as :audit

      # Takes a model `klass` and an array of hashes of audit `attrs` and
      # creates audit records from them.
      def self.perform(klass_name, audits_attrs)
        klass = Module.const_get(klass_name)
        audits_attrs.each do |attrs|
          klass.create(attrs)
        end
      end

    end
  end
end
