# Active Record

Rails is a web-framework for database driven web development. Naturally a large part of working with Rails is working with your database of choice. This chapter introduces you to the basic and intermediate techniques used most often with Rails and databases. 
The Active Record module drives all database related actions in Rails. It was named after a design pattern described by Martin Fowler. In its essence Active Record represents relational data from databases in an object-relational manner. 

## Creating a database connection

Before we can start to communicate with the database we'll need to do a tiny little bit of configuration. Open up your database.yml located in config/database.yml. This file specifies your databases that you'll use to develop, test and deploy on. Rails assumes wisely that you want separate environments for these and conveniently creates stubs for you to edit. 

Assuming you've followed along the installation in chapter 1 you ended up with something similar like this. Fill the username and password bits. Make sure you've created a database called blog\_developement and blog\_test. Don't worry about blog_production just now.

    development:
      adapter: mysql
      database: blog_development
      username: blog_dev
      password: myblog
      host: localhost

    test:
      adapter: mysql
      database: blog_test
      username: blog_test
      password: myblog
      host: localhost

    production:
      adapter: mysql
      database: blog_production
      username: blog
      password: 
      host: localhost

That's it. That's the entire configuration you need to connect to your database. No handcoding connection details after this. The conventions used here are in the naming of the databases like _development and _test. Rails assumes these make sense and in fact they do. You'll see what to do with the test database in a bit.

## Introducing Object-Relational Modeling

Rails a database driven web framework and at its heart lies the Active Record module. Whenever Rails communicates with a database it does so through Active Record. Since I'll be talking about Active Record a lot in this chapter I'll use the abbreviation 'AR' to refer to the module.

When your about to develop in Rails you'll normally want to model some sort of things from the real world in your code. With Rails you start doing this in models. A model could be a Person or a Song for instance. Since you want to store these things we'll have tables named after them like 'persons' or 'songs.

Take note of the pluralization. Models i.e. Ruby classes are singular while their corresponding tables are plural. A table then maps to a model, which in Rails is a simple class. For instance the class belonging to the persons table looks like this:

    class Person < ActiveRecord::Base
    end

Its corresponding table might look a bit like this (simplified):

    create table persons (
      id int(11) autoincrement
      first_name varchar2(255)
      addresss varchar2(255)
    )

In order to get to a single person which is a row in your table you would instantiate from that class to create a  person:

    jamis = Person.new

'jamis' is now a new person who's attributes have been set by ActiveRecord to the columns defined in the table that holds 'jamis':

    jamis.first_name
    jamis.address

Important to note here is that Rails makes a couple of assumptions you should be aware of. These conventions have been put in to place because they make sense most of the times. 

1. Every table has an 'id' column that auto increments 
2. The 'id' column is the primary key for the table
3. Tables names are plurals of their singular named models or classes


These are conventions and yes, you can override them. But you will see that to go with the flow and accept the conventions or constraints (depending on your point of view) are in fact rather liberating.

This is what object relational modeling gets down to in Rails. Classes map to table, rows map to objects (in other words instantiations of classes) and attributes map to columns and finally, there are some conventions you need to be aware of. How this all works out is the subject of this chapter.

## Getting started with Active Record

Let's dive right in a create a model. Say we're building a blog and we want to model a blog post. We could name it Post, but that would be confusing when we're about to post posts. So I'll name Article. Rails ships with a generator to create the model stubs for us. Execute the following:

    $ script/generate model Article
          exists  app/models/
          exists  test/unit/
          exists  test/fixtures/
          create  app/models/article.rb
          create  test/unit/article_test.rb
          create  test/fixtures/articles.yml
          create  db/migrate
          create  db/migrate/001_create_articles.rb

The generator created a couple of files for us. The actual model itself is in app/models/article.rb where you would expect it. But before we start with going into that let's first open up db/migrate/001\_create\_articles.rb

    class CreateArticles < ActiveRecord::Migration
      def self.up
        create_table :articles do |t|
          # t.column :name, :string
        end
      end

      def self.down
        drop_table :articles
      end
    end

The file you're looking at is an AR Migration and this is where you'll start all of your modeling endeavors. 

## Evolving your Schema with Migrations

AR Migrations allow you to change your database model over time while keeping track of the changes you make. So you can roll them back or roll forward to upgrade your model. 

Furthermore, instead of writing SQL to create tables and indexes you'll write Ruby code to create these for you. You'll appreciate the ease of use once you get started with migrations. We need an articles table to hold our articles. Modify the CreateArticles class like this:

    class CreateArticles < ActiveRecord::Migration
      def self.up
        create_table :articles do |t|
          t.column :title, :string
          t.column :body, :text
          t.column :created_at, :string
          t.column :updated_at, :string
        end
      end

      def self.down
        drop_table :articles
      end
    end

As you can see the create_table method takes a name and some options via a block which yields column names like title , body. We've also specified their column type. There a are a couple of column types you can specify here. To get a feel for what these map to I've put the migration type next to the mysql type for comparison. For other databases the mapping might be different. For instance for Postgresql a: binary is a byte and a: boolean is a proper boolean database type:

