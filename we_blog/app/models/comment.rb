class Comment < WebitModel
  attr_access :comment , :string
  belongs_to :posts

end