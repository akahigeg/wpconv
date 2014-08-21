require 'nokogiri'
require 'erb'

require 'wpconv/filter/markdown'
require 'wpconv/wp_xml/channel'
require 'wpconv/wp_xml/item'

module Wpconv
  class Converter
    def run(wp_xml_path, options = {})
      doc = ::Nokogiri::XML(File.open(wp_xml_path).read)
      # TODO: ファイルが存在しない or 読み込めない場合の処理

      channel = doc.at('channel')

      erb = File.open('template/nanoc_markdown.erb') {|f| ERB.new(f.read)}

      output_dir = '/tmp/posts'
      FileUtils.mkdir_p(output_dir)

      items = doc.search('item')
      items.each do |doc_item|
        item = WpXML::Item.parse(doc_item)

        # filter
        item[:content] = Filter::Markdown.apply(item[:content])

        # output
        converted =  erb.result(binding)
        filename = "#{item[:post_id]}.md"

        File.open(File.join(output_dir, filename), "w") do |f|
          f.write(converted)
        end
      end

      # TODO: テンプレート指定
      # TODO: 1つのファイルにまとめる => :text
      # TODO: カテゴリーとタグの扱い
      # TODO: ファイル出力 ファイル名指定
      # TODO: 出力ディレクトリ指定
      # TODO: ページとポストの区別
      # TODO: Markdownフィルター
      # TODO: オプションのデフォルト: 出力ディレクトリ、ファイル名、テンプレート
      # TODO: フィルターの指定
    end
  end

end
