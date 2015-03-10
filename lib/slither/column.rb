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

    def format(value)
      truncate(formatter % value)
    end

    private

    def truncate(result)
      result.length > @length ? result[0, @length] : result
    end

    def formatter
      "%-#{@length}s"
    end

  end
end
