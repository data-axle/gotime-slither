class Slither
  class Section
    attr_accessor :definition, :optional
    attr_reader :name, :columns, :options, :length
    
    RESERVED_NAMES = [:spacer]
    
    def initialize(name, options = {})
      @name = name
      @options = options
      @columns = []
      @optional = options[:optional] || false
      @length = 0
    end
    
    def column(name, length, options = {})
      raise(Slither::DuplicateColumnNameError, "You have already defined a column named '#{name}'.") if @columns.map do |c|
        RESERVED_NAMES.include?(c.name) ? nil : c.name
      end.flatten.include?(name)
      col = Column.new(name, length, @options.merge(options))
      @columns << col
      @length += length
      col
    end
    
    def spacer(length)
      column(:spacer, length)
    end
    
    def template(name)
      template = @definition.templates[name]
      raise ArgumentError, "Template #{name} not found as a known template." unless template
      @columns += template.columns
      @length += template.length
      # Section options should trump template options
      @options = template.options.merge(@options)
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
    
    def parse(line)
      line_data = divide( line, @columns.map(&:length) )
      row = {}
      i = 0
      @columns.each do |c|
        unless RESERVED_NAMES.include?(c.name)
          row[c.name] = (c.parse_length == 1 ?
              c.parse(line_data[i]) : c.parse(line_data[i, c.parse_length]))
        end
        i += c.parse_length
      end
      row
    end
    
    def parse_when_problem(line)
      line_data = divide( line, @columns.map(&:length) )
      row = ''
      @columns.each_with_index do |c, i|
        row << "\n'#{c.name}':'#{line_data[i]}'" unless RESERVED_NAMES.include?(c.name)
      end
      row
    end
    
    def match(raw_line)
      !raw_line.nil?
    end
    
    def method_missing(method, *args)
      column(method, *args)
    end
  
    private
      
      def unpacker
        @columns.map { |c| c.unpacker }.join('')
      end

      def divide(string, sections)
        result = []
        str = string.dup
        unless @definition.options[:force_character_offset]
          result = str.unpack(unpacker)
          result.each do |s|
            s.force_encoding(string.encoding) if s.respond_to? :force_encoding
          end
        else
          sections.each do |s|
            result << str.slice!(0..(s-1))
          end
        end
        result
      end

  end  
end