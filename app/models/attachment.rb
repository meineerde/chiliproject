#-- copyright
# ChiliProject is a project management system.
#
# Copyright (C) 2010-2011 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

class Attachment < ActiveRecord::Base
  belongs_to :container, :polymorphic => true
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"

  validates_presence_of :container, :filename, :author
  validates_length_of :filename, :maximum => 255

  def file=(incoming_file)
    unless incoming_file.nil?
      @temp_file = incoming_file
      if @temp_file.size > 0
        self.filename = sanitize_filename(@temp_file.original_filename)
        self.content_type = @temp_file.content_type.to_s.chomp
        if self.content_type.blank?
          self.content_type = Redmine::MimeType.of(filename)
        end
        self.filesize = @temp_file.size

        # Additional meta data updates by the specific attachment class
        update_metadata
      end
    end
  end


  def attach_files

  protected

  def update_metadata
  end

  def calculate_hashes
    self.md5_digest = Digest::MD5.file(@temp_file)
  end

  def perform_upload
  end
end
