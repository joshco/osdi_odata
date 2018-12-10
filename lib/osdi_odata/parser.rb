require 'treetop'
require_relative 'sexp'


class MyOperator
  attr_accessor :kind
end

# Load our custom syntax node classes so the parser can use them
#require File.expand_path(File.join(File.dirname(__FILE__), 'node_extensions.rb'))
#include Sexp

module OsdiOdata
  class Parser

    @@logger=nil
    def self.log(message)
      @@logger.info message if @@logger
    end

    def self.logging_enabled=(val)
      if val==true
        @@logger=::Logger.new(STDOUT)
      else
        @@logger=nil
      end
    end
    # Load the Treetop grammar from the 'sexp_parser' file, and create a new
    # instance of that parser as a class variable so we don't have to re-create
    # it every time we need to parse a string
    Treetop.load(File.expand_path(File.join(File.dirname(__FILE__), 'sexp_parser.treetop')))
    @@parser = SexpParser.new

    # Parse an input string and return a Ruby array like:
    #   [:this, :is, [:a, :test]]
    def self.parse_inner(data)

      # Pass the data over to the parser instance
      tree = @@parser.parse(data)

      # If the AST is nil then there was an error during parsing
      # we need to report a simple error message to help the user
      if (tree.nil?)
        raise Exception, "Parse error at offset: #{@@parser.index}"
      end

      # Remove all syntax nodes that aren't one of our custom
      # classes. If we don't do this we will end up with a *lot*
      # of essentially useless nodes
      self.clean_tree(tree)

      # Convert the AST into an array representation of the input
      # structure and return it


      return tree

      #return tree
    end

    def self.parse(odata)
      tree = self.parse_inner(odata)
      return tree.to_array

    end


    def self.convert_odata_to_sql(odata)
      token_list = {
          :like => 'ILIKE',
          :and => 'AND',
          :or => 'OR',
          :ne => '<>',
          :gt => '>',
          :lt => '<',
          :ge => '>=',
          :le => '<=',
          :eq => '='

      }
      do_it_inner(odata, token_list)

    end

    private

    def self.clean_tree(root_node)
      return if (root_node.elements.nil?)
      root_node.elements.delete_if { |node| node.class.name == "Treetop::Runtime::SyntaxNode" }
      root_node.elements.each { |node| self.clean_tree(node) }
    end

    def self.convert (tokens, token_list)
      sql=''
      self.log "convert called with #{tokens.count} Tokens: #{tokens}"
      tokens.each do |t|
        self.log "working token #{t} of class #{t.class}"
        case t # note === wierdness
          when Array
            repl="( #{convert(t, token_list)})"
          when String
            repl = "'#{t}'"
          when Hash
            repl = nil
          else
            repl = token_list[t] || t
        end

        self.log "[#{sql}] appending #{repl}"
        sql+= "#{repl} "

      end
      self.log "exiting convert, called with #{tokens} SQL is #{sql}"
      return sql
    end


    def self.do_it_inner(odata, token_list)
      ast=parse(odata)

      sql=convert(ast, token_list)
      self.log "Converted result"
      self.log sql

      sql.strip!
    end

  end
end




