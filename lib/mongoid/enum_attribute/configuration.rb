module Mongoid
  module EnumAttribute
    class Configuration
      attr_accessor :field_name_prefix
      attr_accessor :prefix
      attr_accessor :suffix

      def initialize
        self.field_name_prefix = '_'
        self.prefix = nil
        self.suffix = nil
      end
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(configuration) if block_given?
    end
  end
end
