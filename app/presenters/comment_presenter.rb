class CommentPresenter < BasePresenter
  presents :comment

  def body
    self.class.markdown_render(comment.body)
  end

  def user_name
    comment.user.name
  end

  def child_comments
    comment.children.ordered.map { |comment| h.render comment }.join.html_safe
  end

  def score
    comment.cached_votes_score
  end

  def upvote_link
    h.link_to h.fa_icon('chevron-up'), h.upvote_comment_path(comment),
              method: :put
  end

  def downvote_link
    h.link_to h.fa_icon('chevron-down'), h.downvote_comment_path(comment),
              method: :put
  end
end
