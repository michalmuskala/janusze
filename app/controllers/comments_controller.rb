class CommentsController < ApplicationController

  COMMENTABLE_CLASS_MAP = {
    project_id: Project
  }

  COMMENTABLE_KEYS = COMMENTABLE_CLASS_MAP.keys

  before_action :authenticate_user!
  before_action :load_comment, only: [:upvote, :downvote]

  respond_to :html

  def create
    @comment = Comment.build_from(commentable,
                                  current_user,
                                  params.fetch(:comment, {})[:body])
    @comment.save
    @comment.move_to_child_of(parent_comment) if parent_comment
    respond_with(@comment, location: polymorphic_path(commentable))
  end

  def upvote
    @comment.liked_by(current_user)
    respond_with(@comment, location: polymorphic_path(@comment.commentable))
  end

  def downvote
    @comment.downvote_from(current_user)
    respond_with(@comment, location: polymorphic_path(@comment.commentable))
  end

  private

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def parent_comment
    Comment.find_by_id(params.fetch(:comment, {})[:parent_id])
  end

  def commentable
    @commentable ||= commentable_class.find(params[commentable_key])
  end

  def commentable_class
    @commentable_class ||= COMMENTABLE_CLASS_MAP[commentable_key]
  end

  def commentable_key
    @commentable_key ||= COMMENTABLE_KEYS.find { |key| params.has_key?(key) }
  end
end
