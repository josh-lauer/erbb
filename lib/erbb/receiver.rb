module ERBB
  # Used to decorate the binding receiver with methods we want available in the
  # template that are not defined on the binding receiver.
  module Receiver
    # The name of the ivar to use for storing the rendered template output
    RENDERED_TEMPLATE = '@_erbb_out'
    # The name of the ivar to use for storing the hash of named block outputs
    RENDERED_BLOCKS = '@_erbb_named_blocks'

    # When called within a template, defines a named_block.
    def named_block(block_name, *args, &block)
      # dup the output so far and save it
      original_output = __erbb_get_rendered_template.dup

      # wipe the template output ivar
      __erbb_set_rendered_template("")

      # render the block, populating the ivar with the result
      yield(*args)

      # copy the rendered output from the named block into the hash
      __erbb_rendered_blocks[block_name] << __erbb_get_rendered_template

      # restore the template output ivar to its original value plus this block
      __erbb_set_rendered_template(original_output + __erbb_get_rendered_template)
    end

    private

    def __erbb_get_rendered_template
      instance_variable_get(RENDERED_TEMPLATE)
    end

    def __erbb_set_rendered_template(str)
      instance_variable_set(RENDERED_TEMPLATE, str)
    end

    # @return [Hash]
    def __erbb_rendered_blocks
      # lazily create and memoize the hash to store rendered blocks
      if instance_variable_defined?(RENDERED_BLOCKS)
        instance_variable_get(RENDERED_BLOCKS)
      else
        instance_variable_set(RENDERED_BLOCKS, Hash.new { |h,k| h[k.to_sym] = "" })
      end
    end
  end
end
