require 'document_store'

module CouchbaseStructures
  class Queue
    include DocumentStore

    def initialize(key)
      @key = key
      @head_index_key = "#{key}::queue::head"
      @tail_index_key = "#{key}::queue::tail"
      self
    end

    def enqueue(value)
      new_tail_index = increase_atomic_count(@tail_index_key)
      create_document("#{key}::queue::#{new_tail_index}", value)
      self
    end

    def pop()
      head_index = get_document(@head_index_key)
      tail_index = get_document(@tail_index_key)
      if tail_index > head_index
        increase_atomic_count(@head_index_key)
        get_document("#{key}::queue::#{head_index}")
      else
        nil
      end
    end

    def size()
      get_document(@tail_index_key) - get_document(@head_index_key)
    end
  end
end