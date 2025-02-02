require "rails_helper"

RSpec.describe InfoController, type: :controller do
  describe "revised views" do
    pages = %w(about protect_your_bike where serials image_resources resources
               dev_and_design support_bike_index terms vendor_terms privacy lightspeed)
    context "no user" do
      pages.each do |page|
        context "#{page} with revised_layout enabled" do
          it "renders with revised_layout" do
            get page.to_sym
            expect(response.status).to eq(200)
            expect(response).to render_template(page.to_sym)
            if page == "support_bike_index"
              expect(response).to render_template("layouts/payments_layout")
            else
              expect(response).to render_template("layouts/application")
            end
          end
        end
      end
    end
    context "signed in user" do
      let(:user) { FactoryBot.create(:user_confirmed) }
      # Since we're rendering things, and these are important pages,
      # let's test with users as well
      before do
        set_current_user(user)
      end
      pages.each do |page|
        context "#{page} with revised_layout enabled" do
          it "renders with revised_layout" do
            get page.to_sym
            expect(response.status).to eq(200)
            expect(response).to render_template(page.to_sym)
            if page == "support_bike_index"
              expect(response).to render_template("layouts/payments_layout")
            else
              expect(response).to render_template("layouts/application")
            end
          end
        end
      end
    end
  end
end
