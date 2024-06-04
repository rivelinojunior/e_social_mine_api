# frozen_string_literal: true

class ApplicationCommand
  def self.call(**args) = new(**args).call

  def call = raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"

  private_class_method :new
end
