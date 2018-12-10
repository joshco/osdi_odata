require "osdi_odata/version"
require "osdi_odata/parser"
require 'logger'

module OsdiOdata
  # Your code goes here...
  def self.parse(filter)
    Parser.convert_odata_to_sql(filter)
  end

  def self.logging_enabled=(val)
    Parser.logging_enabled=val
  end
end
