class Slither
  class ParserError < RuntimeError; end

  class Column
    attr_reader :name, :length, :options

    def initialize(name, length, options)
      @name = name
      @length = length
      @options = options
    end

    def unpacker
      "A#{@length}"
    end

    def format(value)
      truncate(formatter % value)
    end

    private

    def truncate(result)
      if result.length > @length
        if options[:truncate]
          result[0, @length]
        else
          raise Slither::FormattedStringExceedsLengthError,
            "The formatted value '#{result}' in column '#{@name}' exceeds the allowed length of #{@length} chararacters."
        end
      else
        result
      end
    end

    def formatter
      "%-#{@length}s"
    end

  end
end
