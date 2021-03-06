class User::UsersController < ApplicationController
  before_action :set_users, only: [:show, :edit, :following, :followers]
  def index
    @users = User.all.includes(movie_ranks: :review)
  end

  def show
    @movie_rank = MovieRank.new
    @reviews = @user.reviews.includes(:movie, :movie_rank)
    @followers = @user.followers.includes(:movie_ranks)
    @following = @user.following.includes(:movie_ranks)

    # 有効ユーザーの時
    if @user.is_withdrawal == false
      @user_ranks = @user.movie_ranks
      @movie_ranks = @user_ranks.order(:rank_status)

      @omit_first = MovieRank.rank_statuses.except(:"1位").keys
      @omit_second = MovieRank.rank_statuses.except(:"2位").keys
      @omit_third = MovieRank.rank_statuses.except(:"3位").keys
      @only_first = MovieRank.rank_statuses.slice(:"1位").keys
      @only_second = MovieRank.rank_statuses.slice(:"2位").keys
      @only_third = MovieRank.rank_statuses.slice(:"3位").keys

      if @user_ranks.find_by(rank_status: "1")
        @rank = @omit_first
        if @user_ranks.find_by(rank_status: "1位") && @user_ranks.find_by(rank_status: "2")
          @rank = @only_third
        elsif @user_ranks.find_by(rank_status: "1位") && @user_ranks.find_by(rank_status: "3")
          @rank = @only_second
        end
      elsif @user_ranks.find_by(rank_status: "2")
        @rank = @omit_second
        if @user_ranks.find_by(rank_status: "1位") && @user_ranks.find_by(rank_status: "2")
          @rank = @only_third
        elsif @user_ranks.find_by(rank_status: "2位") && @user_ranks.find_by(rank_status: "3")
          @rank = @only_first
        end
      elsif @user_ranks.find_by(rank_status: "3")
        @rank = @omit_third
        if @user_ranks.find_by(rank_status: "2位") && @user_ranks.find_by(rank_status: "3")
          @rank = @only_first
        elsif @user_ranks.find_by(rank_status: "1位") && @user_ranks.find_by(rank_status: "3")
          @rank = @only_second
        end
      else
        @rank = MovieRank.rank_statuses.keys
      end
    # 退会しているユーザーの時
    elsif @user.is_withdrawal == true
      redirect_back(fallback_location: root_path)
    end
  end

  def edit
  end

  def update
    @user = current_user
    @user.update(user_params)
    redirect_to user_user_path(@user)
  end

  def following
    # @userがフォローしているユーザー
    @user.following
  end

  def followers
    # @userをフォローしているユーザー
    @user.followers
  end

  def out
    @user = current_user
    @user.update(is_withdrawal: true)
    @user.reviews.destroy_all
    @user.comments.destroy_all
    @user.favorites.destroy_all
    @user.followers.destroy_all
    @user.following.destroy_all
    reset_session
    flash[:alert] = "ありがとうございました。またのご利用を心よりお待ちしております。"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :email, :is_withdrawal)
  end

  def set_users
    @user = User.find(params[:id])
  end
end
