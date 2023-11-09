class Connection < ApplicationRecord
  belongs_to :user
  has_many :accounts, dependent: :destroy

  validates :provider_code, :connection_id, :status, presence: true
  validates :connection_id, uniqueness: true

  def ready_for_refresh?
    return false if next_refresh_possible_at.blank?

    next_refresh_possible_at < Time.now
  end

  def refreshing?
    active? && next_refresh_possible_at.blank?
  end

  def waiting_for_refresh?
    active? && next_refresh_possible_at.present?
  end

  private

  def active?
    status == "active"
  end
end
