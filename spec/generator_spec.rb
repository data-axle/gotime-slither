require File.join(File.dirname(__FILE__), 'spec_helper')

describe Slither::Generator do
  before(:each) do
    @definition = Slither.define :test do |d|
      d.header do |h|
        h.column :type, 4
        h.column :file_id, 10
      end
      d.body do |b|
        b.column :first, 10
        b.column :last, 10
      end
      d.footer do |f|
        f.column :type, 4
        f.column :file_id, 10
      end
    end
    @data = {
      :header => [ {:type => "HEAD", :file_id => "1" }],
      :body => [
        {:first => "Paul", :last => "Hewson" },
        {:first => "Dave", :last => "Evans" }
      ],
      :footer => [ {:type => "FOOT", :file_id => "1" }]
    }
    @generator = Slither::Generator.new(@definition)
  end

  it "should raise an error if there is no data for a required section" do
    @data.delete :header
    lambda {  @generator.generate(@data) }.should raise_error(Slither::RequiredSectionEmptyError, "Required section 'header' was empty.")
  end

  it "should generate a string with default newline options" do
    expected = "HEAD         1\n      Paul    Hewson\n      Dave     Evans\nFOOT         1"
    @generator.generate(@data).should == expected
  end

  it "should generate a string with the specified newline options" do
    @definition.options.merge!({:newline_style => :dos, :terminal_newline => true})
    expected = "HEAD         1\r\n      Paul    Hewson\r\n      Dave     Evans\r\nFOOT         1\r\n"
    @generator.generate(@data).should == expected
  end
end
