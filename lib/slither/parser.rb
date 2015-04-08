class Slither
  class Parser
    def initialize(definition, file_io)
      @definition = definition
      @file = file_io
    end

    def parse
      @file.each_line do |line|
        line.chomp!
        next if line.empty?

        validate_length(line, @definition)
        yield @definition.parse(line)
      end
    end

    def parse_by_bytes
      byte_length = @definition.length

      while record = @file.read(byte_length)

        unless remove_newlines! && byte_length == record.length
          parsed_line = parse_for_error_message(record)
          raise(Slither::LineWrongSizeError, "Line wrong size: No newline at #{byte_length} bytes. #{parsed_line}")
        end

        record.force_encoding(@file.external_encoding) if @file.respond_to?(:external_encoding)

        yield @definition.parse(record)
      end
    end

    private

      def validate_length(line, definition)
        if line.length != definition.length
          parsed_line = parse_for_error_message(line)
          raise Slither::LineWrongSizeError, "Line wrong size: (#{line.length} when it should be #{definition.length}. #{parsed_line})"
        end
      end

      def remove_newlines!
        return true if @file.eof?
        b = @file.getbyte
        if b == 10 || b == 13 && @file.getbyte == 10
          return true
        else
          @file.ungetbyte b
          return false
        end
      end

      def parse_for_error_message(line)
        line.force_encoding(@file.external_encoding) if @file.respond_to?(:external_encoding)
        @definition.parse_when_problem(line)
      end

  end
end
