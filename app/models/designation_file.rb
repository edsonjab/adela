class DesignationFile < ActiveRecord::Base
  belongs_to :organization
  validates :organization, presence: true

  mount_uploader :file, DesignationFileUploader
  validates_presence_of :file
  validates_format_of :file,  :with => %r{\.(txt|doc|docx|xlsx|xsls|pdf)}i
end
