require "spec_helper"
require 'util/extensions/miq-kernel'

describe Kernel do
  context '.add_to_load_path' do
    before(:each) do
      @original = $LOAD_PATH.dup
      @new_path = "#{File.dirname(__FILE__)}/.."
      @expected = @original.dup.push(File.expand_path(@new_path))
      add_to_load_path @new_path
    end

    after(:each) do
      $LOAD_PATH.replace(@original)
    end

    it 'will add the path if it is not already there' do
      $LOAD_PATH.should == @expected
    end

    it 'will ignore the path if it is already there' do
      add_to_load_path @new_path
      $LOAD_PATH.should == @expected
    end
  end

  it ".require_relative" do
    Kernel.respond_to?(:require_relative).should be_true
  end
end
