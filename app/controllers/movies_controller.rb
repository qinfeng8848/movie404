class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:new,:edit,:update,:create,:destroy, :join, :quit]
  before_action :find_movie_and_check_permission, only: [:edit, :update, :destroy]


  def index
    @movies = Movie.all
  end

  def new
    @movie = Movie.new
  end

  def show
    @movie = Movie.find(params[:id])
    @reviews = @movie.reviews
  end

  def edit
     # @movie = Movie.find(params[:id])
  end

  def update
    # @movie = Movie.find(params[:id])
    if @movie.update(movie_params)
      redirect_to movies_path, notice: "更新成功"
    else
      render :edit
    end
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user
    if @movie.save
      redirect_to movies_path
    else
      render :new
    end
  end

  def destroy
    # @movie = Movie.find(params[:id])
    @movie.destroy

    flash[:alert] = "电影已经删除"
    redirect_to movies_path

  end

  def join
    @movie = Movie.find(params[:id])

    if !current_user.is_member_of?(@movie)
      current_user.join!(@movie)
      flash[:notice] = "收藏成功！"
    else
      flash[:warning] = "已经收藏！"
    end
    redirect_to movie_path(@movie)
   end

 def quit
   @movie = Movie.find(params[:id])

   if current_user.is_member_of?(@movie)
     current_user.quit!(@movie)
     flash[:alert] = "取消收藏！"
   else
     flash[:warning] = "没有收藏,不能取消收藏"
   end

   redirect_to movie_path(@movie)
 end

  private

  def movie_params
    params.require(:movie).permit(:title,:description)
  end

  def find_movie_and_check_permission
     @movie = Movie.find(params[:id])

     if current_user != @movie.user
       redirect_to root_path, alert: "你没有权限"
     end
  end

end
