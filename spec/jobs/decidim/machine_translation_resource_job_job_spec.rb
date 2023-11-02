# frozen_string_literal: true

# require "spec_helper"
#
# class FakeTranslatableModel < ApplicationRecord
#   include Decidim::TranslatableResource
#
#   translatable_fields :title, :content, :author
# end
#
# RSpec.describe Decidim::MachineTranslationResourceJob, type: :job do
#   let(:resource) { FakeTranslatableModel }
#   let(:instance) { described_class.new }
#
#   describe '#perform' do
#   end
#
#   describe "#default_locale_changed_or_translation_removed" do
#
#   end
#
#   describe "#resource_field_value" do
#
#   end
#
#   describe "#default_locale" do
#     context "when resource has a relation to Organization" do
#       let(:organization) { Decidim::Organization.new default_locale: "ja" }
#
#       it "returns the organization's locale" do
#         allow(resource).to receive(:respond_to?).with(:organization).and_return true
#         allow(resource).to receive(:organization).and_return organization
#
#         expect(instance.default_locale(resource)).to eq "ja"
#       end
#     end
#
#     context "when resource don't have a relation to Organization" do
#       it "returns the first available locale" do
#         expect(instance.default_locale(resource)).to eq "en"
#       end
#     end
#   end
#
#   describe "#translated_locales_list" do
#
#   end
#
#   describe "#remove_duplicate_translations" do
#
#   end
#
#   describe "#pending_locales" do
#
#   end
# end
