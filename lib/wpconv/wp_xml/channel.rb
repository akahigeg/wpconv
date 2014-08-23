module Wpconv
  module WpXML
    class Channel
      def self.parse(doc_channel)
        {}.tap do |channel|
          %w(title link description pubDate language).each do |key|
            if node = doc_channel.at(key)
              channel[key.to_sym] = node.text
            end
          end

          %w(wxr_version base_site_url base_blog_url).each do |key|
            if node = doc_channel.at("wp|#{key}")
              channel[key.to_sym] = node.text
            end
          end

          # author
          channel[:authors] = [].tap do |authors|
            doc_channel.search("wp|author").each do |author|
              authors.push({
                id: author.at("wp|author_id").text,
                login: author.at("wp|author_login").text,
                email: author.at("wp|author_email").text, 
                name: author.at("wp|author_display_name").text,
                first_name: author.at("wp|author_first_name").text,
                last_name: author.at("wp|author_last_name").text
              })
            end
          end

          # category and tag
          channel[:categories] = [].tap do |categories|
            doc_channel.search("wp|category").each do |cat|
              categories.push({
                id: cat.at("wp|term_id").text,
                name: cat.at("wp|cat_name").text, 
                nickname: cat.at("wp|category_nicename").text,
                parent: cat.at("wp|category_parent").text
              })
            end
          end

          channel[:tags] = [].tap do |tags|
            doc_channel.search("wp|tag").each do |tag|
              tags.push({
                id: tag.at("wp|term_id").text,
                name: tag.at("wp|tag_name").text, 
                slug: tag.at("wp|tag_slug").text
              })
            end
          end
        end
      end
    end
  end
end
