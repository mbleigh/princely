module Princely
  class Version
    class << self
      def version
        '2.0.3'
      end

      def to_s
        version
      end
    end
  end
end
