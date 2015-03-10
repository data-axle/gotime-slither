require 'date'

class Slither
  class ParserError < RuntimeError; end

  class Column
    attr_reader :name, :length

    def initialize(name, length)
      @name = name
      @length = length
    end

    def unpacker
      "A#{@length}"
    end

    private

      def validate_size(result)
        # Handle when length is out of range
        if result.length > @length
          raise Slither::FormattedStringExceedsLengthError,
            "The formatted value '#{result}' in column '#{@name}' exceeds the allowed length of #{@length} chararacters."
        end
        result
      end

  end
end
