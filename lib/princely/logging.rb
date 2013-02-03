module Princely
  module Logging

    class << self
      attr_accessor :logger, :filename

      def logger
        @logger ||= defined?(Rails) ? Rails.logger : StdoutLogger
      end

      def filename
        pathname = defined?(Rails) ? Rails.root : Princely.root
        @filename ||= pathname.join 'log', 'prince.log'
      end
    end

  end
end
