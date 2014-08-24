# Wpconv

Converting Wordpress export XML to Markdown(or other format).

## Installation

    $ gem install wpconv

## Usage

    wpconv convert WP_XML_PATH

    Options:
      -o, [--output-dir=/path/to/output_dir]                             
      -t, [--template=/path/to/your_template.erb]                        
      -n, [--filename-format=date-name(default), name or id]             
      -f, [--filter=markdown(default), none or /path/to/your_filter.rb]  

example:

    $ wpconv convert wordpress.2014-08-21.xml -o /tmp -n id

This example creates Markdown files from Wordpress export XML.
The output directory is /tmp and the output filenames are based on Wordpress post_id in this case.

`-o` is to specify the output direcoty.

`-n` is to specify the format of filename.

`-t` and `-f` are advanced options to customize output. If you would like to use these options, you should write an erb template or some ruby code.
See templating and filter sections for more details.

## Templating

You can create a custom erb template to adjust outputs as you like.

template valiables `@item` and `@channel` are available.
These are Hash objects including wordpress items and channel data.

Specify `-t` option if you would like to use your template.

    $ wpconv convert wordpress.2014-08-21.xml -o /tmp -t my_markdown.erb

This is the default template for your information.

    ---
    title:  <%= @item[:title] %>
    date:   <%= @item[:post_date] %>
    layout: <%= @item[:post_type] %>
    categories: [<%= @item[:categories].join(',') %>]
    tags: [<%= @item[:tags].join(',') %>]
    ---
    
    <%= @item[:content] %>

## Filter

You can use a custom filter for a camplicate converting logic.
A filter affects @item[:content].

You should write some ruby code for creating a custom filter.

The example below is a built in filter 'none'.
All filter classes should be under `Wpconv::Filter` module. And the class name should be the camelized file name.

    module Wpconv
      module Filter
        class None
          def self.apply(source_content)
            source_content
          end
        end
      end
    end

Another example, creating 'my_filter'.

    module Wpconv
      module Filter
        class MyFilter
          def self.apply(source_content)
            source_content.tap do |content|
              content.gsub!(/foo/, 'bar')
 
              # write the filter logic here...
 
            end
          end
        end
      end
    end

Specify `-f` option if you would like to use your filter.

    $ wpconv convert wordpress.2014-08-21.xml -o /tmp -f my_filter.rb

## Contributing

1. Fork it ( https://github.com/[my-github-username]/wpconv/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
