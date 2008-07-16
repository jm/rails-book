# TODO: Run a filter over the Markdown to syntax highlight

require 'bin/multimarkdown2multihtml'

require 'rake/clean'
CLEAN.include("tmp/")

CLOBBER.include("pdf/")
CLOBBER.include("html/")
CLOBBER.include("latex/")

def html2pdf
  print "Checking for htmldoc installation..."
  
  if system('htmldoc --version')
    `mkdir tmp; mkdir pdf`
    print "Generating HTML..."
    `./bin/MultiMarkdown.pl markdown/* | ./bin/SmartyPants.pl > tmp/book.intermediate`
    `touch tmp/book.html; cat static/head.html >> tmp/book.html`
    `cat tmp/book.intermediate >> tmp/book.html; cat static/foot.html >> tmp/book.html`
    print "done.\n"
    print "Generating PDF with htmldoc..."
    `htmldoc -t pdf14 tmp/book.html > pdf/getting_started_with_rails.pdf`
    print "done.\n"
    print "Cleaning up..."
    `rm -rf tmp`
    print "done.\n"
  else
    puts "You need to have htmldoc (http://www.htmldoc.org/) installed to generate a PDF!"
  end
end

def latex2pdf
  print "Checking for latex installation..."
  
  if system('which pdflatex')
    `mkdir tmp; mkdir pdf`
    print "Generating LaTeX source..."
    
    `touch tmp/book.intermediate`
    files = Dir.open("markdown/").sort
    files.each do |markdown|
      `cat markdown/#{markdown} >> tmp/book.intermediate` if markdown.include?(".markdown")
    end
    
    `./bin/multimarkdown2latex.pl tmp/book.intermediate > tmp/book.latex`
    print "done\n."
    print "Generating PDF file..."
    `cd tmp; pdflatex book.latex; cd ..`
    `cp tmp/book.pdf pdf/getting_started_with_rails.pdf`
    print "done.\n"
    print "Cleaning up..."
    `rm -rf tmp`
    print "done.\n"
  else
    puts "You need to have LaTeX installed to generate a LaTeX PDF!"
  end
end

def single_html
  `mkdir tmp; mkdir html`
  print "Generating HTML..."
  `./bin/MultiMarkdown.pl markdown/* | ./bin/SmartyPants.pl > tmp/book.intermediate`
  `touch html/getting_started_with_rails.html; cat static/head.html >> html/getting_started_with_rails.html`
  `cat tmp/book.intermediate >> html/getting_started_with_rails.html; cat static/foot.html >> html/getting_started_with_rails.html`
  `cp static/style.css html/`
  print "done.\n"
  print "Cleaning up..."
  `rm -rf tmp`
  print "done.\n"
end

def multi_html
  `mkdir html`
  Markdown::HTMLizer.new
end

def markdown2latex
  `mkdir tmp; mkdir latex`
  print "Generating LaTeX source..."
  `./bin/multimarkdown2latex.pl markdown/* > latex/book.latex`
  print "done.\n"
end

namespace :output do
  
  namespace :pdf do
    desc "Generate a PDF from the XHTML generated from the book's Markdown source."
    task :html do
      html2pdf
    end
    
    desc "Generate a PDF from LaTeX source generated from the book's Markdown source."
    task :latex do
      latex2pdf
    end
  end

  namespace :html do
    desc "Generate a single HTML page from the book's source."
    task :single do
      single_html
    end

    desc "Generate a multi-page HTML project from the book's source."
    task :multi do
      multi_html
    end
  end
  
  desc "Generate a LaTeX file from the book's Markdown source."
  task :latex do
    markdown2latex
  end
  
end

desc "Build (nearly) everything: PDF from LaTeX, single and multi-file HTML, and LaTeX sources"
task :build do
  puts "*** Making PDF from LaTeX..."
  latex2pdf
  
  puts "*** Building single file HTML..."
  single_html
  
  puts "*** Building multi-file HTML..."
  multi_html
  
  puts "*** Building LaTeX sources..."
  markdown2latex
end
