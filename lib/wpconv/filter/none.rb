module Wpconv
  module Filter
    class None
      def self.apply(source_content)
        source_content
      end
    end
  end
end
