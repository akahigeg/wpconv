# Wpconv

Converting Wordpress export XML to Markdown(or other format).

## Installation

    $ gem install wpconv

## Usage

    wpconv convert WP_XML_PATH

    Options:
      -o, [--output-dir=/path/to/output_dir]                
      -t, [--template=/path/to/custom_template.erb]         
      -n, [--filename-format=date-name(default), name, id]  
      -f, [--filter=/path/to/custom_filter.rb]    

example:

    $ wpconv convert wordpress.2014-08-21.xml -o /tmp -n id

This example command creates Markdown files from Wordpress export XML.
The output directory is /tmp and the output filenames are based on Wordpress post_id.

`-o` is option to specify the output direcoty.

`-n` is option to specify the format of filename.

`-t` and `-f` are advansed options to customize output. If you would like to use these options, you should write erb template or ruby script code.
See templating and filter sections for more details.

## Templating

You can create a custom erb template to adjust outputs as you like.

`@item` and `@channel` are available for template valiables.
These are Hash objects storing data.

Specify `-t` option if you would like to use your template.

    $ wpconv convert wordpress.2014-08-21.xml -o /tmp -t my_markdown.md.erb

## Filter

You can use filter for a camplicate converting logic.
Filter affects content of items.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/wpconv/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
