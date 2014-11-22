class CommentPresenter < BasePresenter
  presents :comment

  def body
    h.simple_format comment.body
  end

  def user_name
    comment.user.name
  end

  def child_comments
    comment.children.map { |comment| h.render comment }.join.html_safe
  end
end
