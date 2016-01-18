# == Schema Information
#
# Table name: campus_gatherings
#
#  campus_id    :integer          not null
#  gathering_id :integer          not null, primary key
#

class CampusGathering < ActiveRecord::Base
  self.primary_key = :gathering_id
  
  belongs_to :campus
  belongs_to :gathering
end
