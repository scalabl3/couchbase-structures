require 'couchbase_doc_store'

module CouchbaseStructures
  class Queue
    include CouchbaseDocStore

    def initialize(key)
      @user_key = key
      @key = "#{key}::queue"
      @head_index_key = "#{@key}::head"
      @tail_index_key = "#{@key}::tail"
      initialize_document(@head_index_key, 0)
      initialize_document(@tail_index_key, 0)
      initialize_document(@key, { :type => "queue", :class => "CouchbaseStructures::Queue", :user_key => key } )
      self
    end

    def inspect(html = false)
      if html
        "<strong>key</strong> = #{@key}    <br /><strong>head_index</strong> = #{get_document(@head_index_key).to_s}  <br /><strong>tail_index</strong> = #{get_document(@tail_index_key).to_s}   <br /><strong>items</strong> = #{self.to_a(true)}"
      else
        "key = #{@key} head_index = #{get_document(@head_index_key).to_s} tail_index = #{get_document(@tail_index_key).to_s} items = #{self.to_a}"
      end
    end
    
    # peek at item at index (zero based)
    def peek(queue_index)
      self
    end

    # Add an item to the end of the queue (tail)
    def enqueue(value)
      new_tail_index = increase_atomic_count(@tail_index_key)
      create_document("#{@key}::#{new_tail_index}", value)
      self
    end

    # Pop an item off the front of queue (head)
    def pop()
      head_index = get_document(@head_index_key)
      tail_index = get_document(@tail_index_key)
      if tail_index > head_index # if there is an item in the queue
        increase_atomic_count(@head_index_key) #incremented new_head_index is ignored, but we are incrementing and popping value
        return get_document("#{@key}::#{head_index + 1}")
      else # 
        nil
      end
    end

    def size()
      get_document(@tail_index_key) - get_document(@head_index_key)
    end
    
    def delete
      #head_index = get_document(@head_index_key)  # (not needed)
      tail_index = get_document(@tail_index_key)
      
      # delete all queued documents, including those that were before the current head (those aren't deleted as of now)
      1.upto(tail_index) do |i|
        delete_document("#{@key}::#{i}")
      end
      delete_document(@head_index_key)
      delete_document(@tail_index_key)
      delete_document(@key)
      @user_key = nil
      @key = nil
      @head_index_key = nil
      @tail_index_key = nil
      nil
    end
    
    def to_a(html=false)
      a = []
      head_index = get_document(@head_index_key) + 1
      tail_index = get_document(@tail_index_key)

      # delete all queued documents, including those that were before the current head (those aren't deleted as of now)
      head_index.upto(tail_index) do |i|
        a << get_document("#{@key}::#{i}")
      end
      
      if html
        str = "["
        a.each do |item|
          str += "<br />&nbsp;&nbsp;&nbsp;&nbsp;" + item.inspect
        end
        str += "<br />]"
        return str
      else
        return a
      end
    end
  end
end