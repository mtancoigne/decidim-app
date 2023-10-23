# frozen_string_literal: true

require "spec_helper"
require "active_storage/downloadable"

RSpec.describe ActiveStorage::Downloadable do
  let(:file_to_upload) { "spec/fixtures/BuPa23_reglement-interieur.pdf" }
  let(:upload_sha) { Digest::SHA2.hexdigest(File.read(file_to_upload)) }
  let(:blob) { ActiveStorage::Blob.create_and_upload!(filename: "BuPa23_reglement-interieur.pdf", io: File.open(file_to_upload), content_type: "application/pdf") }

  describe "#open" do
    it "copies the file to the temporary directory" do
      blob.open do |file|
        aggregate_failures do
          expect(File.file?(file.path)).to be true
          expect(Digest::SHA2.hexdigest(File.read(file.path))).to eq upload_sha
        end
      end
    end
  end
end
