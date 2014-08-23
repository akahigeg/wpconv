require 'thor'
require 'readline'

module Wpconv
  class CLI < Thor
    desc "convert WP_XML_PATH", "convert wordpress export xml to markdown."
    option :output_dir, :type => :string, :aliases => '-o', :banner => '/path/to/output_dir'
    option :template, :type => :string, :aliases => '-t', :banner => '/path/to/your_template.erb'
    option :filename_format, :type => :string, :aliases => '-n', :banner => 'date-name(default), name or id'
    option :filter, :type => :string, :aliases => '-f', :banner => 'markdown(default), none or /path/to/your_filter.rb'
    def convert(wp_xml_path)
      Wpconv::Converter.new.run(wp_xml_path, options)
    end
  end
end
