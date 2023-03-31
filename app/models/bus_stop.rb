class BusStop < ApplicationRecord
  def self.by_code
    order(:code).uniq.map(&:to_h)
  end

  def label
    "#{code} - #{name} - #{direction}"
  end

  def to_h
    {
      label: label,
      value: code
    }
  end
end
