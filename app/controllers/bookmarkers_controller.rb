class BookmarkersController < ApplicationController
  before_action :authenticate_user!, :set_bookmarker, only: %i[show edit update destroy update_image]

  def index
    @bookmarkers = Bookmarker.all
    @bookmarkers = current_user.bookmarkers if current_user
    @bookmarkers = if params[:term] && !params[:term].blank?
                     @bookmarkers.search_by_title_and_url(params[:term])
                   else
                     @bookmarkers
                   end

    @bookmarkers = @bookmarkers.order(:created_at ).page(params[:page]).per(params[:limit])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    if current_user
      @bookmarker = Bookmarker.new
    else
      redirect_to root_path
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @bookmarker = Bookmarker.create(bookmarker_params)
    @bookmarker.user = current_user if current_user

    respond_to do |format|
      if @bookmarker.save
        webshot_upload_image
        format.html { redirect_to bookmarkers_url, notice: 'Bookmark was successfully created.' }
      else
        format.html
      end
      format.js
    end
  end

  def update
    respond_to do |format|
      if @bookmarker.update(bookmarker_params)
        format.html { redirect_to bookmarkers_url, notice: 'Bookmark was successfully updated.' }
      else
        format.html
      end
      format.js
    end
  end

  def edit
    redirect_to root_path unless @bookmarker.user.eql?(current_user)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    if @bookmarker.user.eql?(current_user)
      @bookmarker.destroy
      respond_to do |format|
        format.html { redirect_to bookmarkers_url, notice: 'Bookmark was successfully destroyed.' }
      end
    else
      redirect_to root_path
    end
  end

  private

  def upload_image
    html  = @bookmarker.url
    kit   = IMGKit.new(html, height: 900, quality: 50)
    img   = kit.to_img(:png)
    file  = Tempfile.new(["template_#{@bookmarker.id}", 'png'], 'tmp',
                         encoding: 'ascii-8bit')
    file.write(img)
    file.flush
    @bookmarker.snapshot = file
    file.unlink
  end

  def webshot_upload_image
    ws = Webshot::Screenshot.instance
    ws.capture @bookmarker.url, 'tmp/webshot.png', width: 300, height: 300
    tmp_file = File.open('tmp/webshot.png', 'r')
    @bookmarker.snapshot = tmp_file
    tmp_file.close
    @bookmarker.save
  end

  def set_bookmarker
    @bookmarker = Bookmarker.find(params[:id])
    return if @bookmarker.present?
    flash[:alert] = 'Bookmark not found.'
    redirect_to root_path
  end

  def bookmarker_params
    params.require(:bookmarker).permit(:title, :url)
  end
end
