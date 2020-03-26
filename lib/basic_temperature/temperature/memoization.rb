# frozen_string_literal: true

module BasicTemperature
  class Temperature
    module Memoization
      private

      def memoized(key)
        name = convert_to_variable_name(key)

        instance_variable_get(name) if instance_variable_defined?(name)
      end

      def memoize(key, proc)
        name = convert_to_variable_name(key)
        value = proc.call

        instance_variable_set(name, value)
      end

      def convert_to_variable_name(key)
        "@#{key}"
      end
    end
  end
end
