# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Wpconv::Filter::Markdown do
  describe "converting HTML tags" do
    describe "heading" do
      it "h1" do
        content = Wpconv::Filter::Markdown.apply("<h1>hoge</h1>")
        expect(content).to eq "# hoge"
      end

      it "h6" do
        content = Wpconv::Filter::Markdown.apply("<h6>hoge</h6>")
        expect(content).to eq "###### hoge"
      end

      it "h3(multiline)" do
        content = Wpconv::Filter::Markdown.apply("<h3>ho\nge</h3>")
        expect(content).to eq "### hoge"
      end
    end

    describe "list" do
      it "ul" do
        content = Wpconv::Filter::Markdown.apply("<ul>")
        expect(content).to eq ""
      end

      it "/ul before LF" do
        content = Wpconv::Filter::Markdown.apply("</ul>\n")
        expect(content).to eq ""
      end

      it "ul > li*" do
        content = Wpconv::Filter::Markdown.apply("<ul><li>hoge</li>\n<li>fuga</li></ul>")
        expect(content).to eq "* hoge\n* fuga"
      end

      it "ul > li(multiline)" do
        content = Wpconv::Filter::Markdown.apply("<ul><li>ho\nge</li>")
        expect(content).to eq "* ho\nge"
      end
    end

    describe "hr" do
      it "hr" do
        content = Wpconv::Filter::Markdown.apply("<hr>")
        expect(content).to eq "\n---\n"
      end

      it "hr/" do
        content = Wpconv::Filter::Markdown.apply("<hr/>")
        expect(content).to eq "\n---\n"
      end

      it "hr /" do
        content = Wpconv::Filter::Markdown.apply("<hr />")
        expect(content).to eq "\n---\n"
      end
    end

    describe "pre and code" do
      it "pre and code" do
        content = Wpconv::Filter::Markdown.apply("<pre><code>hoge\nfuga</code></pre>")
        expect(content).to eq "    hoge\n    fuga"
      end

      it "pre and code with class" do
        content = Wpconv::Filter::Markdown.apply("<pre><code class='text'>hoge\nfuga</code></pre>")
        expect(content).to eq "    hoge\n    fuga"
      end

      it "pre and code  < > &" do
        content = Wpconv::Filter::Markdown.apply("<pre><code>&lt;hoge&gt; &amp; &lt;fuga&gt;</code></pre>")
        expect(content).to eq "    <hoge> & <fuga>"
      end

      it "only pre" do
        content = Wpconv::Filter::Markdown.apply("<pre class='text'>hoge\nfuga</pre>")
        expect(content).to eq "<pre class='text'>hoge\nfuga</pre>"
      end

      it "code" do
        content = Wpconv::Filter::Markdown.apply("a <code class='text'>hoge\nfuga</code> z")
        expect(content).to eq "a `` hoge\nfuga `` z"
      end

      it "decode < > &" do
        content = Wpconv::Filter::Markdown.apply("<code class='text'>&lt;hoge&gt; &amp; &lt;fuga&gt;</code>")
        expect(content).to eq "`` <hoge> & <fuga> ``"
      end
    end

    describe "blockquote" do
      it "blockquote" do
        content = Wpconv::Filter::Markdown.apply("<blockquote>hoge\nfuga</blockquote>")
        expect(content).to eq "> hoge\n> fuga"
      end
    end

    describe "em/strong/b" do
      it "em" do
        content = Wpconv::Filter::Markdown.apply("<em>hoge</em>")
        expect(content).to eq "*hoge*"
      end

      it "em(multiline)" do
        content = Wpconv::Filter::Markdown.apply("<em>hoge\nfuga</em>")
        expect(content).to eq "*hoge\nfuga*"
      end

      it "strong" do
        content = Wpconv::Filter::Markdown.apply("<strong>hoge</strong>")
        expect(content).to eq "**hoge**"
      end

      it "b" do
        content = Wpconv::Filter::Markdown.apply("<b>hoge</b>")
        expect(content).to eq "**hoge**"
      end
    end

    describe "link" do
      it "a" do
        content = Wpconv::Filter::Markdown.apply("<a href='http://www.example.com/hoge/' target='_blank'>hoge</a>")
        expect(content).to eq "[hoge](http://www\\.example\\.com/hoge/)"
      end

      it "LF in anchor text" do
        content = Wpconv::Filter::Markdown.apply("<a href='http://www.example.com/hoge/' target='_blank'>ho\nge</a>")
        expect(content).to eq "[ho\nge](http://www\\.example\\.com/hoge/)"
      end
    end
  end

  describe "escaping literal" do
    # %w(\\ ` * _ { } [ ] \( \) # + - . !)
    describe "for escaped character" do
      it '*' do
        content = Wpconv::Filter::Markdown.apply("h*ge")
        expect(content).to eq 'h\*ge'
      end

      it '_' do
        content = Wpconv::Filter::Markdown.apply("_hoge_")
        expect(content).to eq '\_hoge\_'
      end
    end
  end
end
