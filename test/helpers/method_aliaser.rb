# Tools for aliasing methods of a given target object
#
# This tool is currently being used for mocking of classes for
# RSpec / Cucumber purposes
module MethodAliaser
  def alias_it(target, source_name, alias_name = nil, &block)
    if !alias_name
      begin
        alias_name = "__#{source_name}_#{rand(99999)}"
      end while target.respond_to?(alias_name)
    end

    raise(ArgumentError, :existing_method) if target.respond_to?(alias_name)

    target.instance_exec do
      alias_method alias_name, source_name

      define_method(source_name) do |*define_arguments|
        block.call( lambda { |*lambda_args| self.send(alias_name, *lambda_args) }, *define_arguments)
      end
    end

    AliasedMethod.new(target, source_name, alias_name)
  end

  def unalias_it(target, source_name, alias_name)
    target.instance_exec do
      alias_method source_name, alias_name
      remove_method alias_name
    end
  end

  extend self

  class AliasedMethod
    attr_reader :target, :source_name, :alias_name

    def initialize(target, source_name, alias_name)
      @target = target
      @source_name = source_name
      @alias_name = alias_name
    end

    def unalias_it
      MethodAliaser.unalias_it(target, source_name, alias_name)
    end
  end
end