<table>
  <thead>
    <td>Migration type</td>
    <td>Mysql type</td>
  </thead>
  <tr>
    <td>:string</td>
    <td>varchar(255)</td>
  </tr>
  <tr>
    <td>:text</td>
    <td>text</td>
  </tr>
  <tr>
    <td>:boolean</td>
    <td>tinyint(1)</td>
  </tr>
  <tr>
    <td>:binary</td>
    <td>blob</td>
  </tr>
  <tr>
    <td>:integer</td>
    <td>int(11)</td>
  </tr>
  <tr>
    <td>:datetime</td>
    <td>datetime</td>
  </tr>
  <tr>
    <td>:time</td>
    <td>time</td>
  </tr>
  <tr>
    <td>timestamp</td>
    <td>datetime</td>
  </tr>
  <tr>
    <td>:float</td>
    <td>float</td>
  </tr>
</table>

Sometimes you'll want default values in your columns. To do that you can simple add:

    :default => 10

Of course when your working with your database you'll do more than just creating tables. AR Migrations provides the following convenience methods for you to work with. 

<table>
  <tr>
    <td>Migration Method</td>
    <td>Result</td>
  </tr>
  <tr>
    <td>drop_table(name) which drops a table</td>
    <td>Drop the table</td>
  </tr>
  <tr>
    <td>add_column(table,column)</td>
    <td>Adds a column to the table</td>
  </tr>
  <tr>
    <td>change_column (table, column, type, options)</td>
    <td>Changes the column to a different type</td>
  </tr>
  <tr>
    <td>rename_table(old, new) to rename a table</td>
    <td>Renames the table</td>
  </tr>
  <tr>
    <td>rename_column(table, old_column, new_column)</td>
    <td>Rename the column</td>
  </tr>
  <tr>
    <td>remove_column(table, column)</td>
    <td>Removes the column</td>
  </tr>
  <tr>
    <td>remove_index(table, column)</td>
    <td>Removes the index</td>
  </tr>
</table>

In order to actually run this migration we'll use yet another handy tool called 'rake'. Rake allows us to define tasks in Ruby and then execute them. Rails comes with a migration task to run the above migration. Execute this:

    $ rake migrate

    == CreateArticles: migrating ==================================================
    -- create_table(:articles)
       -> 0.7505s
    == CreateArticles: migrated (0.7523s) =========================================

That's looks reassuring. Apparently the migration has created the articles table. Let's check in the database:

    mysql> desc articles; 
    +------------+--------------+------+-----+---------+----------------+
    | Field      | Type         | Null | Key | Default | Extra          |
    +------------+--------------+------+-----+---------+----------------+
    | id         | int(11)      |      | PRI | NULL    | auto_increment |
    | title      | varchar(255) | YES  |     | NULL    |                |
    | body       | text         | YES  |     | NULL    |                |
    | created_at | varchar(255) | YES  |     | NULL    |                |
    | updated_at | varchar(255) | YES  |     | NULL    |                |


    5 rows in set (0.00 sec)

Sure enough it's there. But wait we missed a column. Apart form the body and title we want to be able to store an excerpt. Not a problem. Simply generate a new migration and add the column to the articles tables like so:

    $ script/generate migration AddExcerptColumnToArticles
          exists  db/migrate
          create  db/migrate/002_add_excerpt_column_to_articles.rb

I've used the generator to create a new migration named AddExcerptColumnToArticles which Rails translated to the file 002\_add\_excerpt\_column\_to\_articles.rb. The name you give should be something descriptive. It becomes the class name for the migration. Open up the file and you'll see:

    class AddExcerptColumnToArticles < ActiveRecord::Migration
      def self.up
      end

      def self.down
      end
    end

The number 002 just before the name is significant. It tells the migrations what order the migration files should be run in. It also corresponds to the value in the table schemainfo in your database. This is how your migrations are versioned if you like. But before I go into that, adjust this migration to add a column called excerpt.

    class AddExcerptColumnToArticles < ActiveRecord::Migration
      def self.up
        add_column "articles", "excerpt", :text
      end

      def self.down
        remove_column "articles", "excerpt"
      end
    end

Now run the migration:

    $ rake migrate 

    == AddExcerptColumnToArticles: migrating ===================================
    -- add_column("articles", "excerpt", :text)
       -> 0.2249s
    == AddExcerptColumnToArticles: migrated (0.2250s) =============================

We can rest assured that Rails will have added the column we specified. Suppose you made a mistake or you decide you don't want to add this column. You can simply rollback your change by having Migrations run the self.down class method for you. This is easily accomplished by telling Migrations which version you want. Since it's 002 that you want to rollback the version you want just before that is called 001. This version number is stored inside your schema or database in the table 'schema_info'. 

Run the following to drop the column and revert to version 1 of your schema. 

    $ rake migrate VERSION=1 

Sometimes a migration is supposed to be destructive or at least do something that you cannot rollback. In order for Migrations to gracefully handle this you should tell the migration it is non-reversible. You do this by raising an exception:

    def self.down
        raise IrreversibleMigration 
    end

>>TIP You can test your migrations before you run them on production or development by setting the environment variable RAILS_ENV to test like this if you're on some sort of unix or macosx (use setenv on Windows)

    $ RAILS_ENV=test ; rake migrate

>>This comes in handy when testing destructive or irreversible migrations since your test environment is wiped clean every single time anyway. More on test environments later.

