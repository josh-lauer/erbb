require "erb"
require "ostruct"

require "erbb/parser"
require "erbb/receiver"
require "erbb/result"
require "erbb/version"

module ERBB
  def self.new(*args)
    ERBB::Parser.new(*args)
  end
end
