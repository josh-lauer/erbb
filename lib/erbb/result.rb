module ERBB
  class Result < String
    attr_reader :named_blocks

    def method_missing(method_name)
      if named_blocks.key?(method_name)
        named_blocks[method_name]
      else
        super
      end
    end

    def initialize(str, named_blocks, opts = {})
      super(str, *opts)
      @named_blocks = Hash[named_blocks.map { |k,v| [k.to_sym, v] }]
    end
  end
end
