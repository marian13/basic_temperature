# frozen_string_literal: true

module BasicTemperature
  class Temperature
    module AdditionalHelpers
      private

      def degrees_with_decimal?(degrees)
        degrees % 1 != 0
      end

      def degrees_without_decimal?(degrees)
        !degrees_with_decimal?(degrees)
      end
    end
  end
end
