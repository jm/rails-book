# A Quick Start to Rails

Your first steps into the world of Ruby on Rails are always the most tentative, and that's what this chapter is all about.  We're going to show you from start to finish, how to get your first application up and running.  We'll gently walk you through each step ensuring you get the general idea, and return to the concepts we learn here in later chapters.

## Getting Up and Running, Quickly

I think the best way to start you off with Rails is to dive right in and get your first application up and running.  If you'd like to instead learn the concepts behind Rails then skip on ahead to Chapter 2 where we talk about how it all fits together, but for now, let's get Rails installed and fire out our first application so you can see how easy things are, and how beautiful the Ruby language is to work with.

### Mac OS X 10.4 Tiger

The first operating system we'll run you through is Mac OS X 10.4 Tiger, which is the predominant development environment for Ruby on Rails at this time, later on in the chapter we'll move on to other operating systems.
There are many different ways you can get going with Rails on Mac OS X, the simplest would be to use the Locomotive that you can download from [their site](http://locomotive.raaum.org/) which is a complete Ruby on Rails development environment in one easy to use application.  However, if you're looking for something more permanent I recommend the following approach. 

#### Installing Darwin Ports

"The DarwinPorts Project's main goal is to provide an easy way to install various open-source software products on the Darwin OS family (OpenDarwin, Mac OS X and Darwin)"  
This is the official documentation description of what Darwin Ports is.  What this means to us, is that we can install all the components we need to develop an application in Rails.  
The easiest way to get going with Darwin Ports is to download the Universal Binary installer and run it, which you can get from [DarwinPorts](http://darwinports.org/getdp/).  Once you've downloaded the image you need to mount it and run the installer within.  I assume you're on a clean install with the latest updates, which as I write this chapter is Mac OS X 10.4.7.
Open the Terminal application and prepare to get dirty.  We need to adjust our shell settings to use our new ports installed applications before it attempts to use the built in (usually broken) ruby version.

    $ sudo vi /etc/profile

You'll be prompted for your password and will be shown the content of the global profile configuration file.  Every time you open a terminal Mac OS X runs this to set up variables and globals that it will need.  We need to add our new Darwin ports installation directory /opt/local/bin to the beginning of the path so that the ports folder has priority over the default Mac OS X folder.
If you're not familiar with the vi editor, don't worry I'll run you through this bit in small steps.  There are different modes of use in vi, and we need to 'insert' into the file.

    Press i

Now we're in an editable mode which means anything you type is added to the file, find the line that begins with PATH and change it to look like this:

    PATH="/opt/local/bin:/bin:/sbin:/usr/bin:/usr/sbin"

That's the only change we need to make so we can go ahead and save the file now:

    Press Escape, then type :wq and press enter

The changes we've made don't take effect till we restart the Terminal, so do that now.  When we want to install something with Darwin Ports we use the port command, which pulls the source code for the application we want from an online repository and compiles it for our machines, not only is this the best way to optimize an application for your machine but it's really geeky too, so extra brownie points.  We need to first synchronise our repository with the remote ports directory.

    $ sudo port -d selfupdate

The port selfupdate command will get the most up to date list of applications we can install with port, and leave us ready to install them.  
>>Tip: The ports command is not just useful for Ruby on Rails.  If you need any unix program at any time in the future, you would be prudent to check whether ports has it using the port search application, because ports is maintained by those 'in the know' and they ensure the applications work so you don't have to.  You can also update your current ports using the port update application command to stay up to date.  Find out more info on the [Darwin Ports website](http://darwinports.org/).

#### Installing Ruby and Ruby Gems

We need to grab Ruby and Ruby Gems, which we can do with one command.

    $ sudo port install rb-rubygems

Accept all the dependencies and you should now have a working Ruby Gems installation.  As Ruby Gems doesn't work without Ruby, port knows to ask if you'd like to include it.  Now we can use Ruby Gems to install Rails, which is one of many useful gems you can download and install.  We'll look at more of those later in the book.

#### Installing Ruby on Rails

Type the following to install Rails:

    $ sudo gem install rails

Now we have Ruby on Rails installed we're ready to go!  But just wait a minute, how are we going to create database driven websites without a database?  So, let's get mysql which we'll use throughout the book for our examples as it's got the best support for GUI editing tools and is a mature product.  If you'd like to skip this bit and install PostGreSQL or SQLite or similar please feel free to.

#### Installing MySQL

It turns out that Darwin Ports has mysql as well, which makes life very easy for us.  There are a couple of optional steps but we'll get to those.

    $ sudo port install mysql4 +server

If you'd like MySQL to start automatically when Mac OS X installs we need to run another extra step.

    $ cd /opt/local/
    $ sudo bin/mysql_install_db --user=mysql
    $ sudo gem install mysql -- --with-mysql-config=/opt/local/bin/mysql_config

The port command installs MySQL and the gem command installs a module that lets Rails talk to it, without that you'd get lots of errors and a puzzled look on your face.  
On my development machines I rarely set a MySQL root password (The administrator user) because I sit behind a firewall and it is only available locally, but if you want to then run this:

    $ mysqladmin -u root password 'newpassword'

#### Installing the Mongrel Web Server

So we have everything we need to get cracking, Rails comes with its own built in web server (WEBrick) which is slow, but acceptable for development.  However, I prefer to install the mongrel web server written by Zed Shaw, purely because it's fast, is becoming the Rails server of choice and integrates nicely with Rails.

    $ sudo gem install mongrel

Okay, that's it, we're done.  Skip on ahead to the second part of this chapter where we dive head first into our first Rails application.  If you're a Windows or Linux user and you've read this section, then silly you, check the section for your operating system and we'll get you going too.

### Windows XP

I assume you're on XP Service Pack 2, purely because it's the latest, safest version at the time of writing.  We've got a couple of options on Windows, the quick and easy temporary solution, or the more permanent solution.  Whichever you pick is all down to preference, if you're just trying out Rails to see how it fits, then carry on with this section, otherwise skip on to option 2 and we'll get you a more permanent option.

#### Instant Satisfaction

[InstantRails](http://instantrails.rubyforge.org/wiki/wiki.pl) is a bundle of the applications you needed to run a Ruby on Rails site, but without any of the hassle of installing and and configuring the software yourself.  Installing is a simple matter of downloading the compressed zip file from their site and extracting it somewhere, I found the best results come from extracting it to the C drive directly and naming the directory InstantRails.
InstantRails comes with a MySQL database, Apache web server, PHP Database Manager (phpMyAdmin), Ruby and Ruby on Rails.  Your applications should be placed inside the rails_apps folder.  Once you're ready to go you can just double-click the InstantRails.exe file which is at the root of your extracted folder.  Try this out if you're only playing with Rails because it's a good start package and you can tinker to your hearts content.

#### Manual Installation

As with any operating system, there is a set of pre-requisites that you need before you can start developing, and it's mostly everything that comes with InstantRails with the added option of flexibility.  You can install whatever database engine you want, and choose your web server etc.  We'll be using MySQL 5 for the database engine and WEBrick for the web server.

#### Installing Ruby

For windows we can hop on over to the RubyForge project called [One-Click Installer](http://rubyforge.org/frs/?group_id=167) and grab the latest stable package for Ruby.  All you need to do is double click this file and you'll have a working Ruby binary installed and ready to go, and as an added bonus you also get a choice of 2 free editors with it (Scite or FreeRIDE).

#### Installing MySQL

MySQL kindly bundles their latest stable release as a 1 click installer for Windows on [their developer site](http://dev.mysql.com/downloads/mysql/5.0.html).  Download the latest stable Community release and double click the installer, you'll be presented with a list of options to fill in, just use the default typical install as this suits our need perfectly.  You don't need to sign up for a MySQL account but if you'd like to join the MySQL community please go ahead and sign up when the installer asks you.  Once you reach the option to configure your server, make sure that the option to do it now is filled in and we'll do that now.

Figure 1-1
![Figure 1-1](../screenshots/f0101.jpg)

Figure 1-1 shows we need to choose a standard configuration, this will save us from the scary details and just let us configure the most necessary options.

Figure 1-2
![Figure 1-2](../screenshots/f0102.jpg)

In Figure 1-2 we're asking MySQL to configure itself as a Windows Service (Which let's us use the Microsoft Management Console to configure the startup options and other useful commands), and we're adding the directory location of the MySQL utilities to the command line PATH variable, this means that when we open a console and type mysql (The commandline client to access your databases) that we won't be greeted with an error message.

Figure 1-3
![Figure 1-3](../screenshots/f0103.jpg)

Figure 1-3 is a choice you can change if you so desire, on my development machines I rarely enable network access and sit behind a firewall to the internet also, so the I don't need to secure my database server.  If you'd like a password for the root user account (Which is the super user for the database.  The Alpha, the Omega, the Ultimate, The One) then tick the top checkbox and fill in the fields, make sure you don't forget what you write down here.

Figure 1-4
![Figure 1-4](../screenshots/f0104.jpg)

Figure 1-4 just reviews what's about to happen, so go ahead and click Next.  If you happen to get an error message that says testing access to the service failed, then double check your Windows Firewall settings because it is probably blocking port 3306 and will need to be given an exception.

Figure 1-5
![Figure 1-5](../screenshots/f0105.jpg)

A successful installation is illustrated on Figure 1-5, hopefully you'll be here by now and so we're ready to install Ruby on Rails with the knowledge that our MySQL engine is sat waiting for us.

#### Installing Ruby on Rails

To install Ruby on Rails we use Ruby Gems that got installed when we used our one click installer in the first part of this section, open up your command prompt (Click Start and then Run, type cmd and press enter) then type:

    $ gem install rails --include-dependencies

This command can take some time, and sometimes looks like it's not doing anything because updating the index can take a while.  It gets an up to date list of available gems, and then proceeds to install Ruby on Rails from the online repository.  You should see some output like this:

    Bulk updating Gem source index for: http://gems.rubyforge.org
    Successfully installed rails-1.1.4
    Successfully installed activesupport-1.3.1
    Successfully installed activerecord-1.14.3
    Successfully installed actionpack-1.12.3
    Successfully installed actionmailer-1.2.3
    Successfully installed actionwebservice-1.1.4
    Installing ri documentation for activesupport-1.3.1...
    Installing ri documentation for activerecord-1.14.3...
    Installing ri documentation for actionpack-1.12.3...
    Installing ri documentation for actionmailer-1.2.3...
    Installing ri documentation for actionwebservice-1.1.4...
    Installing RDoc documentation for activesupport-1.3.1...
    Installing RDoc documentation for activerecord-1.14.3...
    Installing RDoc documentation for actionpack-1.12.3...
    Installing RDoc documentation for actionmailer-1.2.3...
    Installing RDoc documentation for actionwebservice-1.1.4...

Now we're all set and ready to start developing some funky Ruby on Rails applications!

### Linux

For the purposes of this book I've decided to show you how to get Ruby on Rails working on the Ubuntu Dapper Drake distribution of Linux.  Your experiences may be similar on other linux distributions, but I know this process to work on Ubuntu.
Ubuntu comes with the apt package manager, which is akin to the port installer for Mac OS X, it handles dependencies of the packages you ask to be installed, and uses an online repository to get the binary files from.  For Ubuntu, we need to get Ruby, and the Ruby Header files.  The Header files are used to build Ruby Gems which need to be manually downloaded and compiled against these header files.  Let's get started:

#### Installing Ruby

Step 1, we need to get the latest stable Ruby release that Ubuntu has, including the header files, and we need to get the RDoc release too.  RDoc is the application that takes commented source code and creates web pages out of it, for your viewing pleasure.  The online Ruby on Rails api documentation is the perfect example of this [here](http://api.rubyonrails.org/).

    $ sudo apt-get update
    $ sudo apt-get install ruby1.8, ruby1.8-dev, rdoc1.8, libruby1.8

This instructs apt to get the latest list of files that the online repository holds, and then requests Ruby, Ruby Header files, RDoc, and the Ruby library files.  If we'd have skipped of the libruby1.8 request we would have been prompted to include it, because apt is an intelligent little application and it know that Ruby depends on this library.  All we need to do now is link the filename that Ubuntu has used, with the typical ruby command, so we don't have to type ruby1.8 every time we want to use it.

    $ sudo ln -s /usr/bin/ruby1.8 /usr/bin/ruby

You can test that this is working by doing the following:  irb is the interactive Ruby shell, if this runs we know Ruby is installed correctly.

    $ irb
    irb(main):001:0>exit

#### Installing Ruby Gems

Ruby on Rails, and many of the additional extras you'll use in the future, are mostly controlled by the Ruby Gems package manager.  On Ubuntu we need to download this manually and compile it against the header files that we installed in the last step.  Using FireFox navigate to [the download site](http://rubyforge.org/frs/?group_id=126) and download the latest stable source, and extract the files within the download to a folder, we'll delete this later.  Open up a terminal at that folder and we can go ahead and compile Ruby Gems and then install Ruby on Rails.

    $ sudo ruby install.rb
    $ sudo gem install rails
  
As with the other installation sections, you're now ready to get going with Rails, however, you won't get far without a database.  Let's install MySQL 5 which will set us in good stead.

    $ sudo apt-get install libmysql-ruby1.8, mysql-server-5.0
  
To stop and start MySQL you need only run /etc/init.d/mysql start or /etc/init.d/mysql stop.  You can use any text editor of your choice to edit the Rails files, and use WEBrick to run the server.

### An Application Walk-Through

The best way to get an idea on how beautiful and fast Ruby on Rails development is, would be to start developing a standard blogging application.  We'll handle blog posts and comments, as well as show you the best practice way for dealing with your database table setup and maintenance.  We'll skip most of the details as we go through setting up this application, and focus more on the ins and outs later on.

#### Creating the application

Time to write our first application!  How about we create a simple blog, something that has become the norm for first Rails applications, so we'll use that.  The Ruby on Rails framework focuses on convention over configuration, which is a theme that you'll see running through the entire framework and our book.  The structure of the application is one of the conventions, and Rails creates our structure with a simple command:

    $ rails blog
    create
    create  app/controllers
    create  app/helpers
    create  app/models
    create  app/views/layouts
    ...

That's our Rails application created, next we'll be needing a database to store our blog posts in and we'll need to tell Rails where it is and how to access it.

    $ mysqladmin -u root -p create blog_development

You'll be prompted for your password if you have one, and then your new database will be created.  Now let's tell Rails which database to use.  Be careful within YAML files (ending in .yml), don't use tab characters anywhere, only spaces.  Each line should be only indented by 2 spaces.

File: config/database.yml

    development:
      adapter: mysql
      database: blog_development
      username: root
      password: 
      host: localhost

    test:
      adapter: mysql
      database: blog_test
      username: root
      password:
      host: localhost

    production:
      adapter: mysql
      database: blog_production
      username: root
      password: 
      host: localhost

>>Test: It's important to also create your test database and configure the database.yml to point to it, as you'll discover in later chapters, testing saves your bacon.

Now start the built in WEBrick web server by running ruby ./script/server from the root of your application folder, and open your web browser at http://localhost:3000/ and you'll see the default rails page that shows everything is working as intended, see Figure 1.6.

Figure 1.6
![Figure 1-6](../screenshots/f0106.jpg)

Obviously that's no use to us, so let's not waste any time at all, and we'll fire in and edit the files.  Don't worry if you don't understand why or what we're doing, just follow the instructions and you'll end up with an application and a basic understanding of the overall development process in Rails.
We'll start using the Rails generators now, firstly we need a model to handle our posts.  The model uses ActiveRecord to interact with our database, in this case the posts table which we need to create.

#### Generating the Post Model

      $ ruby ./script/generate model Post
      exists  app/models/
        exists  test/unit/
        exists  test/fixtures/
        create  app/models/post.rb
        create  test/unit/post_test.rb
        create  test/fixtures/posts.yml
        create  db/migrate
        create  db/migrate/001_create_posts.rb

This generated the files we needed for our model, and created a migration file for us to create the table in our database.

File: db/migrate/001\_create\_posts.rb

    class CreatePosts < ActiveRecord::Migration
      def self.up
        create_table :posts do |t|
          t.column :title, :string
          t.column :body, :text
          t.column :created_at, :datetime
        end
      end

      def self.down
        drop_table :posts
      end
    end

Edit the migration to take into account the changes in bold, these commands tell our next command (rake) to change our database in some way, in this case we're creating a posts table with title, body and string columns.

Run the migration

    $ rake migrate
    == CreatePosts: migrating ============================================
    -- create_table(:posts)
     -> 0.0350s
    == CreatePosts: migrated (0.0352s) ======================================

Now if you check inside your database, you'll see that we've created a new table called posts to store our blog posts.  Now all we need is a controller with actions to do things to our posts table, we'll need to list posts, add posts, edit posts and of course delete posts.

Create the basic CRUD

    $ ruby ./script/generate scaffold Post Blog
        exists  app/controllers/
        exists  app/helpers/
        create  app/views/blog
        exists  test/functional/
    dependency  model
        exists    app/models/
    ...

This simple command has done everything we just talked about, a scaffold is a simple way of creating create/read/update/delete (CRUD) methods in one step.  It's frowned upon among the more advanced developers generally, but I think you can agree that it's not an operation to be ignored when time is of the essence.  We'll show you how to create your own generators later in the book, thus increasing your productivity exponentially.  Open your browser and navigate to [http://localhost:3000/blog/](http://localhost:3000/blog/) and you'll see the fruits of our efforts.  

Figure 1.7
![Figure 1-7](../screenshots/f0107.jpg)

Figure 1.8
![Figure 1-8](../screenshots/f0108.jpg)

Figure 1.9
![Figure 1-9](../screenshots/f0109.jpg)

Figure 1.10
![Figure 1-10](../screenshots/f0110.jpg)

As you can see in Figure 1.7 we have a basic layout, which is editable within the app/views/blog folder along with the other actions views.  Figure 1.8 shows me adding a post, again all this is added for us with the one scaffold generator.  Figure 1.9 follows on from the last and illustrates another 'freebie' that Rails gives you, which are flash messages, a way of informing the user of anything you'd like, the scaffold includes the default messages after adding, deleting, or editing any posts.  Finally Figure 1.10 shows the listing again with our new post, if you check your database manually after any of these processes you'll see the changes are real, and not some voodoo trickery.

>>Note: I leave it as an exercise for you to edit the app/views/blog/\_form.rhtml file and remove the part which allows the user to edit the created\_at field, this highlights one of the automatic 'bonus' features of rails, if you have a database column in any of your tables called created\_at or updated\_at, and you don't explicitly set the value, then rails will set it automatically to the date the records was saved.  More about this later.

#### Adding Comments

What use are blog posts if you can't get feedback from your readers, though?  Let's add comments to this application and see more of the magic that Rails gives you in the form of model relationships.

Generate the Comment Model

    $ ruby ./script/generate model Comment
        exists  app/models/
        exists  test/unit/
        exists  test/fixtures/
        create  app/models/comment.rb
        create  test/unit/comment_test.rb
        create  test/fixtures/comments.yml
        exists  db/migrate
        create  db/migrate/002_create_comments.rb
        
Again, we see that all are files are created for us, and a skeleton migration file so we can adjust our database tables to accommodate this new model.

File: db/migrate/002_create_comments.rb

    class CreateComments < ActiveRecord::Migration
      def self.up
        create_table :comments do |t|
          t.column :name, :string
          t.column :body, :text
          t.column :created_at, :string
          t.column :post_id, :integer
        end
      end

      def self.down
        drop_table :comments
      end
    end

Run the migration

    $ rake migrate

We now have a comments table to keep track of feedback, now we need to associate the posts with our new comments so Rails knows there is a link between them, because when it knows there is a link it creates even more voodoo magic for us.  Don't worry, all this voodoo magic is explained in later chapters and is completely de-mystified, but let's live in our fanatasy world for a little longer.  Edit the following files to look like:

File: app/models/post.rb

    class Post < ActiveRecord::Base
      has_many :comments
    end
    File: app/models/comment.rb
    class Comment < ActiveRecord::Base
      belongs_to :post
    end

#### Edit the Views

Makes sense doesn't it?  A post has many comments, and a comment belongs to a post.  This is more than a simple note to us that there is a relationship, it's also an instruction to Rails letting it know how to handle the link between the two.  We need to edit the post pages to include our new comments section, so go ahead and add the following to the bottom of the blog show view:

File: app/views/blog/show.rhtml

    <h2>Comments</h2>
    <% @post.comments.each do |comment| %>
    	<%= comment.name %><br />
    	<%= comment.body %>
    	<hr />
    <% end %>

    <%= start_form_tag :action => "comment", :id => @post %>
    	<%= text_field "comment", "name" %><br />
    	<%= text_area "comment", "body" %><br />
    	<%= submit_tag "Add Comment" %>
    <%= end_form_tag %>

File: app/controllers/blog_controller.rb

    def comment
      Post.find(params[:id]).comments.create(params[:comment])
      flash[:notice] = "Your comment was sucessfully added"
      redirect_to :action => "show", :id => params[:id]
    end

After adding these bits to our rails app we have allowed users to comment on our posts, and if you take your browser to the show post page, you'll be presented with a new comment field that you can fill in, like in Figure's 1.11 and 1.12.

Figure 1.11
![Figure 1-11](../screenshots/f0111.jpg)
Figure 1.12
![Figure 1-12](../screenshots/f0112.jpg)

By now you should have a general idea of the ease and magic that Rails gives you, as well as a look of confusion as we fired through our first application.  The following chapters take you through using Rails in a practical and best practise manner, as well as giving you comprehensive knowledge on the framework itself.  Some of the concepts and methodologies are a little daunting to those new to object orientated languages, and especially troublesome to those coming from scripting languages that have given you plenty of rope to get into some pretty dirty habits.  We're going to mould you into a test driven happy developer, and explain how and why as we go.  Good luck!