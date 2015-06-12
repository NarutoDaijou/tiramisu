require 'tty-progressbar'
require 'tty-screen'
require 'pastel'

module Clover
  extend self

  DEFAULT_PATTERN = '{spec,test}/**/{*_spec.rb,*_test.rb}'.freeze
  GLOBAL_SETUPS = []

  AssertionFailure = Struct.new(:object, :arguments, :caller)
  GenericFailure   = Struct.new(:reason, :caller)
  Skip = Struct.new(:reason, :caller)

  INDENT = '  '.freeze
  PASTEL = Pastel.new
  %w[
    red
    bright_red
    green
    blue
    cyan
    magenta
    bold
    underline
  ].each {|m| define_method(m) {|*a| PASTEL.__send__(m, *a)}}

  def units
    @units ||= []
  end

  def assertions
    @assertions ||= {}
  end

  def skips
    @skips ||= []
  end

  def define_spec label, block
    define_unit_class(:spec, label, block, [].freeze)
  end

  def define_and_register_a_spec label, block
    units << define_spec(label, block)
  end

  def define_context label, block, parent
    define_unit_class(:context, label, block, [*parent.__ancestors__, parent].freeze)
  end

  def define_and_register_a_context label, block, parent
    units << define_context(label, block, parent)
  end

  # define a class that will hold contexts and tests
  #
  # @param  [Proc] block
  # @param  [String, Symbol] label
  # @param  [String, Symbol] type
  # @param  [Array] ancestors
  # @return [Unit]
  def define_unit_class type, label, block, ancestors
    identity = identity_string(type, label, block).freeze
    Class.new Unit do
      define_singleton_method(:__ancestors__) {ancestors}
      define_singleton_method(:__identity__) {identity}
      Clover::GLOBAL_SETUPS.each {|b| class_exec(&b)}
      # execute given block only after global setups executed and all utility methods defined
      result = catch(:__clover_skip__) {class_exec(&block)}
      Clover.skips << result if result.is_a?(Skip)
    end
  end

  # define a module that when included will execute the given block on base
  #
  # @param  [Proc] block
  # @return [Module]
  def define_unit_module block
    block || raise(ArgumentError, 'missing block')
    Module.new do
      # any spec/context that will include this module will "inherit" it's logic
      #
      # @example
      #   EnumeratorSpec = spec 'Enumerator tests' do
      #     # some tests here
      #   end
      #
      #   spec Array do
      #     include EnumeratorSpec
      #   end
      #
      #   spec Hash do
      #     include EnumeratorSpec
      #   end
      #
      define_singleton_method(:included) {|b| b.class_exec(&block)}
    end
  end

  def void_hooks
    {before: {}, around: {}, after: {}}
  end
end

require 'clover/core_ext'
require 'clover/util'
require 'clover/unit'
require 'clover/assert'
require 'clover/run'
