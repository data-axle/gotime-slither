class Slither
  class Definition
    attr_reader :name, :columns, :options, :length

    DEFAULT_OPTIONS = {
      by_bytes: true,
      newline_style: :unix,
      terminal_newline: false
    }
    def initialize(name, options = {})
      @name = name
      @options = DEFAULT_OPTIONS.merge(options)
      @columns = []
      @length = 0
    end

    def column(name, length, options = {})
      raise(Slither::DuplicateColumnNameError, "You have already defined a column named '#{name}'.") if @columns.map do |c|
        c.name
      end.flatten.include?(name)
      col = Column.new(name, length, options)
      @columns << col
      @length += length
      col
    end

    def parse(line)
      line_data = divide line
      row = {}
      @columns.each_with_index do |column, index|
        row[column.name] = line_data[index]
      end
      row
    end

    def parse_when_problem(line)
      line_data = divide line
      row = ''
      @columns.each_with_index do |column, index|
        row << "\n'#{column.name}':'#{line_data[index]}'"
      end
      row
    end

    def format(data)
      # raise( ColumnMismatchError,
      #   "The '#{@name}' section has #{@columns.size} column(s) defined, but there are #{data.size} column(s) provided in the data."
      # ) unless @columns.size == data.size
      row = ''
      @columns.each do |column|
        row += column.format(data[column.name])
      end
      row
    end

    private

    def divide(string)
      offset = 0
      @columns.map do |column|
        value = string[offset, column.length]
        offset += column.length
        value.strip!
        value
      end
    end
  end
end
