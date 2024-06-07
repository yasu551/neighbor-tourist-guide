class DiariesController < ApplicationController
  def index
    @diaries = current_user.diaries.default_order
  end

  def show
    @diary = current_user.diaries.find(params[:id])
  end

  def new
    @diary = current_user.diaries.build
  end

  def create
    @diary = current_user.diaries.build(diary_params)
    if @diary.save
      redirect_to diaries_path, notice: '日記を作成しました'
    else
      flash.now[:alert] = '日記の作成に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def diary_params
    params.require(:diary).permit(:title, :content, :recorded_on)
  end
end
