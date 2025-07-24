# frozen_string_literal: true

# Creates class methods dynamically by using instance methods.
# Allowing you to call instance methods without using #new(args)
# Add extend ServiceHelper on the class definition to use.
module ServiceHelper
  # when a class method is not found on the class.
  # If an instance method exists with the same name, this method
  # defines a class-level version that delegates to a new instance.
  def method_missing(method_name, *args, &block)
  if instance_methods.include?(method_name)
    define_singleton_method(method_name) do |*method_args, &method_block|
      new(*method_args).public_send(method_name, &method_block)
    end

    send(method_name, *args, &block)
  else
    super
  end
end

  # Ensures `respond_to?` behaves correctly with delegated methods.
  def respond_to_missing?(method_name, include_private = false)
    instance_methods.include?(method_name) || super
  end
end
