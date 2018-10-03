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
    # @param  eoutvar [Nil] if the user passes a 4th arg, error
    def initialize(str, safe_level=nil, trim_mode='>', eoutvar=nil)
      # The fourth arg is the name of the variable defined on the receiver
      # which is used to store the rendered output when parsing a template.
      # ERBB works by exploiting that, so it has to control it.
      raise ArgumentError, "In ERBB, the template ivar can’t be set" if eoutvar
      super(str, safe_level, trim_mode, Receiver::RENDERED_TEMPLATE)
    end

    # @see https://ruby-doc.org/stdlib-2.5.1/libdoc/erb/rdoc/ERB.html#method-i-result
    # @param b [Binding] the binding to use for rendering.
    # @return [ERBB::Result] a string decorated with named blocks
    def result(b=new_toplevel)
      receiver = extract_receiver_from_binding(b)

      # Render the template using the binding and return the result along with
      #   the output of any named blocks.
      ERBB::Result.new(
        super(b),
        receiver.named_blocks
      )
    end

    private

    # @param b [Binding] the binding to use to find its implicit receiver.
    def extract_receiver_from_binding(b)
      # yoink 'self' out of the binding context.
      b.send(:eval, "self").tap do |receiver|
        # decorate it before returning to so erbb methods work in templates.
        receiver.instance_exec { extend ERBB::Receiver }
      end
    end
  end
end
