require "rails_helper"

RSpec.describe "Bikes API V2", type: :request do
  let(:manufacturer) { FactoryBot.create(:manufacturer) }
  let(:color) { FactoryBot.create(:color) }
  include_context :existing_doorkeeper_app

  describe "find by id" do
    it "returns one with from an id" do
      bike = FactoryBot.create(:bike)
      get "/api/v2/bikes/#{bike.id}", format: :json
      expect(response.code).to eq("200")
      expect(json_result["bike"]["id"]).to eq(bike.id)
      expect(response.headers["Content-Type"].match("json")).to be_present
      expect(response.headers["Access-Control-Allow-Origin"]).to eq("*")
      expect(response.headers["Access-Control-Request-Method"]).to eq("*")
    end

    it "responds with missing" do
      get "/api/v2/bikes/10", format: :json
      expect(response.code).to eq("404")
      expect(json_result["error"].present?).to be_truthy
      expect(response.headers["Content-Type"].match("json")).to be_present
      expect(response.headers["Access-Control-Allow-Origin"]).to eq("*")
      expect(response.headers["Access-Control-Request-Method"]).to eq("*")
    end
  end

  describe "create" do
    let(:bike_attrs) do
      {
        serial: "69 non-example",
        manufacturer: manufacturer.name,
        rear_tire_narrow: "true",
        rear_wheel_bsd: "559",
        color: color.name,
        year: "1969",
        owner_email: "fun_times@examples.com",
      }
    end
    let!(:token) { create_doorkeeper_token(scopes: "read_bikes write_bikes") }
    before :each do
      FactoryBot.create(:wheel_size, iso_bsd: 559)
    end

    it "responds with 401" do
      post "/api/v2/bikes", bike_attrs.to_json
      expect(response.code).to eq("401")
    end

    it "fails if the token doesn't have write_bikes scope" do
      token.update_attribute :scopes, "read_bikes"
      post "/api/v2/bikes?access_token=#{token.token}", bike_attrs.to_json, json_headers
      expect(response.code).to eq("403")
    end

    context "special error" do
      let!(:color) { FactoryBot.create(:color, name: "White") }
      let!(:manufacturer) { FactoryBot.create(:manufacturer, name: "Trek") }
      let(:organization) { FactoryBot.create(:organization, name: "Pro's Closet", short_name: "tpc") }
      let(:user) { FactoryBot.create(:organization_member, organization: organization) }
      let(:bike_attrs) do
        {
          serial: "WTU171G0193G",
          manufacturer: "Trek",
          description: "2012 Trek Superfly 100 AL Elite Mountain Bike 19in 29\" Alloy Shimano XT 10s Fox",
          year: "2012",
          frame_material: "aluminum",
          owner_email: "developers@example.com",
          color: "white",
          frame_model: "Superfly 100 AL Elite",
          access_token: token.token,
          organization_slug: "TPC",
          external_image_urls: ["https://s3-us-west-2.amazonaws.com/theproscloset-img/BMT12479_BJ_01.jpg", "https://s3-us-west-2.amazonaws.com/theproscloset-img/BMT12479_BJ_02.jpg"],
          no_notify: true,
        }
      end
      it "creates" do
        VCR.use_cassette("bikes_v2-create-matching-bike-book", match_requests_on: [:path]) do
          expect do
            post "/api/v2/bikes?access_token=#{token.token}",
                 bike_attrs.to_json,
                 json_headers
          end.to change(Ownership, :count).by 1
          expect(response.code).to eq("201")
          result = json_result["bike"]
          expect(result["manufacturer_name"]).to eq bike_attrs[:manufacturer]
          %i[serial year frame_model].each do |k|
            pp k unless bike_attrs[k].downcase == result[k]&.to_s&.downcase
            expect(bike_attrs[k].downcase).to eq result[k].to_s.downcase
          end
          expect(result["description"]).to match bike_attrs[:description]
          expect(result["frame_colors"]).to eq(["White"])
          expect(result["frame_material_slug"]).to eq("aluminum")
          expect(result["components"].count).to be > 10
        end
      end
    end

    it "creates a non example bike, with components" do
      manufacturer = FactoryBot.create(:manufacturer)
      FactoryBot.create(:ctype, name: "wheel")
      FactoryBot.create(:ctype, name: "Headset")
      front_gear_type = FactoryBot.create(:front_gear_type)
      handlebar_type_slug = "bmx"
      components = [
        {
          manufacturer: manufacturer.name,
          year: "1999",
          component_type: "headset",
          description: "yeah yay!",
          serial_number: "69",
          model: "Richie rich",
        },
        {
          manufacturer: "BLUE TEETH",
          front_or_rear: "Both",
          component_type: "wheel",
        },
      ]
      bike_attrs.merge!(components: components,
                        front_gear_type_slug: front_gear_type.slug,
                        handlebar_type_slug: handlebar_type_slug,
                        is_for_sale: true,
                        is_bulk: true,
                        is_new: true,
                        is_pos: true)
      ActionMailer::Base.deliveries = []
      post "/api/v2/bikes?access_token=#{token.token}",
           bike_attrs.to_json,
           json_headers
      EmailOwnershipInvitationWorker.drain
      expect(ActionMailer::Base.deliveries.count).to eq 1
      expect(response.code).to eq("201")
      result = json_result["bike"]
      expect(result["serial"]).to eq(bike_attrs[:serial])
      expect(result["manufacturer_name"]).to eq(bike_attrs[:manufacturer])
      bike = Bike.find(result["id"])
      expect(bike.example).to be_falsey
      expect(bike.is_for_sale).to be_truthy
      expect(bike.components.count).to eq(3)
      expect(bike.components.pluck(:manufacturer_id).include?(manufacturer.id)).to be_truthy
      expect(bike.components.pluck(:ctype_id).uniq.count).to eq(2)
      expect(bike.components.map(&:cmodel_name).compact).to eq(["Richie rich"])
      expect(bike.front_gear_type).to eq(front_gear_type)
      expect(bike.handlebar_type).to eq(handlebar_type_slug)
      creation_state = bike.creation_state
      expect([creation_state.is_pos, creation_state.is_new, creation_state.is_bulk]).to eq([true, true, true])
      expect(creation_state.origin).to eq "api_v2"
      expect(creation_state.creator).to eq bike.creator
    end

    it "doesn't send an email" do
      ActionMailer::Base.deliveries = []
      post "/api/v2/bikes?access_token=#{token.token}",
           bike_attrs.merge(no_notify: true).to_json,
           json_headers
      EmailOwnershipInvitationWorker.drain
      expect(ActionMailer::Base.deliveries).to eq([])
      expect(response.code).to eq("201")
    end

    it "creates an example bike" do
      FactoryBot.create(:organization, name: "Example organization")
      ActionMailer::Base.deliveries = []
      post "/api/v2/bikes?access_token=#{token.token}",
           bike_attrs.merge(test: true).to_json,
           json_headers
      EmailOwnershipInvitationWorker.drain
      expect(ActionMailer::Base.deliveries.count).to eq 0
      expect(response.code).to eq("201")
      result = json_result["bike"]
      expect(result["serial"]).to eq(bike_attrs[:serial])
      expect(result["manufacturer_name"]).to eq(bike_attrs[:manufacturer])
      bike = Bike.unscoped.find(result["id"])
      expect(bike.creation_state.origin).to eq "api_v2"
      expect(bike.creation_state.creator).to eq bike.creator
      expect(bike.example).to be_truthy
      expect(bike.is_for_sale).to be_falsey
    end

    it "creates a stolen bike through an organization and uses the passed phone" do
      organization = FactoryBot.create(:organization)
      user.update_attribute :phone, "0987654321"
      FactoryBot.create(:membership_claimed, user: user, organization: organization)
      FactoryBot.create(:country, iso: "US")
      FactoryBot.create(:state, abbreviation: "NY")
      organization.save
      bike_attrs.merge!(organization_slug: organization.slug)
      date_stolen = 1357192800
      bike_attrs[:stolen_record] = {
        phone: "1234567890",
        date_stolen: date_stolen,
        theft_description: "This bike was stolen and that's no fair.",
        country: "US",
        city: "New York",
        street: "278 Broadway",
        zipcode: "10007",
        state: "NY",
        police_report_number: "99999999",
        police_report_department: "New York",
      # locking_description: "some locking description",
      # lock_defeat_description: "broken in some crazy way"
      }
      expect do
        post "/api/v2/bikes?access_token=#{token.token}",
             bike_attrs.to_json,
             json_headers
      end.to change(EmailOwnershipInvitationWorker.jobs, :size).by(1)
      result = json_result
      expect(result).to include("bike")
      expect(result["bike"]["serial"]).to eq(bike_attrs[:serial])
      expect(result["bike"]["manufacturer_name"]).to eq(bike_attrs[:manufacturer])
      expect(result["bike"]["stolen_record"]["date_stolen"]).to eq(date_stolen)
      bike = Bike.find(result["bike"]["id"])
      expect(bike.creation_organization).to eq(organization)
      expect(bike.creation_state.origin).to eq "api_v2"
      expect(bike.creation_state.organization).to eq organization
      expect(bike.creation_state.creator).to eq bike.creator
      expect(bike.stolen).to be_truthy
      expect(bike.current_stolen_record_id).to be_present
      expect(bike.current_stolen_record.police_report_number).to eq(bike_attrs[:stolen_record][:police_report_number])
      expect(bike.current_stolen_record.phone).to eq("1234567890")
    end
  end

  describe "create v2_accessor" do
    let(:organization) { FactoryBot.create(:organization) }
    let(:bike_attrs) do
      {
        serial: "69 non-example",
        manufacturer: manufacturer.name,
        rear_tire_narrow: "true",
        rear_wheel_bsd: "559",
        color: color.name,
        year: "1969",
        owner_email: "fun_times@examples.com",
        organization_slug: organization.slug,
      }
    end
    let!(:tokenized_url) { "/api/v2/bikes?access_token=#{v2_access_token.token}" }
    before { FactoryBot.create(:wheel_size, iso_bsd: 559) }

    it "also sets front wheel bsd" do
      FactoryBot.create(:membership_claimed, user: user, organization: organization, role: "admin")
      organization.save
      wheel_size_2 = FactoryBot.create(:wheel_size, iso_bsd: 622)
      additional_attrs = {
        front_wheel_bsd: 622,
        front_tire_narrow: false,
      }
      post tokenized_url, bike_attrs.merge(additional_attrs).to_json, json_headers
      result = json_result["bike"]
      expect(response.code).to eq("201")
      bike = Bike.find(result["id"])
      expect(bike.primary_frame_color).to eq color
      expect(bike.creator).to eq(user)
      expect(bike.rear_wheel_size.iso_bsd).to eq 559
      expect(bike.front_wheel_size).to eq wheel_size_2
      expect(bike.rear_tire_narrow).to be_truthy
      expect(bike.front_tire_narrow).to be_falsey
    end

    it "creates a bike for organization with v2_accessor" do
      FactoryBot.create(:membership_claimed, user: user, organization: organization, role: "admin")
      organization.save
      post tokenized_url, bike_attrs.to_json, json_headers
      result = json_result["bike"]
      expect(response.code).to eq("201")
      bike = Bike.find(result["id"])
      expect(bike.creation_organization).to eq(organization)
      expect(bike.creator).to eq(user)
      expect(bike.secondary_frame_color).to be_nil
      expect(bike.rear_wheel_size.iso_bsd).to eq 559
      expect(bike.front_wheel_size.iso_bsd).to eq 559
      expect(bike.rear_tire_narrow).to be_truthy
      expect(bike.front_tire_narrow).to be_truthy
      expect(bike.creation_state.origin).to eq "api_v2"
      expect(bike.creation_state.organization).to eq organization
      expect(bike.creation_state.creator).to eq bike.creator
    end

    it "doesn't create a bike without an organization with v2_accessor" do
      FactoryBot.create(:membership_claimed, user: user, organization: organization, role: "admin")
      organization.save
      bike_attrs.delete(:organization_slug)
      post tokenized_url, bike_attrs.to_json, json_headers
      expect(response.code).to eq("403")
      expect(json_result["error"].is_a?(String)).to be_truthy
    end

    it "fails to create a bike if the app owner isn't a member of the organization" do
      expect(user.has_membership?).to be_falsey
      post tokenized_url, bike_attrs.to_json, json_headers
      expect(response.code).to eq("403")
      expect(json_result["error"].is_a?(String)).to be_truthy
    end
  end

  describe "update" do
    let(:params) { { year: 1999, serial_number: "XXX69XXX" } }
    let(:url) { "/api/v2/bikes/#{bike.id}?access_token=#{token.token}" }
    let(:bike) { FactoryBot.create(:ownership, creator_id: user.id).bike }
    let!(:token) { create_doorkeeper_token(scopes: "read_user write_bikes") }

    it "doesn't update if user doesn't own the bike" do
      bike.current_ownership.update_attributes(user_id: FactoryBot.create(:user).id, claimed: true)
      expect_any_instance_of(Bike).to receive(:type).and_return("unicorn")
      put url, params.to_json, json_headers
      expect(response.body.match("do not own that unicorn")).to be_present
      expect(response.code).to eq("403")
    end

    it "doesn't update if not in scope" do
      token.update_attribute :scopes, "public"
      put url, params.to_json, json_headers
      expect(response.code).to eq("403")
      expect(response.body).to match(/oauth/i)
      expect(response.body).to match(/permission/i)
    end

    it "updates bike even if stolen record doesn't have important things" do
      FactoryBot.create(:country, iso: "US")
      expect(bike.year).to be_nil
      params[:stolen_record] = {
        phone: "",
        city: "Chicago",
      }
      put url, params.to_json, json_headers
      expect(response.code).to eq("200")
      bike.reload
      expect(bike.current_stolen_record.city).to eq "Chicago"
    end

    it "updates a bike, adds a stolen record, doesn't update locked attrs" do
      FactoryBot.create(:country, iso: "US")
      expect(bike.year).to be_nil
      serial = bike.serial_number
      params[:stolen_record] = {
        city: "Chicago",
        phone: "1234567890",
        police_report_number: "999999",
      }
      params[:owner_email] = "foo@new_owner.com"
      expect do
        put url, params.to_json, json_headers
      end.to change(Ownership, :count).by(1)
      expect(response.code).to eq("200")
      expect(bike.reload.year).to eq(params[:year])
      expect(bike.serial_number).to eq(serial)
      expect(bike.stolen).to be_truthy
      expect(bike.current_stolen_record.date_stolen.to_i).to be > Time.current.to_i - 10
      expect(bike.current_stolen_record.police_report_number).to eq("999999")
    end

    it "updates a bike, adds and removes components" do
      wheels = FactoryBot.create(:ctype, name: "wheel")
      headsets = FactoryBot.create(:ctype, name: "Headset")
      comp = FactoryBot.create(:component, bike: bike, ctype: headsets)
      comp2 = FactoryBot.create(:component, bike: bike, ctype: wheels)
      FactoryBot.create(:component)
      bike.reload
      expect(bike.components.count).to eq(2)
      components = [
        {
          manufacturer: manufacturer.slug,
          year: "1999",
          component_type: "headset",
          description: "Second component",
          serial_number: "69",
          model: "Richie rich",
        }, {
          manufacturer: "BLUE TEETH",
          front_or_rear: "Rear",
          description: "third component",
        }, {
          id: comp.id,
          destroy: true,
        }, {
          id: comp2.id,
          year: "1999",
          description: "First component",
        },
      ]
      expect do
        put url, params.merge(is_for_sale: true, components: components).to_json, json_headers
      end.to change(Ownership, :count).by(0)
      expect(response.code).to eq("200")
      bike.reload
      bike.components.reload
      expect(bike.is_for_sale).to be_truthy
      expect(bike.year).to eq(params[:year])
      expect(comp2.reload.year).to eq(1999)
      expect(bike.components.pluck(:cmodel_name)).to match_array([nil, nil, "Richie rich"])
      expect(bike.components.map(&:manufacturer_name).compact).to match_array(["BLUE TEETH", manufacturer.name])
      expect(bike.components.pluck(:manufacturer_id).include?(manufacturer.id)).to be_truthy
      expect(bike.components.count).to eq(3)
    end

    it "doesn't remove components that aren't the bikes" do
      FactoryBot.create(:manufacturer)
      comp = FactoryBot.create(:component, bike: bike)
      not_urs = FactoryBot.create(:component)
      components = [
        {
          id: comp.id,
          year: 1999,
        }, {
          id: not_urs.id,
          destroy: true,
        },
      ]
      params[:components] = components
      put url, params.to_json, json_headers
      expect(response.code).to eq("401")
      expect(response.headers["Content-Type"].match("json")).to be_present
      expect(bike.reload.components.reload.count).to eq(1)
      expect(bike.components.pluck(:year).first).to eq(1999) # Feature, not a bug?
      expect(not_urs.reload.id).to be_present
    end

    it "claims a bike and updates if it should" do
      expect(bike.year).to be_nil
      bike.current_ownership.update_attributes(owner_email: user.email, creator_id: FactoryBot.create(:user).id, claimed: false)
      expect(bike.reload.owner).not_to eq(user)
      put url, params.to_json, json_headers
      expect(response.code).to eq("200")
      expect(response.headers["Content-Type"].match("json")).to be_present
      expect(bike.reload.current_ownership.claimed).to be_truthy
      expect(bike.owner).to eq(user)
      expect(bike.year).to eq(params[:year])
    end
  end

  describe "image" do
    let!(:token) { create_doorkeeper_token(scopes: "read_user write_bikes") }
    it "doesn't post an image to a bike if the bike isn't owned by the user" do
      bike = FactoryBot.create(:ownership).bike
      file = File.open(File.join(Rails.root, "spec", "fixtures", "bike.jpg"))
      url = "/api/v2/bikes/#{bike.id}/image?access_token=#{token.token}"
      expect(bike.public_images.count).to eq(0)
      post url, file: Rack::Test::UploadedFile.new(file)
      expect(response.code).to eq("403")
      expect(response.headers["Content-Type"].match("json")).to be_present
      expect(bike.reload.public_images.count).to eq(0)
    end

    it "errors on non whitelisted extensions" do
      bike = FactoryBot.create(:ownership, creator_id: user.id).bike
      file = File.open(File.join(Rails.root, "spec", "spec_helper.rb"))
      url = "/api/v2/bikes/#{bike.id}/image?access_token=#{token.token}"
      expect(bike.public_images.count).to eq(0)
      post url, file: Rack::Test::UploadedFile.new(file)
      expect(response.body.match(/not allowed to upload .?.rb/i)).to be_present
      expect(response.code).to eq("401")
      expect(bike.reload.public_images.count).to eq(0)
    end

    it "posts an image" do
      bike = FactoryBot.create(:ownership, creator_id: user.id).bike
      file = File.open(File.join(Rails.root, "spec", "fixtures", "bike.jpg"))
      url = "/api/v2/bikes/#{bike.id}/image?access_token=#{token.token}"
      expect(bike.public_images.count).to eq(0)
      post url, file: Rack::Test::UploadedFile.new(file)
      expect(response.code).to eq("201")
      expect(response.headers["Content-Type"].match("json")).to be_present
      expect(bike.reload.public_images.count).to eq(1)
    end
  end

  describe "send_stolen_notification" do
    let(:bike) { FactoryBot.create(:ownership, creator_id: user.id).bike }
    let(:params) { { message: "Something I'm sending you" } }
    let(:url) { "/api/v2/bikes/#{bike.id}/send_stolen_notification?access_token=#{token.token}" }
    let!(:token) { create_doorkeeper_token(scopes: "read_user") }
    before { bike.update_attribute :stolen, true }

    it "fails to send a stolen notification without read_user" do
      token.update_attribute :scopes, "public"
      post url, params.to_json, json_headers
      expect(response.code).to eq("403")
      expect(response.body).to match("OAuth")
      expect(response.body).to match(/permission/i)
      expect(response.body).to_not match("is not stolen")
    end

    it "fails if the bike isn't stolen" do
      bike.update_attribute :stolen, false
      post url, params.to_json, json_headers
      expect(response.code).to eq("400")
      expect(response.body.match("is not stolen")).to be_present
    end

    it "fails if the bike isn't owned by the access token user" do
      bike.current_ownership.update_attributes(user_id: FactoryBot.create(:user).id, claimed: true)
      post url, params.to_json, json_headers
      expect(response.code).to eq("403")
      expect(response.body.match("application is not approved")).to be_present
    end

    it "sends a notification" do
      expect do
        post url, params.to_json, json_headers
      end.to change(EmailStolenNotificationWorker.jobs, :size).by(1)
      expect(response.code).to eq("201")
    end
  end
end
