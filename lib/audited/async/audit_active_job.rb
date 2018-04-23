module Audited
  module Async
    class AuditActiveJob
      def self.enqueue(klass_name, audits_attrs)
        AuditWorker.perform_later(klass_name, audits_attrs)
      end
    end

    class AuditWorker < ActiveJob::Base
      queue_as :audit

      def perform(klass_name, audits_attrs)
        klass = Module.const_get(klass_name)
        audits_attrs.each do |attrs|
          klass.create(attrs)
        end
      end

    end
  end
end
