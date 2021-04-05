class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.search(search, search_key)
    if search == perfect_match
      @book = Book.where(title: "#{search_key}").or(Book.where(body: "#{search_key}"))
    elsif search == forward_matsh
      @book = Book.where("title like?", "%#{search_key}").or(Book.where("body like?", "%#{search_key}"))
    elsif search == backward_match
      @book = Book.where("title like?", "#{search_key}%").or(Book.where("body like?", "#{search_key}%"))
    elsif search == partial_match
      @book = Book.where("title like?", "%#{search_key}%").or(Book.where("body like?", "%#{search_key}%"))
    else
      @book = Book.all
    end
  end
end
