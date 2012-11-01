# CouchbaseStructures

Simple data structures to create persisted data structures: Queue, Stack and Sorted List. At this time SortedList is just single values: strings, integers, floats, etc. I will make a more sophisticated SortedList soon. These patterns do not require Couchbase 2.0, they are Key-Value based patterns and work fine in Couchbase Server 1.8.x as well.



## Dependencies

I will only work on backwards compatibility in these gems if there is real demand to do so, otherwise I assume the latest edge gem of gem couchbase which is designed for Couchbase Server 2.0 with all it's optimizations and speed!

gem 'couchbase-settings' (http://github.com/scalabl3/couchbase-settings)

gem 'couchbase-docstore' (http://github.com/scalabl3/couchbase-docstore)


## Installation

Add these lines to your application's Gemfile:

    gem 'couchbase-settings'
    gem 'map'
    gem 'couchbase-docstore'
    gem 'couchbase-structures'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install couchbase-settings couchbase-docstore couchbase-structures

## Usage

Assuming you have setup Couchbase Server, the libcouchbase C native extensions library that the couchbase gem requires, and installed the Couchbase gem.

#### Queue

```ruby
require 'couchbase_structures'

queue = CouchbaseStructures::Queue.new("myqueue")
queue.enqueue({ :item1 => "my item"})
queue.enqueue({ :item2 => "my other item"})

next = queue.pop()
# => { :item1 => "my item "}

next = queue.pop()
# => { :item2 => "my other item "}
```

#### Stack

```ruby
require 'couchbase_structures'

stack = CouchbaseStructures::Stack.new("mystack")
stack.push({ :item1 => "my item"})
stack.push({ :item2 => "my other item"})

next = stack.pop()
# => { :item2 => "my other item "}

next = stack.pop()
# => { :item1 => "my item "}
```


## Coming Soon

* Add some safeguarding code for mega-concurrency
* Add more complex usage for SortedList, store complex classes instead of just simple values

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


&copy; 2012, Jasdeep Jaitla, aka @scalabl3, MIT License