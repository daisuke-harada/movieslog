class Admin::GenresController < ApplicationController
  def index
    @genre = Genre.new
    @genres = Genre.all
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
