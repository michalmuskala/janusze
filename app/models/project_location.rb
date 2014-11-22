# == Schema Information
#
# Table name: project_locations
#
#  id            :integer          not null, primary key
#  state         :string(255)
#  city          :string(255)
#  street        :string(255)
#  street_number :string(255)
#  longitude     :float
#  latitude      :float
#  project_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_project_locations_on_project_id  (project_id)
#

class ProjectLocation < ActiveRecord::Base
  STATES = Carmen::Country.coded('PL').subregions
  STATE_NAME_TO_CODE = Hash[STATES.map { |state| [state.name, state.code.downcase] }]
  STATE_NAME_TO_CODE_DOWNCASED = Hash[STATES.map { |state| [state.name.mb_chars.downcase.normalize.to_s, state.code.downcase] }]
  CODE_TO_STATE = Hash[STATES.map { |state| [state.code.downcase, state] }]

  belongs_to :project

  geocoded_by :address
  after_validation :geocode

  def address
    [state, city, "#{street} #{street_number}"].reject(&:blank?).join(', ')
  end

  def coords
    {lat: latitude, lng: longitude}
  end

  def self.state_name_to_code(state_name)
    STATE_NAME_TO_CODE_DOWNCASED[state_name.mb_chars.downcase.normalize.to_s]
  end

  def self.code_to_state(state_code)
    CODE_TO_STATE[state_code.downcase]
  end

  def self.code_to_state_name_downcased(state_code)
    CODE_TO_STATE[state_code.downcase].name.mb_chars.downcase.normalize.to_s
  end
end
