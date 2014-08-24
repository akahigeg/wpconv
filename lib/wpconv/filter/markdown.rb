require 'nokogiri'

module Wpconv
  module Filter
    class Markdown
      # see. http://daringfireball.net/projects/markdown/syntax

      BackslashEscapedCharacters = %w(\\ ` * _ { } [ ] \( \) # + - . !) 

      def self.apply(source_content)
        escaped_source_content = escape_literal(source_content)
        convert_html_tags(escaped_source_content)
      end

      def self.escape_literal(source_content)
        html = Nokogiri::HTML(source_content)
        source_content.tap do |content|
          BackslashEscapedCharacters.each do |char|
            content.gsub!(char) { "\\#{char}" }
          end
        end
      end

      def self.convert_html_tags(escaped_source_content)
        escaped_source_content.tap do |content|
          # Heading
          {
            'h1' => '#',
            'h2' => '##',
            'h3' => '###',
            'h4' => '####',
            'h5' => '#####',
            'h6' => '######'
          }.each do |tag, md|
            content.gsub!(/<#{tag}>(.+?)<\/#{tag}>/m) { "#{md} #{$1.gsub(/\n/, '')}" }  # remove LF in the header string
          end
  
          # List 定義リストは未サポート
          %w(ul ol).each do |tag|
            content.gsub!(/<\/?#{tag}>[\n]?/, '') # remove LF after the tag
          end
          content.gsub!(/[ \t]*?<li.*?>(.+?)<\/li>[ \t]*?/m) { "* #{$1.strip}" } # 数値リストも未対応
  
          # hr
          content.gsub!(/<hr\s?\/?>/, "\n---\n")
  
          # pre and code 
          content.gsub!(/<pre.*?><code.*?>(.*?)<\/code><\/pre>/m) { "#{decode_markup_symbol($1).gsub(/^/, '    ')}" }

          # code
          content.gsub!(/<code.*?>(.*?)<\/code>/m) { '`` ' + decode_markup_symbol($1) + ' ``' }
  
          # brockquote
          content.gsub!(/<blockquote>(.*?)<\/blockquote>/m) { "#{$1.gsub(/^/, '> ')}" }

          # em
          content.gsub!(/<em>(.*?)<\/em>/m) { "*#{$1}*" }
  
          # strong, b
          ["strong", "b"].each do |tag|
            content.gsub!(/<#{tag}>(.*?)<\/#{tag}>/m) { "**#{$1}**" }
          end
  
          # Link
          content.gsub!(/<a.*?href=("|')(.+?)("|').*?>(.+?)<\/a>/m) { "[#{$4}](#{$2})" }

          # Image
  
          # Table?
        end

      end

      def self.decode_markup_symbol(code)
        code.gsub('&lt;', '<').gsub('&gt;', '>').gsub('&amp;', '&')
      end
    end
  end
end
