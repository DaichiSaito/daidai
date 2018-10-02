class General::BoardsController < GeneralController
  before_action :correct_user, only: %i[edit update destroy]
  def index
    @q = Board.ransack(params[:q])
    @boards = @q.result(distinct: true).includes(:user).recent.page(params[:page])
  end

  def new
    @board = current_user.boards.build
  end

  def show
    @board = Board.find(params[:id])
    @comments = @board.comments.recent.page params[:page]
    # @comment = @board.comments.build # こうするとおそらく@boardに空のcommentが紐づいてテンプレート内で無駄にリストが生成されて不具合が起こる
    @comment = Comment.new
  end

  def create
    @board = current_user.boards.build(board_params)
    @board.notifications << Notification.new
    if @board.save
      redirect_to boards_path, success: t('.success')
    else
      flash.now['danger'] = t('.failed')
      render :new
    end
  end

  def edit; end

  def update
    if @board.update(board_params)
      redirect_to boards_url, success: t('.success')
    else
      flash.now['danger'] = t('.failed')
      render :edit
    end
  end

  def destroy
    @board.destroy!
    redirect_to boards_url, success: t('.success', title: @board.title)
  end

  private

  def board_params
    params.require(:board).permit(:title, :description, :image)
  end

  def correct_user
    @board = current_user.boards.find_by(id: params[:id])
    redirect_to boards_url, danger: t('shared.unauthorized_access') if @board.nil?
  end
end
