class General::FollowsController < GeneralController

  def index
    @q = current_user.following_boards.ransack(params[:q])
    @boards = @q.result(distinct: true).includes(:user).recent.page(params[:page])
  end

  def create
    @board = Board.find(params[:board_id])
    current_user.follow(@board)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @board = Follow.find(params[:id]).board
    current_user.unfollow(@board)
    respond_to do |format|
      format.js
    end
  end
end
