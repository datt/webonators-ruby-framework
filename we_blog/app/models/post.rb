class Post < WebitModel
  attr_access :title , :string
  attr_access :content , :text
  has_many :comments
end