class Location < ActiveRecord::Base
  include Geocodeable

  acts_as_paranoid
  belongs_to :organization, inverse_of: :locations # Locations are organization locations
  belongs_to :country
  belongs_to :state
  has_many :bikes

  validates :name, :city, :country, :organization, presence: true

  scope :by_state, -> { order(:state_id) }
  scope :shown, -> { where(shown: true) }
  # scope :international, where("country_id IS NOT #{Country.united_states.id}")

  before_save :shown_from_organization
  before_save :set_phone
  after_commit :update_organization

  def shown_from_organization
    self.shown = organization && organization.allowed_show
    true
  end

  def address
    return nil unless self.country
    [
      street,
      city,
      state.present? ? state.abbreviation : nil,
      zipcode,
      country.name,
    ].compact.reject(&:blank?).join(", ")
  end

  def set_phone
    self.phone = Phonifyer.phonify(self.phone) if self.phone
  end

  def org_location_id
    "#{self.organization_id}_#{self.id}"
  end

  def update_organization
    # Because we need to update the organization and make sure it is shown on
    # the map correctly, manually update to ensure that it runs save callbacks
    organization&.reload&.update_attributes(updated_at: Time.current)
  end

  def display_name
    return "" if organization.blank?
    return name if name == organization.name

    "#{organization.name} - #{name}"
  end

  private

  def geocode_columns
    %i[street city state_id zipcode country_id]
  end
end
