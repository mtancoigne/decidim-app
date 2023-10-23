# frozen_string_literal: true

module Decidim
  module TranslatorConfigurationHelper
    # FIXME: This method returns "true" or raises an exception, but never returns "false"
    #        It may better be renamed as something like "check_seed_ability!", "enforce_seeding_ability!"
    #        or anything more imperative.
    def self.able_to_seed?
      return true unless translator_activated?

      raise "You can't seed the database with machine translations enabled unless you use a compatible backend" unless compatible_backend?
    end

    def self.compatible_backend?
      Rails.configuration.active_job.queue_adapter != :async
    end

    def self.translator_activated?
      Decidim.enable_machine_translations
    end
  end
end
