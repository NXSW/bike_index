require "rails_helper"

RSpec.describe Organized::StickersController, type: :controller do
  let(:root_path) { organization_bikes_path(organization_id: organization.to_param) }
  let(:stickers_root_path) { organization_stickers_path(organization_id: organization.to_param) }
  let!(:bike_code) { FactoryBot.create(:bike_code, organization: organization, code: "partee") }

  before { set_current_user(user) if user.present? }

  context "organization without bike_codes" do
    let!(:organization) { FactoryBot.create(:organization) }
    context "logged in as organization admin" do
      let(:user) { FactoryBot.create(:organization_admin, organization: organization) }
      describe "index" do
        it "redirects" do
          get :index, organization_id: organization.to_param
          expect(response).to redirect_to root_path
        end
      end
      describe "edit" do
        it "redirects" do
          get :edit, id: bike_code.code, organization_id: organization.to_param
          expect(flash[:error]).to be_present
          expect(response).to redirect_to root_path
        end
      end
    end

    context "logged in as super admin" do
      let(:user) { FactoryBot.create(:admin) }
      describe "index" do
        it "renders" do
          get :index, organization_id: organization.to_param
          expect(response).to render_template(:index)
          expect(assigns(:current_organization)).to eq organization
        end
      end
    end
  end

  context "organization with bike_codes" do
    let(:organization) { FactoryBot.create(:organization) }
    let(:user) { FactoryBot.create(:organization_member, organization: organization) }
    before { organization.update_column :paid_feature_slugs, ["bike_codes"] }

    context "logged in as organization member" do
      describe "index" do
        it "renders" do
          get :index, organization_id: organization.to_param
          expect(response).to render_template(:index)
          expect(assigns(:current_organization)).to eq organization
          expect(assigns(:bike_codes).pluck(:id)).to eq([bike_code.id])
        end
        context "with query search" do
          let!(:bike_code_claimed) { FactoryBot.create(:bike_code, organization: organization, code: "part") }
          let!(:bike_code_no_org) { FactoryBot.create(:bike_code, code: "part") }
          before { bike_code_claimed.claim(user, FactoryBot.create(:bike).id) }
          it "renders" do
            get :index, organization_id: organization.to_param, claimedness: "unclaimed", query: "part"
            expect(response).to render_template(:index)
            expect(assigns(:current_organization)).to eq organization
            expect(assigns(:bike_codes).pluck(:id)).to eq([bike_code.id])
          end
        end
        context "with bike_query" do
          let!(:bike) { FactoryBot.create(:bike) }
          let!(:bike_code_claimed) { FactoryBot.create(:bike_code, organization: organization, code: "part") }
          before { bike_code_claimed.claim(user, bike.id) }
          it "renders" do
            expect(BikeCode.where(bike_id: bike.id).pluck(:id)).to eq([bike_code_claimed.id])
            get :index, organization_id: organization.to_param, bike_query: "https://bikeindex.org/bikes/#{bike.id}/edit?cool=stuff"
            expect(response).to render_template(:index)
            expect(assigns(:current_organization)).to eq organization
            expect(assigns(:bike_codes).pluck(:id)).to eq([bike_code_claimed.id])
          end
        end
      end

      describe "edit" do
        it "renders" do
          get :edit, id: bike_code.code, organization_id: organization.to_param
          expect(response).to render_template(:edit)
          expect(assigns(:current_organization)).to eq organization
        end
      end

      describe "update" do
        let(:bike) { FactoryBot.create(:bike) }
        let(:bike_code) { FactoryBot.create(:bike_code_claimed, bike_id: bike.id, organization_id: organization.id) }
        let(:bike2) { FactoryBot.create(:bike) }
        it "updates" do
          bike2.reload
          expect(bike2.organizations.pluck(:id)).to eq([])
          put :update, id: bike_code.code, organization_id: organization.id, bike_code: { bike_id: "https://bikeindex.org/bikes/#{bike2.id} " }
          expect(assigns(:current_organization)).to eq organization
          expect(flash[:success]).to be_present
          expect(response).to redirect_to bike_path(bike2)
          bike_code.reload
          expect(bike_code.bike_id).to eq bike2.id
          expect(bike_code.previous_bike_id).to eq bike.id
          bike2.reload
          expect(bike2.organizations.pluck(:id)).to eq([organization.id])
        end
        context "passed code rather than id" do
          it "updates" do
            request.env["HTTP_REFERER"] = bike_path(bike2)
            put :update, id: "code", organization_id: organization.id, bike_code: { bike_id: bike2.id, code: bike_code.code }
            expect(assigns(:current_organization)).to eq organization
            expect(flash[:success]).to be_present
            expect(response).to redirect_to bike_path(bike2)
            bike_code.reload
            expect(bike_code.bike_id).to eq bike2.id
            expect(bike_code.previous_bike_id).to eq bike.id
          end
          context "code blank" do
            it "redirects back" do
              request.env["HTTP_REFERER"] = bike_path(bike2)
              put :update, id: "code", organization_id: organization.id, bike_code: { bike_id: bike2.id, code: "" }
              expect(assigns(:current_organization)).to eq organization
              expect(flash[:error]).to be_present
              bike_code.reload
              expect(bike_code.bike_id).to eq bike.id
            end
          end
          context "incomplete code" do
            let(:bike_code) { FactoryBot.create(:bike_code, bike_id: bike.id, organization_id: organization.id, code: "AA0000151515") }
            it "updates" do
              request.env["HTTP_REFERER"] = bike_path(bike2)
              put :update, id: "code", organization_id: organization.id, bike_code: { bike_id: bike2.id, code: "151515" }
              expect(assigns(:current_organization)).to eq organization
              expect(flash[:success]).to be_present
              expect(response).to redirect_to bike_path(bike2)
              bike_code.reload
              expect(bike_code.bike_id).to eq bike2.id
              expect(bike_code.previous_bike_id).to eq bike.id
            end
          end
        end
        context "other organization bike_code" do
          let(:bike_code) { FactoryBot.create(:bike_code, bike_id: bike.id) }
          it "responds with flash error" do
            put :update, id: bike_code.code, bike_id: bike2.id, organization_id: organization.id
            expect(flash[:error]).to be_present
            expect(response).to redirect_to stickers_root_path
            bike_code.reload
            expect(bike_code.bike.id).to eq bike.id
          end
        end
        context "nil bike_id" do
          it "updates and removes the assignment" do
            put :update, id: bike_code.code, bike_id: nil, organization_id: organization.id
            expect(flash[:success]).to be_present
            expect(response).to redirect_to edit_organization_sticker_path(organization_id: organization.to_param, id: bike_code.code)
            bike_code.reload
            expect(bike_code.claimed_at).to be_nil
            expect(bike_code.bike_id).to be_nil
            expect(bike_code.user_id).to be_nil
            expect(bike_code.previous_bike_id).to eq bike.id
          end
        end
      end
    end
  end
end
