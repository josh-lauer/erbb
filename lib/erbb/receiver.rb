module ERBB
  # Used to decorate the binding receiver with methods we want available in the
  # template that are not defined on the binding receiver.
  module Receiver
    # The name of the ivar to use for storing the rendered template output
    RENDERED_TEMPLATE = '@_erbb_out'.freeze

    # When called within a template, defines a named_block. Repeated calls to
    # a block with the same name within a template will be concatenated in the
    # order in which they appear in the template.
    def named_block(block_name, *args, &block)
      # dup the output so far and save it
      original_output = __erbb_get_rendered_template.dup

      # wipe the template output ivar
      __erbb_set_rendered_template("")

      # render the block, populating the ivar with the result
      yield(*args)

      # concatenate the rendered output from the named block into the hash
      named_blocks[block_name.to_sym] ||= ""
      named_blocks[block_name.to_sym] << __erbb_get_rendered_template

      # restore the template output ivar to its original value plus this block
      __erbb_set_rendered_template(original_output + __erbb_get_rendered_template)
    end

    # @return [Hash] The blocks
    def named_blocks
      @_erbb_named_blocks ||= {}
    end

    private

    def __erbb_get_rendered_template
      instance_variable_get(RENDERED_TEMPLATE)
    end

    def __erbb_set_rendered_template(str)
      instance_variable_set(RENDERED_TEMPLATE, str)
    end
  end
end
