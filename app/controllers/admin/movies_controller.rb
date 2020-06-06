class Admin::MoviesController < ApplicationController
  before_action :set_movies, only: [:show, :edit, :update, :destroy]

  def new
    @movie = Movie.new
    superviser = @movie.supervisers.build
    actor = @movie.actors.build
    writer = @movie.writers.build
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.save
    redirect_to admin_movie_path(@movie)
  end

  def index
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def movie_params
    # movieとアソシエーション関係にあるactor,superviser,writerも保存できるようにする。
    params.require(:movie).permit(:movie_image, :title, :summary, :a_movie_released, :show_time,
                                  supervisers_attributes: [:id, :superviser_name, :_destroy],
                                  actors_attributes: [:actor_name],
                                  writers_attributes: [:writer_name])
    end

  def set_movies
    @movie = Movie.find(params[:id])
  end
end
