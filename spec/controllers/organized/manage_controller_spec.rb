require "rails_helper"

RSpec.describe Organized::ManageController, type: :controller do
  context "given an authenticated ambassador" do
    include_context :logged_in_as_ambassador

    it "redirects to the organization root" do
      expect(get(:index, organization_id: organization)).to redirect_to(organization_root_path)
      expect(get(:locations, organization_id: organization)).to redirect_to(organization_root_path)
      expect(get(:update, organization_id: organization, id: 1)).to redirect_to(organization_root_path)
      expect(get(:destroy, organization_id: organization, id: 1)).to redirect_to(organization_root_path)
    end
  end

  context "logged_in_as_organization_member" do
    include_context :logged_in_as_organization_member
    describe "index" do
      it "redirects to the organization root path" do
        get :index, organization_id: organization.to_param
        expect(response).to redirect_to(organization_root_path)
        expect(flash[:error]).to be_present
      end
    end

    describe "locations" do
      it "redirects to the organization root path" do
        get :locations, organization_id: organization.to_param
        expect(response).to redirect_to(organization_root_path)
        expect(flash[:error]).to be_present
      end
    end

    describe "standard organization" do
      it "does not destroy" do
        expect do
          delete :destroy, id: organization.id, organization_id: organization.to_param
        end.to change(Organization, :count).by(0)
        expect(response).to redirect_to(organization_root_path)
        expect(flash[:error]).to be_present
      end
    end
  end
  context "logged_in_as_organization_admin" do
    include_context :logged_in_as_organization_admin
    describe "index" do
      it "renders, sets active organization" do
        session[:passive_organization_id] = "XXXYYY"
        get :index, organization_id: organization.to_param
        expect(response.status).to eq(200)
        expect(response).to render_template :index
        expect(assigns(:current_organization)).to eq organization
        expect(assigns(:passive_organization)).to eq organization
        expect(session[:passive_organization_id]).to eq organization.id
      end
    end

    describe "landing" do
      it "renders" do
        session[:passive_organization_id] = "XXXYYY"
        get :landing, organization_id: organization.to_param
        expect(response.status).to eq(200)
        expect(assigns(:current_organization)).to eq organization
        expect(assigns(:passive_organization)).to eq organization
        expect(session[:passive_organization_id]).to eq organization.id
      end
    end

    describe "locations" do
      it "renders" do
        get :locations, organization_id: organization.to_param
        expect(response.status).to eq(200)
        expect(response).to render_template :locations
        expect(assigns(:current_organization)).to eq organization
      end
    end

    describe "update" do
      context "dissallowed attributes" do
        let(:org_attributes) do
          {
            available_invitation_count: 10,
            is_suspended: false,
            embedable_user_email: user.email,
            auto_user_id: user.id,
            show_on_map: false,
            api_access_approved: false,
            access_token: "stuff7",
            lock_show_on_map: true,
            is_paid: false,
          }
        end
        let(:user_2) { FactoryBot.create(:organization_member, organization: organization) }
        let(:update_attributes) do
          {
            # slug: 'short_name',
            slug: "cool name and stuffffff",
            available_invitation_count: "20",
            is_suspended: true,
            auto_user_id: user.id,
            embedable_user_email: user_2.email,
            api_access_approved: true,
            access_token: "things7",
            website: " www.drseuss.org",
            name: "some new name",
            kind: "bike_shop",
            is_paid: true,
            lock_show_on_map: false,
            show_on_map: true,
            locations_attributes: [],
          }
        end
        # Website is also permitted, but we're manually setting it
        let(:permitted_update_keys) { [:kind, :auto_user_id, :embedable_user_email, :name, :website] }
        before do
          expect(user_2).to be_present
          organization.update_attributes(org_attributes)
        end
        it "updates, sends message about maps" do
          put :update, organization_id: organization.to_param, id: organization.to_param, organization: update_attributes
          expect(response).to redirect_to organization_manage_index_path(organization_id: organization.to_param)
          expect(flash[:success]).to be_present
          organization.reload
          # Ensure we can update what we think we can
          (permitted_update_keys - [:website, :embedable_user_email, :auto_user_id, :kind]).each do |key|
            expect(organization.send(key)).to eq(update_attributes[key])
          end
          # Test that the website and auto_user_id are set correctly
          expect(organization.auto_user_id).to eq user_2.id
          expect(organization.website).to eq("http://www.drseuss.org")
          # Ensure we're protecting the correct attributes
          org_attributes.except(*permitted_update_keys).each do |key, value|
            expect(organization.send(key)).to eq value
          end
        end
      end
      context "with locations and normal show_on_map" do
        let(:state) { FactoryBot.create(:state) }
        let(:country) { state.country }
        let(:location_1) { FactoryBot.create(:location, organization: organization, street: "old street", name: "cool name") }
        let(:update_attributes) do
          {
            name: organization.name,
            show_on_map: true,
            short_name: "Something cool",
            kind: "ambassador",
            locations_attributes: {
              "0" => {
                id: location_1.id,
                name: "First shop",
                zipcode: "2222222",
                city: "First city",
                state_id: state.id,
                country_id: country.id,
                street: "some street 2",
                phone: "7272772727272",
                email: "stuff@goooo.com",
                latitude: 22_222,
                longitude: 11_111,
                organization_id: 844,
                shown: false,
                _destroy: 0,
              },
              Time.current.to_i.to_s => {
                created_at: Time.current.to_f.to_s,
                name: "Second shop",
                zipcode: "12243444",
                city: "cool city",
                state_id: state.id,
                country_id: country.id,
                street: "some street 2",
                phone: "7272772727272",
                email: "stuff@goooo.com",
                latitude: 22_222,
                longitude: 11_111,
                organization_id: 844,
                shown: false,
              },
            },
          }
        end
        before do
          expect(update_attributes).to be_present
          expect(organization.show_on_map).to be_falsey
          expect(organization.lock_show_on_map).to be_falsey
        end
        context "update" do
          it "updates and adds the locations and shows on map" do
            expect(organization.kind).to_not eq "ambassador"
            expect do
              put :update, organization_id: organization.to_param, id: organization.to_param, organization: update_attributes
            end.to change(Location, :count).by 1
            organization.reload
            expect(organization.show_on_map).to be_truthy
            expect(organization.kind).to_not eq "ambassador"
            # Existing location is updated
            location_1.reload
            expect(location_1.organization).to eq organization
            update_attributes[:locations_attributes]["0"].except(:latitude, :longitude, :organization_id, :shown, :created_at, :_destroy).each do |k, v|
              expect(location_1.send(k)).to eq v
            end
            # ensure we are not permitting crazy assignment for first location
            update_attributes[:locations_attributes]["0"].slice(:latitude, :longitude, :organization_id, :shown).each do |k, v|
              expect(location_1.send(k)).to_not eq v
            end

            # second location
            location_2 = organization.locations.last
            key = update_attributes[:locations_attributes].keys.last
            update_attributes[:locations_attributes][key].except(:latitude, :longitude, :organization_id, :shown, :created_at).each do |k, v|
              expect(location_2.send(k)).to eq v
            end
            # ensure we are not permitting crazy assignment for created location
            update_attributes[:locations_attributes][key].slice(:latitude, :longitude, :organization_id, :shown).each do |k, v|
              expect(location_1.send(k)).to_not eq v
            end
          end
        end

        context "matching short_name" do
          let!(:organization2) { FactoryBot.create(:organization, short_name: "cool short name") }
          it "doesn't update" do
            put :update,
                organization_id: organization.to_param,
                id: organization.to_param,
                organization: { kind: "property_management", short_name: "cool short name" }

            expect(assigns[:page_errors]).to be_present
            organization.reload
            expect(organization.short_name).to_not eq "cool short name"
            expect(organization.kind).to_not eq "property_management"
          end
        end

        context "removing a location" do
          it "removes the location" do
            update_attributes[:locations_attributes]["0"][:_destroy] = 1

            expect do
              put :update,
                  organization_id: organization.to_param,
                  id: organization.to_param,
                  organization: update_attributes.merge(kind: "bike_shop", short_name: "cool other name")
            end.to change(Location, :count).by 0

            organization.reload
            expect(Location.where(id: location_1.id).count).to eq 0
            expect(organization.short_name).to eq "cool other name"
          end
        end
      end
    end

    describe "destroy" do
      context "standard organization" do
        it "destroys" do
          expect_any_instance_of(AdminNotifier).to receive(:for_organization).with(organization: organization, user: user, type: "organization_destroyed")
          expect do
            delete :destroy, id: organization.id, organization_id: organization.to_param
          end.to change(Organization, :count).by(-1)
          expect(response).to redirect_to user_home_url
          expect(flash[:info]).to be_present
        end
      end
      context "paid organization" do
        it "does not destroy" do
          organization.update_attribute :is_paid, true
          expect do
            delete :destroy, id: organization.id, organization_id: organization.to_param
          end.to change(Organization, :count).by(0)
          expect(response).to redirect_to organization_manage_index_path(organization_id: organization.to_param)
          expect(flash[:info]).to be_present
        end
      end
    end
  end
end
