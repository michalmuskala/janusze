# == Schema Information
#
# Table name: comments
#
#  id                      :integer          not null, primary key
#  commentable_id          :integer
#  commentable_type        :string(255)
#  title                   :string(255)
#  body                    :text
#  subject                 :string(255)
#  user_id                 :integer          not null
#  parent_id               :integer
#  lft                     :integer
#  rgt                     :integer
#  created_at              :datetime
#  updated_at              :datetime
#  cached_votes_total      :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_votes_down       :integer          default(0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#
# Indexes
#
#  index_comments_on_cached_votes_down                    (cached_votes_down)
#  index_comments_on_cached_votes_score                   (cached_votes_score)
#  index_comments_on_cached_votes_total                   (cached_votes_total)
#  index_comments_on_cached_votes_up                      (cached_votes_up)
#  index_comments_on_cached_weighted_average              (cached_weighted_average)
#  index_comments_on_cached_weighted_score                (cached_weighted_score)
#  index_comments_on_cached_weighted_total                (cached_weighted_total)
#  index_comments_on_commentable_id_and_commentable_type  (commentable_id,commentable_type)
#  index_comments_on_user_id                              (user_id)
#

class Comment < ActiveRecord::Base
  acts_as_nested_set :scope => [:commentable_id, :commentable_type]

  validates :body, :presence => true
  validates :user, :presence => true
  validates :commentable, presence: true

  acts_as_votable

  belongs_to :commentable, :polymorphic => true

  belongs_to :user

  def self.build_from(obj, user, comment)
    new  :commentable => obj,
         :body        => comment,
         :user        => user
  end

  def self.ordered
    order(cached_votes_score: :desc)
  end

  def has_children?
    children.any?
  end
end
