module ERBB
  # Parses ERBB files (erb files with #named_block calls in them). Use like you
  # would the ERB class, except instead of passing a binding when getting the
  # result, you pass in an object which will be the implicit receiver for all
  # ruby calls made in the erb template. This object will be decorated with the
  # instance methods in ERBB::Receiver when rendering.
  class Parser < ERB
    # @see https://ruby-doc.org/stdlib-2.5.1/libdoc/erb/rdoc/ERB.html#method-c-new
    # @param  str [String] the template to render.
    # @param  safe_level [Nil,Integer] the safe level.
    # @param  trim_mode [Nil,String] how to handle newlines.
    def initialize(str, safe_level=nil, trim_mode='>')
      # The fourth arg is the name of the variable defined on the receiver
      # which is used to store the rendered output when parsing a template.
      # ERBB works by exploiting that, so it has to control it.
      super(str, safe_level, trim_mode, Receiver::RENDERED_TEMPLATE)
    end

    # @param b [Binding] the binding to use for rendering.
    # @return [ERBB::Result] a string decorated with named blocks
    def result(b=new_toplevel)
      # recent versions of ruby implement a receiver method. use that if
      # possible, otherwise yoink 'self' out of the binding context.
      receiver = b.respond_to?(:receiver) ? b.receiver : b.send(:eval, "self")

      # decorate the receiver with the new erbb methods
      receiver.instance_exec { extend ERBB::Receiver }

      # Render the template using the binding taken from the receiver
      result = ERBB::Result.new(
        super(b),
        receiver.instance_variable_get(Receiver::RENDERED_BLOCKS)
      )
    end
  end
end
