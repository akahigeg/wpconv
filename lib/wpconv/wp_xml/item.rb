module Wpconv
  module WpXML
    class Item
      def self.parse(doc_item)
        hashed_item = {}
        %w(title link pubDate guid description).each do |key|
          if node = doc_item.at(key)
            hashed_item[key.to_sym] = node.text
          end
        end
  
        hashed_item[:creator] = doc_item.at('dc|creator').text
        hashed_item[:content] = doc_item.at('content|encoded').text
        hashed_item[:excerpt] = doc_item.at('excerpt|encoded').text
  
        %w(post_id post_date post_date_gmt comment_status ping_status post_name status post_parent menu_order post_type post_password is_sticky).each do |key|
          if node = doc_item.at("wp|#{key}")
            hashed_item[key.to_sym] = node.text
          end
        end
  
        hashed_item[:categories] = []
        hashed_item[:tags] = []
        doc_item.search('category').each do |cat|
          case cat["domain"] 
          when 'category'
            hashed_item[:categories].push cat.text
          when 'post_tag'
            hashed_item[:tags].push cat.text
          end
        end
  
        hashed_item[:postmeta] = {}
        doc_item.search('wp|postmeta').each do |meta|
          hashed_item[:postmeta][meta.at('wp|meta_key').text.to_sym] = meta.at('wp|meta_value').text
        end
  
        hashed_item
      end
    end
  end
end