require 'spec_helper'

class A
  def value(v = nil)
    v || 'a'
  end
end

describe MethodAliaser do
  after(:each) do
    # undo a previously applied alias
    while @aliased && ! @aliased.empty?
      @aliased.shift.unalias_it
    end
  end

  def alias_value(&block)
    @aliased ||= []
    @aliased << MethodAliaser.alias_it(A, :value, &block)
  end

  def new_value
    A.new.value
  end

  def new_value_with_parameter(p)
    A.new.value(p)
  end

  it "Can Alias Method To Return Nil" do
    alias_value { |aliased, *arguments| }

    new_value().should == nil
  end

  it "Can Alias Method To Return Aribitrary Value" do
    alias_value { |aliased, *arguments| "b" }

    new_value().should == "b"
  end

  it "Can Have Alias Implementation Delegate To The Original Method" do
    alias_value { |aliased, *arguments| aliased.call(*arguments) }

    new_value().should == "a"
  end

  it "Can Have Alias Implementation Use The Original Method Return Value In It's Return Value'" do
    alias_value { |aliased, *arguments| "#{aliased.call(*arguments)}b" }

    new_value.should == "ab"
  end

  it "Can Pass The Arguments To the Original Method" do
    alias_value { |aliased, *arguments| "#{aliased.call(*arguments)}"}

    new_value_with_parameter("b").should == "b"
  end

  it "Can Overwrite Arguments When Calling The Original Method" do
    alias_value { |aliased, *arguments| "#{aliased.call(*['c'])}"}

    new_value_with_parameter("b").should == "c"
  end

  it "Can Have An Alias Implementation That Removes Itself" do
    wrapped = MethodAliaser.alias_it(A, :value) do |aliased, *arguments|
      wrapped.unalias_it

      "b"
    end

    A.new.value.should == 'b'
    A.new.value.should == 'a'
    A.new.value.should == 'a'
  end

  it "Can Nest Multiple Alias Implementations That Removes Itself" do
    wrapped1 = MethodAliaser.alias_it(A, :value) do |aliased, *arguments|
      wrapped1.unalias_it

      "b"
    end

    wrapped2 = MethodAliaser.alias_it(A, :value) do |aliased, *arguments|
      wrapped2.unalias_it

      "c"
    end

    A.new.value.should == 'c'
    A.new.value.should == 'b'
    A.new.value.should == 'a'
    A.new.value.should == 'a'
  end
end