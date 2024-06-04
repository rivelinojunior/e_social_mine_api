# frozen_string_literal: true

ActiveModel::Serializer.config.tap do |config|
  config.serializer_lookup_enabled = false
  config.serializer_path = ['app/controllers/api/v1/serializers']
end
