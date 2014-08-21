require 'thor'
require 'readline'

module Wpconv
  class CLI < Thor
    desc "convert WP_XML_PATH", "convert wordpress export xml to markdown."
    def convert(wp_xml_path)
      Wpconv::Converter.new.run(wp_xml_path)
    end
  end
end
