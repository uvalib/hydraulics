# ImageTechMeta represents image technical metadata. An ImageTechMeta record is
# an extension of a single MasterFile record and is applicable only for a
# MasterFile of type "image".
class ImageTechMeta < ActiveRecord::Base

  # include HasFormat

  # COLOR_SPACES = %w[RGB GRAY CMYK]  # These are the values used in iView XML files (which are imported to create MasterFile and ImageTechMeta records)

  #------------------------------------------------------------------
  # relationships
  #------------------------------------------------------------------
  belongs_to :master_file

  #------------------------------------------------------------------
  # validation
  #------------------------------------------------------------------
  validates :master_file_id, :presence => true
  validates :master_file_id, :uniqueness => true
  validates :resolution, :width, :height, :depth, :numericality => {:greater_than => 0, :allow_nil => true}
  validates :master_file, 
          :presence => {
            :message => "association with this MasterFile is no longer valid because the MasterFile object no longer exists."
          }


  # validates_inclusion_of :image_format,
  #                        :in => IMAGE_FORMATS,
  #                        :message => "must be one of these values: " + IMAGE_FORMATS.join(", ")

  # validates_inclusion_of :resolution_unit,
  #                        :in => RESOLUTION_UNITS,
  #                        :message => "must be one of these values: " + RESOLUTION_UNITS.join(", "),
  #                        :allow_nil => true

  # validates_inclusion_of :color_space,
  #                        :in => COLOR_SPACES,
  #                        :message => "must be one of these values: " + COLOR_SPACES.join(", "),
  #                        :allow_nil => true

  #------------------------------------------------------------------
  # public class methods
  #------------------------------------------------------------------
  # These methods return a string containing a brief description for a specific
  # column, for which the usage or format is not inherently obvious.
  def ImageTechMeta.width_description
    return 'Image width/height in pixels.'
  end

  def ImageTechMeta.depth_description
    return 'Color depth in bits. Normally 1 for bitonal, 8 for grayscale, 24 for color.'
  end

  def ImageTechMeta.compression_description
    return 'Name of compression scheme, or "Uncompressed" for no compression.'
  end


  #------------------------------------------------------------------
  # public instance methods
  #------------------------------------------------------------------
  # Returns this record's +image_format+ value.
  def format
    return image_format
  end

end
