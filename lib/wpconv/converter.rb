require 'nokogiri'
require 'erb'
require 'active_support/all'

require 'wpconv/filter/markdown'
require 'wpconv/filter/none'

require 'wpconv/wp_xml/channel'
require 'wpconv/wp_xml/item'

module Wpconv
  class Converter
    DEFAULT_OPTIONS = {
      output_dir: Dir.pwd,
      template: File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'template', 'markdown.erb')),
      filename_format: 'date-name',
      filter: 'markdown'
    }
    BUILT_IN_FILTERS = ['markdown', 'none']

    def run(wp_xml_path, options = {})
      @wp_xml_path = wp_xml_path

      @template = options[:template] || DEFAULT_OPTIONS[:template]
      erb = File.open(@template) {|f| ERB.new(f.read)}

      @output_base_dir = options[:output_dir] || DEFAULT_OPTIONS[:output_dir]
      setup_output_dirs

      @filename_format = options[:filename_format] || DEFAULT_OPTIONS[:filename_format]

      @filter = options[:filter] || DEFAULT_OPTIONS[:filter]

      print "converting...\n"
      print_convert_settings

      doc = ::Nokogiri::XML(File.open(@wp_xml_path).read)
      @channel = WpXML::Channel.parse(doc.at('channel'))

      doc.search('item').each do |doc_item|
        @item = WpXML::Item.parse(doc_item)

        # filter
        if not BUILT_IN_FILTERS.include?(@filter)
          @filter = "./#{@filter}" if not @filter =~ /\//
          require @filter
        end
        filter_class_name = File.basename(@filter).sub(/.rb$/, '').camelize
        @item[:content] = eval("Filter::#{filter_class_name}.apply(@item[:content])")

        # output
        File.open(File.join(item_output_dir, item_filename), "w") do |f|
          converted =  erb.result(binding)
          f.write(converted)
        end
      end

      print "done.\n"
    end

    def setup_output_dirs
      @output_dirs = {
        page: File.join(@output_base_dir, 'pages'),
        post: File.join(@output_base_dir, 'posts'),
        other: File.join(@output_base_dir, 'others')
      }
      @output_dirs.each do |k, output_dir|
        FileUtils.mkdir_p(output_dir)
      end
    end

    def item_filename
      post_name = @item[:post_name] == '' ? @item[:post_id] : @item[:post_name]
      case @filename_format
      when 'date-name'
        "#{@item[:post_date].split(' ').first}-#{post_name}.md"
      when 'name'
        "#{post_name}.md"
      when 'id'
        "#{@item[:post_id]}.md"
      else
        "#{@item[:post_id]}.md"
      end
    end

    def item_output_dir
      case @item[:post_type]
      when 'post'
        @output_dirs[:post]
      when 'page'
        @output_dirs[:page]
      else
        @output_dirs[:other]
      end
    end

    def print_convert_settings
      print "  soruce: #{@wp_xml_path}\n"
      print "  template: #{@template}\n"
      print "  output_dir: #{@output_base_dir}\n"
      print "  filename_format: #{@filename_format}\n"
      print "  filter: #{@filter}\n"
    end

    def default_template
      File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'template', 'markdown.erb'))
    end

    def default_filename_format
      'date-name'
    end

    def default_filter
      'markdown'
    end
  end

end
