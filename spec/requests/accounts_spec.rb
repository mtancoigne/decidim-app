# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Account", type: :request do
  describe "DELETE /account" do
    let(:visit_url) { delete decidim.account_url }

    context "when user has the right permissions" do
      it "returns a successful response" do
        skip "write this"
      end

      it "signs the user out" do
        skip "write this"
      end

      it "destroys the France connect session" do
        skip "write this"
      end

      it "displays a success message" do
        skip "write this"
      end

      it "redirects the user" do
        skip "write this"
      end
    end

    context "when user don't have the right permissions" do
      it "displays an error message" do
        skip "write this"
      end

      it "redirects the user" do
        skip "write this"
      end
    end

    context "when visitor is anonymous" do
      it "redirects the user to sign-in page" do
        visit_url
        expect(response).to redirect_to(decidim.new_user_session_url)
      end
    end
  end
end
