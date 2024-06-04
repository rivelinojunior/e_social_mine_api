# frozen_string_literal: true

require 'solid/result'

Solid::Result.configuration do |config|
  config.constant_alias.enable!('Result')
end
