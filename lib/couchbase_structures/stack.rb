require 'couchbase_doc_store'

module CouchbaseStructures
  class Stack
    include CouchbaseDocStore

    def initialize(key)
      @user_key = key
      @key = "#{@user_key}::stack"
      @top_index_key = "#{@key}::top"
      initialize_document(@top_index_key, 0)
      initialize_document(@key, { :type => "stack", :class => "CouchbaseStructures::Stack", :user_key => @user_key } )
      self
    end
    
    def inspect(html = false)
      if html
        "<strong>key</strong> = #{@key}    <br /><strong>top_index</strong> = #{get_document(@top_index_key).to_s}    <br /><strong>items</strong> = #{self.to_a(true)}"
      else
        "key = #{@key}\ntop_index = #{get_document(@top_index_key).to_s}\nitems = #{self.to_a}"
      end
    end

    def push(value)
      new_top_index = increase_atomic_count(@top_index_key)
      create_document("#{@key}::#{new_top_index}", value)
      self
    end

    def pop()
      old_top_index = get_document(@top_index_key)
      return nil if @top_index_key == 0 # if the stack has returned to zero items
      decrease_atomic_count(@top_index_key)

      doc = get_document("#{@key}::#{old_top_index}")
      delete_document("#{@key}::#{old_top_index}")
      doc
    end

    def size
      get_document(@top_index_key)
    end
    
    def delete
      top_index = get_document(@top_index_key)
      
      top_index.downto(1) do |i|
        delete_document("#{@key}::#{i}")
      end
      delete_document(@top_index_key)
      delete_document(@key)
    end
    
    def to_a(html=false)
      a = []
      top_index = get_document(@top_index_key)

      # delete all queued documents, including those that were before the current head (those aren't deleted as of now)
      top_index.downto(1) do |i|
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