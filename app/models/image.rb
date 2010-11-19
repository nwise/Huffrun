class Image < ActiveRecord::Base
  
  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :max_size => 1000.kilobytes,
                 :resize_to => '500x500>',
                 :thumbnails => { :thumb => '100x100>' },
                 :path_prefix => 'public/system/images'

  validates_as_attachment

end
