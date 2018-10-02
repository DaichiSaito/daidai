class General::CommentsController < GeneralController
  def create
    @board = Board.find(params[:board_id])
    @comment = Comment.new(comment_params)
    @comment.notifications << Notification.new
    current_user.post_comment(@board, @comment)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
    respond_to do |format|
      format.js
    end
  end

  def update
    @comment = current_user.comments.find(params[:id])
    respond_to do |format|
      if @comment.update(comment_params)
        format.json { render json: { comment: @comment }, status: :ok }
      else
        format.json { render json: { comment: @comment, errors: { messages: @comment.errors.full_messages } }, status: :bad_request }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
