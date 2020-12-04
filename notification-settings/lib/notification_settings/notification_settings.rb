# frozen_string_literal: true

require 'active_support'
require 'hashie'

module NotificationSettings
  module NotificationSettings
    extend ActiveSupport::Concern

    included do
      before_validation :build_settings

      serialize :notification_settings, Hashie::Mash

      include NotificationSettings::NotificationSettings::InstanceMethods
    end

    module InstanceMethods
      private

      def build_settings
        return if notification_settings.present? && notification_settings.is_a?(Hashie::Mash)

        self.notification_settings = Hashie::Mash.new
      end
    end
  end
end
