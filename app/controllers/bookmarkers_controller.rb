class BookmarkersController < ApplicationController
  before_action :authenticate_user!, :set_bookmarker, only: [:show, :edit, :update, :destroy]

  def index
    @bookmarkers = Bookmarker.all
  end

  def new
    if current_user
      @bookmarker = Bookmarker.new
    else
      redirect_to root_path
    end
  end

  def create
    @bookmarker = Bookmarker.new(bookmarker_params)
    @bookmarker.user = current_user if current_user

    respond_to do |format|
      if @bookmarker.save
        format.html { redirect_to @bookmarker, notice: 'Bookmark was successfully created.'}
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @bookmarker.update(bookmarker_params)
        format.html { redirect_to @bookmarker, notice: 'Bookmarker was successfully updated.'}
      else
        format.html { render :edit }
      end
    end
  end

  def show
  end

  def edit
    redirect_to root_path unless @bookmarker.user.eql?(current_user)
  end

  def destroy
    if @bookmarker.user.eql?(current_user)
      @bookmarker.destroy
      respond_to do |format|
        format.html { redirect_to bookmarkers_url, notice: 'Bookmark was successfully destroyed.'}
      end
    else
      redirect_to root_path
    end
  end

  private

  def set_bookmarker
    unless @bookmarker = Bookmarker.find(params[:id])
      flash[:alert] = 'Bookmark not found.'
      redirect_to root_path
    end
  end

  def bookmarker_params
    params.require(:bookmarker).permit(:title, :url)
  end

end
