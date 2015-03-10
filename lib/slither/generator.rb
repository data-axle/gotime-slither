class Slither
  class Generator

    def initialize(definition)
      @definition = definition
    end

    def generate(content)
      @builder = []

      content = [content] unless content.is_a?(Array)
      raise(Slither::RequiredSectionEmptyError, "Required section '#{section.name}' was empty.") if content.empty?
      content.each do |row|
        @builder << definition.format(row)
      end

      newline_style = newline_lookup(@definition.options[:newline_style])

      output_string = @builder.join(newline_style)
      output_string << newline_style if @definition.options[:terminal_newline]

      output_string
    end

    private

    def newline_lookup(option)
      option == :dos ? "\r\n" : "\n"
    end

  end
end
