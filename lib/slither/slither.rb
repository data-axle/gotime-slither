class Slither

  VERSION = '0.99.5'

  class DuplicateColumnNameError < StandardError; end
  class RequiredSectionNotFoundError < StandardError; end
  class RequiredSectionEmptyError < StandardError; end
  class FormattedStringExceedsLengthError < StandardError; end
  class ColumnMismatchError < StandardError; end
  class LineWrongSizeError < StandardError; end
  class SectionsNotSameLengthError < StandardError; end


  def self.define(name, options = {}, &block)
    definition = Definition.new(name, options)
    yield(definition)
    definitions[name] = definition
    definition
  end

  def self.generate(definition_name, data)
    definition = definition(definition_name)
    raise ArgumentError, "Definition name '#{name}' was not found." unless definition
    generator = Generator.new(definition)
    generator.generate(data)
  end

  def self.write(filename, definition_name, data)
    File.open(filename, 'w') do |f|
      f.write generate(definition_name, data)
    end
  end

  def self.parse(filename, definition_name, &block)
    raise ArgumentError, "File #{filename} does not exist." unless File.exists?(filename)

    file_io = File.open(filename, 'r')
    parse_io(file_io, definition_name, &block)
  end

  def self.parse_io(io, definition_name, &block)
    definition = definition(definition_name)
    raise ArgumentError, "Definition name '#{definition_name}' was not found." unless definition
    parser = Parser.new(definition, io)
    definition.options[:by_bytes] ? parser.parse_by_bytes(&block) : parser.parse(&block)
  end

  private

    def self.definitions
      @@definitions ||= {}
    end

    def self.definition(name)
      definitions[name]
    end
end
