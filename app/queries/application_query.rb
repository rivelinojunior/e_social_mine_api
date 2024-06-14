# frozen_string_literal: true

class ApplicationQuery
  def self.query(**args) = new(**args).query

  def query = raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"

  private_class_method :new
end
