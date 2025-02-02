# frozen_string_literal: true

class PaidFeature < ActiveRecord::Base
  include Amountable
  KIND_ENUM = { standard: 0, standard_one_time: 1, custom: 2, custom_one_time: 3 }.freeze
  # Organizations have paid_feature_slugs as an array attribute to track which features should be enabled
  # Every feature slug that is used in the code should be in this array
  # Only slugs that are used in the code should be in this array
  REG_FIELDS = %w[reg_affiliation reg_secondary_serial reg_phone reg_address].freeze
  EXPECTED_SLUGS = (%w[csv_exports messages geolocated_messages abandoned_bike_messages avery_export bike_search
                       show_bulk_import show_recoveries show_partial_registrations show_multi_serial skip_ownership_email
                       unstolen_notifications bike_codes impound_bikes passwordless_users
                       regional_bike_counts regional_stickers] + REG_FIELDS).freeze

  has_many :invoice_paid_features
  has_many :invoices, through: :invoice_paid_features

  validates_uniqueness_of :name
  validates :currency, presence: true

  enum kind: KIND_ENUM

  after_commit :update_invoices

  scope :recurring, -> { where(kind: %w[standard custom]) }
  scope :upfront, -> { where(kind: %w[standard_upfront custom_upfront]) }

  def self.kinds; KIND_ENUM.keys.map(&:to_s) end

  # used by organization right now, but might be useful in other places
  def self.matching_slugs(slugs)
    slug_array = slugs.is_a?(Array) ? slugs : slugs.split(" ").reject(&:blank?)
    matching_slugs = EXPECTED_SLUGS & slug_array
    matching_slugs.any? ? matching_slugs : nil
  end

  def one_time?; standard_one_time? || custom_one_time? end

  def recurring?; !one_time? end

  def locked?
    feature_slugs.any? && invoices.active.any?
  end

  def feature_slugs_string
    feature_slugs.join(", ")
  end

  # We only want to store features that are used in the code. Some features overlap - e.g. there are packages that apply multiple features
  # So check for matches with the EXPECTED_SLUGS which tracks which features we're using
  def feature_slugs_string=(val)
    self.feature_slugs = val.split(",").reject(&:blank?).map do |str|
      fslug = str.downcase.strip
      EXPECTED_SLUGS.include?(fslug) ? fslug : nil
    end.compact
  end

  # Trigger an update to invoices which will, in turn, update the associated organizations
  def update_invoices
    invoices.each { |i| i.update_attributes(updated_at: Time.current) }
  end
end
