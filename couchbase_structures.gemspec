# -*- encoding: utf-8 -*-
require File.expand_path('../lib/couchbase_structures/version', __FILE__)

Gem::Specification.new do |gem|

  gem.name          = "couchbase-structures"
  gem.require_paths = ["lib"]
  gem.version       = CouchbaseStructures::VERSION

  gem.authors       = ["Jasdeep Jaitla"]
  gem.email         = ["jasdeep@scalabl3.com"]
  gem.description   = %q{Stack, Queue and SortedList structures implemented in Couchbase}
  gem.summary       = %q{A convenient implementation of stacks, queues and sorted lists using Couchbase KV patterns.}
  gem.homepage      = "https://github.com/scalabl3/couchbase-structures"

  gem.add_dependency('couchbase-docstore', '>= 0.1.2')
  gem.add_dependency('couchbase-settings', '>= 0.1.0')
  gem.add_dependency('couchbase', '>= 1.2.0.z.beta3')

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

end
