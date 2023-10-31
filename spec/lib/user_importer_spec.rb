# frozen_string_literal: true

require "spec_helper"

require "user_importer"

RSpec.describe UserImporter do
  let(:valid_file) { Rails.root.join('spec/fixtures/user_import_valid.csv') }
  let(:invalid_file) { Rails.root.join('spec/fixtures/user_import_invalid.csv') }
  let(:file) { valid_file }
  let(:org) { create :organization }
  let(:admin) { create :user }
  let(:other_user) { create :user }
  let(:process) { create :participatory_process }
  let(:instance) { described_class.new file, org&.id, admin&.id, process&.id }

  describe "#validate_input" do
    it "works" do
      skip "write tests"
    end
  end

  describe "#validate_org" do
    context "with invalid value" do
      let(:org) { nil }

      it "exits brutally" do
        expect do
          instance.validate_org
        end.to raise_error SystemExit
      end
    end

    it "works" do
      skip "write tests"
    end
  end

  describe "#validate_admin" do
    context "with invalid value" do
      let(:admin) { nil }

      it "exits brutally" do
        expect do
          instance.validate_admin
        end.to raise_error SystemExit
      end
    end

    it "works" do
      skip "write tests"
    end
  end

  describe "#validate_process" do
    context "with invalid value" do
      let(:process) { nil }

      it "exits brutally" do
        expect do
          instance.validate_process
        end.to raise_error SystemExit
      end
    end
    it "works" do
      skip "write tests"
    end
  end

  describe "#validate_file" do
    context "when file does not exist" do
      let(:file) { "/some/inexistant_file.csv" }

      it "exits brutally" do
        expect do
          instance.validate_file
        end.to raise_error SystemExit
      end
    end

    it "works" do
      skip "write tests"
    end
  end

  describe "#import_data" do
    it "works" do
      skip "write tests"
    end
  end

  describe "#import_without_email" do
    it "works" do
      skip "write tests"
    end
  end

  describe "#import_with_email" do
    context "with invalid data" do
      #                  id, name, last_name, email
      let(:arguments) { [nil, nil, nil, nil] }

      it "exits brutally" do
        expect do
          instance.import_with_email(*arguments)
        end.to raise_error SystemExit
      end

      it "does not create the user" do
        expect do
          instance.import_with_email(*arguments)
        end.not_to change(Decidim::ParticipatorySpacePrivateUser, :count)
      end
    end

    context "with valid data" do
      context "when user exists" do
        let(:arguments) { [other_user.id, "Alice", "Liddell", "alice@wonderland.org"] }

        it "updates the user" do
          instance.import_with_email(*arguments)
          other_user.reload

          aggregate_failures do
            expect(other_user.name).to eq "Alice Liddell"
            expect(other_user.email).to eq "alice@wonderland.org"
          end
        end

        it "does not create user" do
          expect do
            instance.import_with_email(*arguments)
          end.not_to change(Decidim::ParticipatorySpacePrivateUser, :count)
        end
      end

      context "when user does not exist" do
        let(:arguments) { [10, "Alice", "Liddell", "alice@wonderland.org"] }

        it "creates the user" do
          expect do
            instance.import_with_email(*arguments)
          end.to change(Decidim::ParticipatorySpacePrivateUser, :count).by 1
        end
      end
    end
  end

  describe "#set_name" do
    it "concatenate strings" do
      expect(instance.set_name("John", "Mambo")).to eq "John Mambo"
    end

    it "strips extra whitespaces" do
      aggregate_failures do
        expect(instance.set_name("", "")).to eq ""
        expect(instance.set_name(" John", "")).to eq "John"
        expect(instance.set_name(" John  ", "  Mambo  ")).to eq "John Mambo"
      end
    end
  end

  describe "#current_user" do
    it "returns the right entity" do
      expect(instance.current_user).to eq admin
    end
  end

  describe "#current_organization" do
    it "returns the right entity" do
      expect(instance.current_organization).to eq org
    end
  end

  describe "#current_process" do
    it "returns the right entity" do
      expect(instance.current_process).to eq process
    end
  end

  describe "#read_csv" do
    context "with invalid data" do
      let(:file) { invalid_file }

      it "exits brutally" do
        expect do
          instance.read_csv
        end.to raise_error SystemExit
      end
    end

    it "sets line count" do
      instance.read_csv

      expect(instance.line_count).to eq 5
    end

    it "sets csv" do
      instance.read_csv

      expect(instance.csv).to be_a CSV::Table
    end
  end
end
