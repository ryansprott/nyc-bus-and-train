class SubwayStop < ApplicationRecord
  serialize :routes, Array

  def self.by_code
    order(:gtfs_id).uniq.map(&:to_h)
  end

  def label
    "#{line_name} - #{stop_name}"
  end

  def to_h
    {
      label: label,
      value: gtfs_id
    }
  end
end
