CommentNotifierJob = Struct.new(:comment_id) do
  def perform
    comment = Comment.find(comment_id)
    (comment.ticket.watchers - [comment.user]).each do |user|
      NotifierMailer.comment_updated(comment, user).deliver
    end
  end
end