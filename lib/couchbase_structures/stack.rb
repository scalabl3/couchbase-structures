require 'couchbase_doc_store'

module CouchbaseStructures
  class Stack
    include CouchbaseDocStore

    def initialize(key)
      @key = key
      @top_index_key = "#{key}::stack::top"
      initialize_document(@top_index_key, 0)
      self
    end

    def push(value)
      new_top_index = increase_atomic_count(@top_index_key)
      create_document("#{key}::stack::#{new_top_index}", value)
      self
    end

    def pop()
      old_top_index = get_document(@top_index_key)
      decrease_atomic_count(@top_index_key)

      doc = get_document("#{key}::stack::#{old_top_index}")
      delete_document("#{key}::stack::#{old_top_index}")
      doc
    end

    def size
      get_document(@top_index_key)
    end
  end
end