Migrations provide a powerful way of dealing with changes to your database. Looking the supported methods table above you might think certain things cannot be done. However Migrations provide one more method you should be aware of:

    def self.up
      execute('ALTER TABLE ARTICLES TYPE=InnoDB')
    end

AR Migrations don't provide a standard method to change a tables internal storage type.  That wouldn't make sense since part of the Migrations appeal is that it makes your schema or database portable. 

But for this particular table and for this particular database you need to enable transactions (we'lll get back to how to do these a bit further down the road) and for that the storage type of the table has to be InnoDB. You can go in to the database and do it by hand but then you're breaking the Migrations cycle, you're going outside the versioning scheme. Luckily Migrations provide a method to run arbritary SQL statements in those moment you really need to. Use 'execute' and you're all set.

## Using Migrations to migrate data

You might have noticed a file in your db directory called schema.rb This file hold an image of the database after you've run any migration and is kept up to date by Rails for you. It comes in handy when you need an full overview of your schema or when you want to quickly copy your schema minus its data somewhere else.

There's one more thing we need to cover when dealing with Migrations.  So far the migrations we've seen deal with data definitions and how thing look from a physical point of view. The methods you've seen like create\_table and add\_column can be seen as a domain specific language that wraps around what SQL aficionados call DDL, data definition language. It's very convenient and if you never saw Ruby or Rails before you could probably figure out what it does and how to use it without ever learning Ruby or SQL.

There's another side to this, what is know as DML, i.e Data Manipulation Language. This term is used to refer to manipulating data, stuff inside your tables.  Migrations can deal with this as well. Inside migrations you have full access to your other models and you can use this to manipulate data. For instance suppose you want write a migration that deletes all articles that don't seem to have an excerpt. Whip up a migration and inside the 'up' class method add something like this:

    def self.up
       Article.find(:all).each { |article| article.destroy if article.excerpt.empty? }
    end

Once you run that migration Rails will quite happily delete all those articles for you.  You can even have a data migration on a model after you've changed some of its attributes. You have to reset the column (i.e attribute) information to do so. 

For instance we might have had articles before we decided to have an excerpt column. What to do with these articles after we've added the column? Well, let's set their excerpt to some reasonable value, say the first 30 characters of the body:

    def self.up
      add_column :articles, :excerpt, :string
      Article.reset_column_information
      Article.find(:all).each do |article|
         Article.excerpt = excerpt(Article.body)
      end
    end


Here we first add the column, then reset the model information so that Active Record knows about our changes and then we find all existing articles to set their excerpts using the Rails helper method excerpt() that has exactly the default values we want ( i.e 30 characters).

## Using Active Record to find your way around

Now that we have the Article model we might as well populate it with some sample data. There are different ways of doing that. You could just use SQL to insert directly into the table or if you had a dump of articles n plaintext load them with some utility but we're going to use a Rails feature called scaffolding. 

The ActionController#scaffold instance method gives us the opportunity to quickly do something useful with our articles table. It automatically makes available methods like show, edit, destroy, new, update and create to us as well as setting the @articles variable without polluting our carefully administered filesystem.

Since scaffold is an instance method of ActionController we'll need at least a controller to do do the work for. Let's use the generator Rails provides to set up an article controller. This controller takes care of all the article related actions that we can think of:

    $ script/generate controller article admin
          exists  app/controllers/
          exists  app/helpers/
          create  app/views/article
          exists  test/functional/
          create  app/controllers/article_controller.rb
          create  test/functional/article_controller_test.rb
          create  app/helpers/article_helper.rb
          create  app/views/article/admin.rhtml

To add the scaffolding we'll need to make a small adjustment to the controller itself. Open up app/controllers/article_controller.rb and make it look like this:

    class ArticleController < ApplicationController
  
      scaffold :article
  
    end

Startup up the application if you haven't done so already and head on down to localhost:3000/article/list.

>>Note: if you look online and in the Rails 'marketing' materials you'll see the usage of the scaffolding generator. While it's a convenient tool there will be non of that in this book. We're here to learn Practical Rails and using the scaffolding generator is not going to help. We need to know what happens. That said we can still use the scaffold method to stay agile. Using the method is different from using the generator, as you will see when we progress through this section.

If all went well we should be presented with something similar to this:

Figure 3-1
![Figure 3-1](../screenshots/f0301.jpg)

Go ahead click on 'New article'. You should be looking at something like this:

Figure 3-2
![Figure 3-2](../screenshots/f0302.jpg)

Rails and the scaffold method in particular have set this up for us. Now bang away and add a simple article or two so we have some data to play with. You'll notice how you can save, edit and update article when you play with this. Feel free to test things out.

Now, the scaffolding is not perfect. For instance there's that title in the top of the browser window 'Scaffolding' but remember that scaffolding is not meant to be used in your production site. It's a convenience provided by Rails so you can have results quickly as you move along rapidly. Something as simple as having a screen to input data should not take much more than 5 minutes to setup since it's so common and Rails provides it for us.

While we move further into this chapter we'll replace the scaffolding for methods of our own, that do exactly what we want and how we want.  In fact let's start with that list method.

For ActiveRecord to list your article it needs to find them. In SQL you would use 'select' to get the article's title, body etc. ActiveRecord shields you from the SQL by providing us with a couple of so called finder methods. Start up a console and we'll play around with this.

    $ script/console 
    Loading development environment.
    >> a = Article.find(:all)
    [#<Article:0x28cce14
      @attributes=
       {"updated_at"=>"2006-07-26 22:38:44",
        "body"=>
         "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean urna. Phasellus accumsan odio vel libero. Pellentesque vel ligula. Morbi placerat, elit quis cursus blandit, est velit condimentum quam, vel aliquam nisl sapien sed nibh. Duis imperdiet. Fusce ornare consectetuer metus. Donec suscipit vulputate diam. Mauris dolor. Duis sagittis varius nunc. Aenean a pede a nisi euismod vehicula. Quisque mollis augue. Donec orci. Nulla leo dui, elementum at, accumsan eu, ultrices et, libero.",
        "title"=>"Lorum ipsum",
        "excerpt"=>"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. ",
        "id"=>"1",
        "created_at"=>""}>]
    => nil

Your output might look slightly different since I'm using a pretty printer to make the output look better. When you execute Article.find(:all) ActiveRecord fetches all articles in the articles table for you. Notice the instance variable @attributes that is being set to a hash. The hash uses the column names of the articles table as keys. That means you can do something like this:

    >> first = Article.find(:first)

First we find() the first article by passing :first to the find method. We'll explain :first a bit later. This is what your output might look like:

    #<Article:0x2859c70
     @attributes=
      {"updated_at"=>"2006-07-26 22:38:44",
       "body"=>
        "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean urna. Phasellus accumsan odio vel libero. Pellentesque vel ligula. Morbi placerat, elit quis cursus blandit, est velit condimentum quam, vel aliquam nisl sapien sed nibh. Duis imperdiet. Fusce ornare consectetuer metus. Donec suscipit vulputate diam. Mauris dolor. Duis sagittis varius nunc. Aenean a pede a nisi euismod vehicula. Quisque mollis augue. Donec orci. Nulla leo dui, elementum at, accumsan eu, ultrices et, libero.",
       "title"=>"Lorum ipsum",
       "excerpt"=>"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. ",
       "id"=>"1",
       "created_at"=>""}>

ActiveRecord set the attributes for us. So to get to the title:

    >> first.title
    "Lorum ipsum"

Or grab an excerpt:

    >> first.excerpt
    "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. "

Our article also has an id set, surely AR can fetch article by id ? Certainly just execute

    by_id = Article.find(1)

and by_id will contain your article with id = 1

Finding information in a database is not always a simple matter of looking up an id in a table, or pulling out the first record you come across.  Data needs to be filtered with multiple pieces of information, pulled from multiple sources and then amalgamated into a single coherent result

Consider the following code:

    >> Recipe.find(:all, :conditions => "title = 'Crumpets'")
    => [#<Recipe:0xxxxxxxx @attributes={"id"=>"1", "title"=>"Crumpets" ... ]
    >> search_title = 'Crumpets'
    => "Crumpets"
    >> Recipe.find(:all, :conditions => ["title = ?", search_title])
    => [#<Recipe:0xxxxxxxx @attributes={ id"=>"1", "title"=>"Crumpets" ... }>]

We've already seen ActiveRecord's find method, but we only showed you the most basic of searches in preparation for recipes like this.  Here we've coupled the previous find(:all) method with a :conditions array.  This array works in a similar manner to a stringf function if you are familiar with C or other C derivative languages.

In the first example we set the search string manually passing in the search term "title = 'Crumpets'", which is an SQL snippet.  The SQL works as you'd expect and can be replaced by other variations on this theme.  Consider the following example.

    Recipe.find(:all, :conditions => "title LIKE 'Cr*'")
    => [#<Recipe:0xxxxxxxx @attributes={"id"=>"1", "title"=>"Crumpets" ... ]

In this example we used the SQL command LIKE to perform a fuzzy search on our table.  As you have probably noticed, this isn't the most productive way we can use the :conditions parameter, so let's step back to the second example in our first code example and expand on it a little.

    >> search_title = "Crumpets"
    => "Crumpets"
    >> search_id = 1
    => 1
    >> Recipe.find(:all, 
    ?> :conditions => ["title = ? and id = ?", search_title, search_id])
    => [#<Recipe:0xxxxxxxx @attributes={ id"=>"1", "title"=>"Crumpets" ... }>]

We set two variables to simulate input from somewhere in our application and we tell the :conditions array to pass our two variables in and replace the ? markers.  This is how stringf function works; for each marker within the string there must be a corresponding variable set in a comma separated list after it, Rails will take these variables in sequential order and put them into the string and then call the find() method.  These examples produce SQL to the effect of the example below.

    SELECT * FROM recipes WHERE (title = 'Crumpets' and id = 1)

>>Tip: Using the stringf replacement method of feeding variables into the string has the added bonus that Rails will automatically check them for SQL injection attempts, and sanitize the input.  Without these checks if you allowed user input from, for example, a params array to be directly fed into the string you leave yourself wide open to malicious attacks from the unscrupulous script kiddies that roam the internet wreaking havoc.  Never use string replacement in the find() method.  E.g. "#{params[:id]}", would be a very bad idea.

If you need to supply a list of variables to the :conditions option and would like the flexibility of a non-sequential order, you can instead use symbols within the string and a hash of values to match.  Like so:

    >> Recipe.find(:all, :conditions => [
    ?> "title = :search_title and id = :search_ id", 
    ?> { :search_title => "Crumpet", :search_id => 1 }])
    => [#<Recipe:0xxxxxxxx @attributes={"id"=>"1", "title"=>"Crumpets" ... }>]

Letting Rails know the order you want results to be returned in, or a specific number of results starting at a particular record is a powerful feature you can use for many different applications, for example, paginating results of a query into blocks of ten and returning the set of results for each page, separately.
Telling Rails you'd like to sort your results in a particular order is another find() option.  By passing :order a column name you can quickly and easily change the sort order of your results, you can specify more than one column to sort by and whether you'd like it sorting alphabetically ascending or descending.

    > Recipe.find(:all, :order => "title")
    => [#<Recipe:0xxxxxxxx @attributes={"title" => "Crumpets", "id" => "1" ... }>,
    #<Recipe:0xxxxxxxx @attributes={"title" => "Vanilla Spongecake", "id" => "2" ... }>]
    >> Recipe.find(:first, :order => "title")
    => #<Recipe:0xxxxxxxx @attributes={"title"=>"Crumpets", "id"=>"1"}>
    >> Recipe.find(:first, :order => "title DESC")
    => #<Recipe:0xxxxxxxx @attributes={"title"=>"Vanilla Spongecake", "id"=>"2">

As you probably guessed if you know a little SQL or have picked up a trend for what Rails is doing, ActiveRecord takes a small SQL snippet that you provide (That's what the "title DESC" is) and constructs a complete SQL statement to execute on the database.  The :order option can be given to most forms of find(), and can even have multiple columns sorted in a given order, see below.

    >> Recipe.find(:first, :order => "title DESC, id")
    => #<Recipe:0xxxxxxxx @attributes={"title"=>"Crumpets", "id"=>"1"}>
    #=> SELECT * FROM recipes ORDER BY title DESC, id

Restricting the amount of results you receive is an ideal optimization for not only memory, but CPU utilization on your server.  If you only need a certain amount of results then why ask for any more than you need.

    >> Recipe.find(:all, :limit => 10)                 
    => [#<Recipe:0xxxxxxxx @attributes={"title"=>"Crumpets", "id"=>"1"}>,
    #<Recipe:0xxxxxxxx @attributes={"title"=>"Vanilla Spongecake", "id"=>"2"}> ... ]

:limit is an option that can be used in all find() methods that can potentially return more than one record, most applications don't return all records from a search or category, and rather than retrieving all results and limiting the records shown using Ruby, here we instruct the database to do restrict the results it gives us instead.
:offset allows you to specify a number of records to skip before returning records.  This is how paging works, when coupled with :limit we can create our own 'page' of results.  If you had 100 recipes and needed to show from recipes 11-20, you'd do the following:

    >> Recipe.find(:all, :limit => 10, :offset => 10)
    => [#<Recipe:0xxxxxxxx @attributes={"title"=>"Muffins", "id"=>"11"}>,
    #<Recipe:0xxxxxxxx @attributes={"title"=>"Toad in the Hole", "id"=>"12"}> ... ]

So now Rails will return our limited recordset of 10, and skip the first 10 records when it returns the results, leaving us with results 11-20.

As you may have noticed throughout this book, Ruby is capable of wizardry and sorceressness (Yes, that's a word I made up) to conjure up methods out of thin air just when and where you need it.  Dynamic finders are another of these useful additions that are added just to make things easier on your eyes and therefore more maintainable in the future.

All the models in your application get a set of methods automatically generated for them that correspond to each of the columns in your table, prepended with find\_by\_ and others.  Let's take a look at what you get in table 4-1.

NOTE: CURRENTLY SHIFTED TO A CODE BLOCK TILL I CAN FIGURE OUT WHY MY MARKDOWN TO LATEX XSLT IS NOT WORKING

    4-1. Dynamic Finder List 

    <table>
      <thead>
        <td>Column Name</td>
        <td>Find</td>
        <td>Find All</td>
        <td>Find or Create</td>
      </thead>
      <tr>
        <td>id</td>
        <td>find_by_id</td>
        <td>find_all_by_id</td>
        <td>find_or_create_by_id</td>
      </tr>
      <tr>
        <td>title</td>
        <td>find_by_title</td>
        <td>find_all_by_title</td>
        <td>find_or_create_by_title</td>
      </tr>
      <tr>
        <td>category</td>
        <td>find_by_category</td>
        <td>find_all_by_category_id</td>
        <td>find_or_create_by_category_id</td>
      </tr>
    </table>

For each column in our database Rails generated methods we could use to search it in a more readable manner.  Let's take a look at this in a little more detail.

    >> search_title = 'Crumpets'
    => 'Crumpets'
    >> Recipe.find(:first, :conditions => ["title = ?", search_title])
    => #<Recipe:0xxxxxxxx @attributes={"title"=>"Crumpets", "id"=>"1"}>
    >> Recipe.find_by_title(search_title)
    => #<Recipe:0xxxxxxxx @attributes={"title"=>"Crumpets", "id"=>"1"}>
    >> Recipe.find_by_title_and_id(search_title, 1)
    => #<Recipe:0xxxxxxxx @attributes={"title"=>"Crumpets", "id"=>"1"}>
    >> Recipe.find_all_by_title(search_title)
    => [#<Recipe:0xxxxxxxx @attributes={"title"=>"Crumpets", "id"=>"1"}>]
    >> Recipe.find_or_create_by_title('Bacon Sandwich')
    => #<Recipe:0xxxxxxxx @errors=#<ActiveRecord::Errors:0xxxxxxxx @errors={}, @base=#<Recipe:0xxxxxxxx ...>>, @new_record_before_save=true, @attributes={"id"=>34, "title"=>"Bacon Sandwich", ... }, @new_record=false>

To start off our code examples I placed a standard search using :conditions to show the difference between our dynamic finder methods and the usual method of searching.  You can immediately see which is more readable.  In these examples you can deduce what is happening by the name of the method, which is why this method is more maintainable for your applications as it reduces the time it will take to become re-acquainted with code you haven't looked at in a while.

Each meaningful attribute for your model (which means anything corresponding to a column in your table) has dynamically generated methods created that add find\_by\_, find\_all\_by\_ and find\_or\_create\_by\_ onto your list of available search options.

The last example is a very handy tool for when you need to create new records if one doesn't already exist.  Let's say I had a table that held Categories, I could have a search box that looked for a category name and created one if it didn't exist, something I've used in administrator panels for some of my clients.  There are many uses for it, but ultimately it boils down to making your code more readable.  If you come back to this code in a year or more I'm sure you'd prefer that you could see immediately what it was doing at a glance rather than having to read into the :conditions parameter every time.

## Calculations

Running statistical analysis on your table columns, adding up the amounts, working out averages or finding the maximum and minimum amounts, all these used to be a matter of running straight SQL against your database or pulling all the records out and using Ruby.  As of Rails 1.1 you can now use ActiveRecord that will perform those calculations for you, in an optimized SQL call.

Let's start of by looking at a couple of calculations:

    >> Money.maximum('oustanding')
    => 48229.00
    >> Money.minimum('outstanding')
    => 345.00
    >> Money.average('outstanding')
    => 23885.00
    >> Money.count()
    => 98
    >> Money.sum('outstanding')
    => 123768.00
    >> Money.calculate(:sum, 'outstanding')
    123768.00

The examples above show you just how easy the calculations are now since Rails 1.1, they are just as you'd expect.  All the calculations are available to your models as class methods as above.  The calculation methods run SQL queries on your database, which is much more efficient than pulling all your records and running Ruby commands directly onto an array because SQL is optimized for this kind of routine.

In the examples I've shown you the basic syntax of the shortcut commands (maximum(), minimum(), average(), count() and sum()), which all link to the last example (calculate()) and give you a more readable version instead.
Minimum and Maximum

Given a column name from your table this function will hunt out the largest value in that column, and return the same data type as the column.

    >> # Find the maximum owed for a specific client
    ?> client_name = 'Fear of Fish'
    >> Money.maximum('owed', :conditions => ['client = ?', client_name])
    => 4560.01
    >> # Find the maximum amount for any client who owes at least 100
    ?> Projects.maximum('owed', :having => 'min(owed) > 100', :group => :client)
    => 45272.00
    >> # Find the minimum owed for all clients except a specific client
    ?> Money.minimum('owed', :conditions => ['client = ?', client_name])
    => 25.00
    >> # Find the minimum for all clients owing less than a total of 1000
    ?> Projects.minimum('owed', :having => 'sum(owed) < 100', :group => :client)
    => 25.00

As you can see the calculations are more comprehensive that we initially showed you.  Using :conditions you can filter like any find() method, the calculations are applied after the filters you use.  Grouping your results with :group for a maximum calculation by itself is fairly pointless, because the maximum calculation returns a single value and grouping that would not have any effect on the outcome, however, tagging it together with :having allows you to only apply the search to groups (decided by :group) that pass the :having clause.  

Within the :having clause we have used SQL snippets to do our bidding, this is another example that Rails doesn't fully shield (nor does it want to) from the SQL language, it gives an mix of Rails and SQL to give you the most flexible and understandable solution possible.

## Count

    >> # Find the count for a specific client
    ?> Money.count('owed', :conditions => ['client = ?', client_name])
    => 3
    >> # Find the counts for clients owing more than 100 returns array
    ?> Projects.count(:all, :group => :client, :having => 'min(owed) > 100')
    => [[#<Project:0xxxxxxxx @attributes={"name"=>"Fear of Fish", "id"=>"1"}>, 2]]

Count is a versatile tool for statistical analysis, it accepts options that allow you to refine and group your counts to return what you need.  Take a look at the options you can pass count() in table 4-2 below.

4.2 Options for count()

<table>
  <thead>
    <td>Name</td>
    <td>Description</td>
  </thead>
  <tr>
    <td>:conditions</td>
    <td>An SQL snippet like "owed > 10"</td>
  </tr>
  <tr>
    <td>:joins</td>
    <td>An SQL snippet that uses extra SQL joins in the count, the records are returned read only.  You will rarely use this.</td>
  </tr>
  <tr>
    <td>:include</td>
    <td>Symbols of named associations to load as well, using an SQL LEFT OUTER JOIN call.</td>
  </tr>
  <tr>
    <td>:order</td>
    <td>An SQL snippet denoting the order of results like 'client DESC, city'</td>
  </tr>
  <tr>
    <td>:group</td>
    <td>A column name to group the results by using the SQL GROUP BY</td>
  </tr>
  <tr>
    <td>:select</td>
    <td>A string denoting the columns you want returning in the result, this defaults to all, but if you don't need all columns returning you can restrict columns with this</td>
  </tr>
  <tr>
    <td>:distinct</td>
    <td>To specify you'd only like to count unique results</td>
  </tr>
</table>	

## Average and sum

If you happen to need to know the averages of a column, or the sum of all values these are what you will be using.  As with the other calculation methods, you can supply options to refine the results that the calculation acts upon.  Refer to table 4-2 above for a listing of these options.  Average returns a float value and sum returns the same data type of the column it is run against.

## Calculate

Calculate is actually the the power behind all the other methods and so won't take much going over.  The syntax for calculate is slightly different because you need to tell it what type of calculation you want as an option.

    >> client_name = 'Fear of Fish'
    => "Fear of Fish"
    >> Money.calculate(:maximum, 'owed', conditions => ['client = ?', client_name])
    => 4560.01
    >> # Find the counts for clients owing more than 100 returns array
    ?> Projects.calculate(:count, :group => :client, :having => 'min(owed) > 100')
    => [[#<Project:0xxxxxxxx @attributes={"name"=>"Fear of Fish", "id"=>"1"}>, 2]]
    >> # Find the maximum amount for any client who owes at least 100
    ?> Projects.calculate(:maximum, 'owed', :having => 'min(owed) > 100', 
    ?> :group => :client)
    => 45272.00
    >> # Find the minimum for all clients owing less than a total of 1000
    ?> Projects.calculate (:minimum, 'owed', :having => 'sum(owed) < 100', 
    ?> :group => :client)
    => 25.00

Apart from the first parameter, calculate() works exactly as if you had used a shortcut (Which we discussed in detail earlier), for details on each type of calculation refer to the previous sections of this recipe.

>>Caution: If you run calculation methods on non-numerical fields you won't get an exception, instead you'll get some odd responses or nothing at all so ensure you only run it on a numerical field or prepare for the worst.

## Using SQL Directly

Sometimes SQL is the only path to take because let's face it, SQL isn't evil, it's just a daunting prospect to those new to it and not as simple as using a cuddly object orientated approach through a nice framework like Rails.  

    >> Recipe.find_by_sql("SELECT * FROM recipes WHERE id = 1")
    >> Recipe.find_by_sql(["SELECT * FROM recipes WHERE id = ?", 1])
    >> Recipe.find_by_sql("SELECT title FROM recipes WHERE title LIKE ?
    ?>                            ORDER BY title", "Crum%")

If you are familiar with SQL commands then you can see what's going on here, Rails will execute this SQL query on the database and return an array of model objects.  You can manipulate and save the models as you would normally, but what you lose is the readability and ease of use.

>>Caution: By using find_by_sql() you not only lose the readability of Ruby code, but you also endanger the ability to save your models back to the table.  If you don't request the id field then Rails will not save your models, nor will it give you an Exception to say it didn't, if you need to make sure you can save changes to the models returned by this method then always retrieve the id.

## Validations

Models are the correct place to validate your form data. But you don't always want to store form data in a table. Rails assumes your model corresponds to a table. How can you validate data that obviously belong to your model but that does not have a corresponding column in a table ? Use this trick that allows you to validate your forms without a table by overriding the attributes normally linked to columns in a tables:

    class Contact < ActiveRecord::Base

      def self.columns() @columns || = []; end
   
      def self.column(name, sql_type = nil, default = nil, null = true)
        columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default,   sql_type.to_s, null)

    end

      column :name, :string
      column :city, :string
 
      validates_presence_of :name, :city
    end

### How it works

ActiveRecord#columns is a method that returns an array of Column objects for the given table First we override and empty the columns method for this object.

    def self.columns() @colums ||= []; end

Next the we override the columns() method itself so we get free game. 

    def self.column(name, sql_type = nil, default = nil, null = true)
        columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default,   sql_type.to_s, null)

After that's done we can now set any virtual column we would like to validate like so:

    column :name, :string
    column :city, :string

This is pretty neat by itself. But as is often the case we can improve on the situation. In the next code we abstract the above behavior into a class of it's own . This class ActiveForm can then be used anywhere where we want to validate non table related data:

    class ActiveForm < ActiveRecord::Base
      def self.columns; @columns ||= ; end
      def self.column(name, sql_type = nil, default = nil, null = true)
        columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
      end
    end

Now in a class that we set up to validate the form use the ActiveForm:

    class MyForm < ActiveForm
      %w{name, city}.each { |c| column c }
      validates_presence_of :name, :city
    end

Original work on this recipe was done by Rick Olson. The abstraction was a neat idea from Remoc van 't Veer 

## Testing your models

Active Record models are usually tested as unit tests. When you generate a new model a test fixture and corresponding test file is created for you. For instance, here we create a model for an Author:

    >ruby script/generate model Author
          exists  app/models/
          exists  test/unit/
          exists  test/fixtures/
          create  app/models/author.rb
          create  test/unit/author_test.rb
          create  test/fixtures/authors.yml
          exists  db/migrate
          create  db/migrate/009_create_authors.rb

Notice how in the directory test an author\_test.rb and a fixture authors.yml is created for you. Another one of those pesky Rails opinions is that you should write tests first. That's right, whenever you have an itch to add some functionality, write the test first.

Test-Driven Development or TDD is an integral part of being a Rails developer. There's no escaping it. If you're serious at all, learn to write tests (start with this recipe) and read Kent Beck's landmark book: 'Test Driven Development'

Have a look at the author\_test.rb file:

    class AuthorTest < Test::Unit::TestCase
      fixtures :authors

      # Replace this with your real tests.
      def test_truth
        assert true
      end
    end

This is the contents of the fixture file that came in the box, we've changed it to reflect our Authors model:

    first:
      id: 1
      first_name: Jamie
      last_name:  van Dyke
    another:
      id: 2
      first_name: Stephen
      last_name: King


## How it Works

Let's answer Rails' invitation to replace the example test with a real one and we'll make things clear along the way. 

    def test_new_author_creates_author
       rodney1 = authors(:first)
       rodney2  =  Author.new(:first_name => author.first_name, :last_name => author.last_name)
       assert false  author.new_record?
       author.save
       assert true author.new_record?
       assert_equal rodney1.first_name, rodney2.first_name
    end

First we give our test method a somewhat descriptive name 'test\_new\_author\_creates\_author'. This is just a convention which as usual we advise you to conform to. In this case we apparently want to test that if we request a new Author we actually get one.

Next, we read from the fixtures file we saw earlier. When Rails generated the test file, it automatically included the fixture file (  fixtures :authors ). A fixture is loaded into the database the moment the test is run. Internally Rails copies your development schema to the test database and used the fixtures to populate the tables. So far that's pretty neat. We now have an Active Record object called rodney1.

On the following line from our test method we create an object by calling the Author class with data we derived from the fixture. 

Finally we get to the actual test. The method call author.new_record? checks to see if the  author is a brand new shiny record. A property of 'save' is that it does not create the object in the database just yet. That means that at this point author.new_record? should be false i.e. non-existent. So we test that condition by asserting that new_record? Should return true.

We then save() the object after which of course the author should exist in the database. To test that we assert that new_record? is false. Furthermore since we created rodney2 with the data from rodney1 their first names have to be equal. 

The good stuff is in the 'assert' methods. There are a couple of more things that are commonly raised when testing models:

<table>
  <thead>
    <td>Method</td>
    <td>Goal</td>
  </thead>
  <tr>
    <td>assert</td>
    <td>To see if something is true or false</td>
  </tr>
  <tr>
    <td>assert_equal</td>
    <td>To see if something is equal to</td>
  </tr>
  <tr>
    <td>assert_raises</td>
    <td>Check if something is raised</td>
  </tr>
  <tr>
    <td>assert_nothing_raised</td>
    <td>Check if nothing is raised</td>
  </tr>
  <tr>
    <td>assert_kind_of</td>
    <td>Checks what type of construct we're dealing with</td>
  </tr>
</table>

There are a lot more possible assertions but when dealing with models this is what you'll be commonly using.

## Injecting logic into the object lifecycle

When you're dealing with objects from Active Record you will at some point want to do things before or after objects are created or destroyed. In database land developers do this with triggers. Rails developers use callbacks. Callbacks allow you to interfere with the life of a object. You can inject logic so to see into the object lifecycle. 

For instance:

    class Chapter < ActiveRecord::Base
      belongs_to :user
      has_many :recipes
      before_destroy :delete_recipes

       private
   
      class << self
        def delete_recipes
          Recipes.delete_all 'chapter_id = #{chapter_id}'
        end
      end
    end

### How it works

It is fair to say that when we remove a chapter from our beta-book management application that we first have to remove all related content to that chapter. We've specified that requirement by adding the hook before\_destroy :remove\_recipes to the Chapter class. This hook makes sure that before we delete the chapter we deleted it's content , in this case the corresponding recipes. It works by calling the private method delete_recipes a bit further down in the class itself.

There are quite a few callbacks available to you. For our application the powers that be have decided that when a new recipe is added to a chapter an email must be send at once. To meet this requirement we add a after_save callback to the Recipe model.

    class Recipe << ActiveRecord::Base
      after_save :send_mail

      private
      class << self
        def send_mail
          […] #=> mail implementation here
        end
    end

It's possible to stack callbacks.  So you can have multiple callbacks after each other. We've listed all possible callbacks in the following table. 

<table>
  <thead>
    <td>Callbacks</td>
  </thead>
  <tr>
    <td>after_create</td>
  </tr>
  <tr>
    <td>after_destroy</td>
  </tr>
  <tr>
    <td>after_save</td>
  </tr>
  <tr>
    <td>after_validation</td>
  </tr>
  <tr>
    <td>after_update</td>
  </tr>
  <tr>
    <td>after_validation_on_create</td>
  </tr>
  <tr>
    <td>after_validation_on_update</td>
  </tr>
  <tr>
    <td>before_create</td>
  </tr>
  <tr>
    <td>before_destroy</td>
  </tr>
  <tr>
    <td>before_save</td>
  </tr>
  <tr>
    <td>before_update</td>
  </tr>
  <tr>
    <td>before_validation</td>
  </tr>
  <tr>
    <td>before_validation_on_create</td>
  </tr>
  <tr>
    <td>before_validation_on_update</td>
  </tr>
</table>