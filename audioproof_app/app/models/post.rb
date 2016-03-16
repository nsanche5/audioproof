class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  has_many :taggings
  has_many :tags, through: :taggings
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 63206 }
   
  def all_tags=(names)
     self.tags = names.split(",").map do |name|
        Tag.where(name: name.strip).first_or_create!
     end
  end
   
  def all_tags
     self.tags.map(&:name).join(",")
  end
     
  def self.tagged_with(name)
     Tag.find_by_name!(name).posts
  end
   
  private

    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
