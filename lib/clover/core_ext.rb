module Kernel

  # when called with a no-nil no-false argument it defines, register and returns a spec.
  # when called with a nil or false argument it defines and returns a spec but does not register it.
  # when called without arguments it defines a global setup that will run on each new created spec/context.
  #
  # @note a Unit Module is a regular Ruby Module that when included will execute the Unit's block on base
  #
  # @example define regular specs
  #   spec :some_spec do
  #     # ...
  #   end
  #
  # @example define a spec that will run on its own and can also be included into another specs/contexts
  #   shared = spec :some_shared_spec do
  #     # ...
  #   end
  #   # `shared` is now a spec good for inclusion in another specs/contexts.
  #
  # @example define a spec that wont run on itself but can be included into another specs/contexts
  #   Shared = spec nil do
  #     # ...
  #   end
  #   # `Shared` is now a module good for inclusion in another specs/contexts
  #   # but because `nil` used as first argument it wont run as a spec itself
  #
  # @example define a global setup, i.e. a block that will run inside any new defined spec/context
  #   spec do
  #     include Rack::Test # now Rack::Test will be included in any spec/context
  #   end
  #
  def spec label = (noargs=true; nil), &block
    block || raise(ArgumentError, 'missing block')

    if noargs
      # no arguments given, defining a global setup and returning
      return Clover::GLOBAL_SETUPS << block
    end

    if label
      # a no-nil no-false argument given, defining a regular spec
      Clover.define_and_register_a_spec(label, block)
    end

    # defining a shared spec that wont run itself
    # but can be included in another specs/contexts
    Clover.define_unit_module(block)
  end
end
