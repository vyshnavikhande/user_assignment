class User < ApplicationRecord
  rolify
  has_one_attached :image
end
