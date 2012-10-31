require 'couchbase_doc_store'

# haven't written this one yet... it's a copy of Stack code
module CouchbaseStructures
  class SortedList
    include CouchbaseDocStore

    attr_accessor :sort_type, :sort_key
    
    def initialize(key, attr = {})
      
      if attr.has_key? :sort_type
        case attr[:sort_type]
        when :json
          @sort_type = :json
          @sort_key = attr[:sort_key] 
        when :simple
          @sort_type = :simple
        end
      end
      
      @key = key
      @list_key = "#{key}::sorted_list"
      initialize_document(@list_key, { :sorted_list => [], :last_updated => Time.now.utc.to_i })
      self      
    end

    def add(value)
      doc = get_document(@list_key)
      list = doc["sorted_list"]
      list << value
      
      # simple sort only for singular values, string, integer, float, etc.
      list.sort!
      
      # complex sort for Hash types
      
      doc["sorted_list"] = list
      doc["last_updated"] = Time.now.utc.to_i
      replace_document(@list_key, doc)
      list
    end

    def items
      doc = get_document(@list_key)
      doc["sorted_list"]
    end

    def size
      doc = get_document(@list_key)
      doc["sorted_list"].size
    end
  end
end