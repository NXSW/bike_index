class BikeCreatorAssociator
  def initialize(b_param = nil)
    @b_param = b_param
  end

  def create_ownership(bike)
    passed_send_email = @b_param.params.dig("bike", "send_email")
    if passed_send_email == false || passed_send_email.present? && passed_send_email.to_s[/false/i]
      send_email = false
    else
      send_email = true
    end
    OwnershipCreator.new(bike: bike, creator: @b_param.creator, send_email: send_email).create_ownership
  end

  def create_components(bike)
    ComponentCreator.new(bike: bike, b_param: @b_param).create_components_from_params
  end

  def create_stolen_record(bike)
    StolenRecordUpdator.new(bike: bike, user: @b_param.creator, b_param: @b_param.params).create_new_record
    bike.save
  end

  def assign_user_attributes(bike, user = nil)
    user ||= bike.user
    return true unless user.present?
    if bike.phone.present?
      user.phone = bike.phone if user.phone.blank?
    end
    user.save if user.changed? # Because we're also going to set the address and the name here
    bike
  end

  def create_normalized_serial_segments(bike)
    bike.create_normalized_serial_segments
  end

  def attach_photo(bike)
    return true unless @b_param.image.present?
    public_image = PublicImage.new(image: @b_param.image)
    public_image.imageable = bike
    public_image.save
    @b_param.update_attributes(image_processed: true)
    bike.reload
  end

  def attach_photos(bike)
    return nil unless @b_param.params["photos"].present?
    photos = @b_param.params["photos"].uniq.take(7)
    photos.each { |p| PublicImage.create(imageable: bike, remote_image_url: p) }
  end

  def add_other_listings(bike)
    return nil unless @b_param.params["bike"]["other_listing_urls"].present?
    urls = @b_param.params["bike"]["other_listing_urls"]
    urls.each { |url| OtherListing.create(url: url, bike_id: bike.id) }
  end

  def associate(bike)
    begin
      ownership = create_ownership(bike)
      create_components(bike)
      create_normalized_serial_segments(bike)
      assign_user_attributes(bike, ownership&.user)
      create_stolen_record(bike) if bike.stolen
      attach_photo(bike)
      attach_photos(bike)
      add_other_listings(bike)
      bike.reload.save
    rescue => e
      bike.errors.add(:association_error, e.message)
    end
    bike
  end
end
