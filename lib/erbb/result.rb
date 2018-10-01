module ERBB
  class Result < String
    attr_reader :named_blocks

    def initialize(str, named_blocks, opts = {})
      super(str, *opts)
      @named_blocks = named_blocks || {}
    end
  end
end
