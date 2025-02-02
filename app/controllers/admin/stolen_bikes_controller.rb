class Admin::StolenBikesController < Admin::BaseController
  before_filter :find_bike, only: [:edit, :destroy, :approve, :update, :regenerate_alert_image]

  def index
    if params[:unapproved]
      bikes = Bike.stolen.order("created_at desc")
    else
      bikes = Bike.stolen.where("approved_stolen IS NOT TRUE")
      @verified_only = true
    end
    page = params[:page] || 1
    per_page = params[:per_page] || 50
    @bikes = bikes.page(page).per(per_page)
  end

  def approve
    @bike.current_stolen_record.update_attribute :approved, true
    @bike.update_attribute :approved_stolen, true
    ApproveStolenListingWorker.perform_async(@bike.id)
    redirect_to edit_admin_stolen_bike_url(@bike), notice: "Bike was approved."
  end

  def regenerate_alert_image
    selected_image = PublicImage.find(params[:public_image_id])

    if @bike.current_stolen_record.generate_alert_image(bike_image: selected_image)
      flash[:notice] = "Promoted alert bike image updated."
    else
      flash[:error] = "Could not update promoted alert image."
    end

    redirect_to edit_admin_stolen_bike_url(@bike)
  end

  def show
    redirect_to edit_admin_stolen_bike_url
  end

  def edit
    @customer_contact = CustomerContact.new(user_email: @bike.owner_email)
    @bike = @bike.decorate
  end

  def update
    BikeUpdator.new(user: current_user, bike: @bike, b_params: { bike: permitted_parameters }).update_ownership
    @bike = @bike.decorate
    if @bike.update_attributes(permitted_parameters)
      SerialNormalizer.new({ serial: @bike.serial_number }).save_segments(@bike.id)
      redirect_to edit_admin_stolen_bike_url(@bike), notice: "Bike was successfully updated."
    else
      render action: "edit"
    end
  end

  protected

  def permitted_parameters
    params.require(:bike).permit(Bike.old_attr_accessible)
  end

  def find_bike
    if ParamsNormalizer.boolean(params[:stolen_record_id])
      @stolen_record = StolenRecord.unscoped.find(params[:id])
      @bike = Bike.unscoped.find_by_id(@stolen_record.bike_id)
    else
      @bike = Bike.unscoped.find_by_id(params[:id])
      @stolen_record = @bike.current_stolen_record
    end
    @current_stolen_record = @stolen_record.present? && @stolen_record.id == @bike.current_stolen_record&.id
    @bike
  end
end
