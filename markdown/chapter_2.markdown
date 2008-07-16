# A Short Introduction to Ruby

The key to learning Ruby on Rails is in its name; you have to learn Ruby first.  This might at first sound like a daunting task, but I can assure you that it's easier than you think.  To put you in good stead for the rest of the book I'm going to teach you the basics of Ruby, just enough to get you prepared for the concepts in following chapters as well as show you some of the dynamic power that you get.

## Objects, Variables and Methods

Ruby is an object-oriented programming (OOP) language, but what does that mean?  To the non-programmer it means that you need to find a way of relating objects in your application, to objects you will create in Ruby.  If you're creating an ecommerce application for a shop, you'll be looking for a way to describe the catalogue of products you're going to be selling.  Well, products have descriptions like name and price, and in an object-oriented language (and to some extent in the real world) we map these pieces of information onto the object, and therefore relate those descriptions to that object.  In geek terms we say that these descriptions are attributes of our object.  Ruby takes this paradigm and applies it to all the objects within the language, so for example if you create a sentence (a string), and would like to know exactly how long it is, there are attributes of that sentence that you can query e.g. length.

Attributes are a way of describing an object, but we also need a way of manipulating it, our objects need methods.  Methods are actions we want to perform on an object, examples I've come across as I was learning these concepts many moons ago talk about cars as object, and the actions being terms like accelerate, or brake.  However, I've never found these very useful in the concept of programming, so think of actions as things like delete, create, new and more.  If we need to delete a product, we would write an action called delete, and we could then tell a product to delete itself.

### How about an example?

The best way to understand how this all relates to Ruby is with a practical example.  If we re-use our example from above and imagine we need a product object, we could create one using the following code:

    product = Product.new

This highlights two new concepts to you; firstly that Ruby is case-sensitive, meaning that even though we have two words saying product, they're not the same, and secondly, Product is a type of thing that can be instantiated over and over again.

What you'll be doing with each of your applications is figuring out what objects there are for you to map, and what their relationships are.  

NOTES:
* Objects, Variables, and Methods
  * Classes
  * Modules
  * Variables
    * Local variables vs. Instance variables
    * Class variables
      ~ String interpolation
      ~ Naming conventions
        ~ Classes are CamelCase; Methods are lower_case
      ~ Instance methods and class methods
      ~ Mixins and Inheritance
      ~ Blocks
      ~ method_missing
