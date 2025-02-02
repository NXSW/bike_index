require "rails_helper"

RSpec.describe Admin::RecoveryDisplaysController, type: :controller do
  before do
    user = FactoryBot.create(:admin)
    set_current_user(user)
  end

  describe "index" do
    it "renders" do
      get :index
      expect(response).to be_success
      expect(response).to render_template(:index)
      expect(flash).to_not be_present
    end
  end

  describe "show" do
    context "bust_cache" do
      it "busts the cache" do
        get :show, id: "bust_cache"
        expect(response).to redirect_to admin_recovery_displays_path
        expect(flash[:success]).to match(/cache/i)
      end
    end
  end

  describe "edit" do
    let(:recovery_display) { FactoryBot.create(:recovery_display) }
    it "renders" do
      get :edit, id: recovery_display.id
      expect(response).to be_success
      expect(response).to render_template(:edit)
      expect(flash).to_not be_present
    end
    it "doesn't break if the recovery_display's bike is deleted" do
      recovery_display.reload
      get :edit, id: recovery_display.id
      expect(response).to be_success
      expect(response).to render_template(:edit)
      expect(flash).to_not be_present
    end
  end

  describe "create" do
    context "valid create" do
      let(:valid_attrs) { { quote: "something that is nice and short and stuff" } }
      it "creates the recovery_display" do
        post :create, recovery_display: valid_attrs

        recovery_display = RecoveryDisplay.last
        expect(recovery_display.quote).to eq valid_attrs[:quote]
      end
    end
    context "valid create" do
      let(:invalid_attrs) do
        {
          quote: "La croix scenester pug glossier, yuccie salvia humblebrag chia. Meditation health goth readymade flannel hot chicken austin tofu salvia cornhole tumeric hashtag plaid. Umami vegan hell of before they sold out copper mug chillwave authentic poke mumblecore godard la croix 8-bit. Venmo raw denim synth wolf. Food truck hot chicken waistcoat activated charcoal",
        }
      end
      it "does not create a recovery display that is too long" do
        expect do
          post :create, recovery_display: invalid_attrs
        end.to change(RecoveryDisplay, :count).by 0
        expect(assigns(:recovery_display).errors).to be_present
      end
    end
  end
end
