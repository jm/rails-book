module Markdown
  class HTMLizer
    def initialize
      files = Dir.open("markdown/").sort
      @last_chapter = files.pop.gsub("chapter_", "").gsub(".markdown", "").to_i
      
      print "Generating chapter HTML..."
      chapters_to_html
      print "done.\n"
      
      print "Generating index..."
      make_index
      print "done.\n"
    end
    
    # TODO: Read chapter names and descriptions from a YAML file or something
    def chapters_to_html
      (1..@last_chapter).each do |chapter|
        `touch html/chapter#{chapter}.html; cat static/head.html >> html/chapter#{chapter}.html`
        `./bin/MultiMarkdown.pl markdown/chapter_#{chapter}.markdown | ./bin/SmartyPants.pl >> html/chapter#{chapter}.html`
        `cat static/foot.html >> html/chapter#{chapter}.html`
      end
    end
    
    def make_index
      File.open("html/index.html", "w+") do |index|
        index.write File.open("static/head.html").read
        
        index.write '<h1>Getting Started with Rails</h1>'
        
        (1..@last_chapter).each do |chapter|
          index.write("<a href='chapter#{chapter}.html'>Chapter #{chapter}</a><br>\n")
        end
        
        index.write File.open("static/foot.html").read
      end
    end
  end
end