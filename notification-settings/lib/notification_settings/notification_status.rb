# frozen_string_literal: true

require 'active_support'

module NotificationSettings
  module NotificationStatus
    extend ActiveSupport::Concern

    included do
      validates :notification_status,
                inclusion: { in: NotificationSettings.configuration.notification_statuses }

      include NotificationSettings::NotificationStatus::InstanceMethods
    end

    module InstanceMethods
      def notification_status
        self[:notification_status] || default_status
      end

      private

      def default_status
        if idle? && !offline?
          'idle'
        elsif offline?
          'offline'
        else
          'online'
        end
      end

      def idle?
        return unless time_since_last_seen_round

        time_since_last_seen_round >= idle_after
      end

      def offline?
        return unless time_since_last_seen_round

        time_since_last_seen_round >= offline_after
      end

      def time_since_last_seen_round
        time_since_last_seen&.round
      end

      def time_since_last_seen
        return unless respond_to?(NotificationSettings.configuration.last_seen)

        Time.now - send(NotificationSettings.configuration.last_seen)
      end

      def idle_after
        NotificationSettings.configuration.idle_after
      end

      def offline_after
        NotificationSettings.configuration.offline_after
      end
    end
  end
end
