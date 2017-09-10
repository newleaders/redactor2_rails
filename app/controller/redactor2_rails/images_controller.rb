class Redactor2Rails::ImagesController < ApplicationController
  before_action :redactor2_authenticate_user!

  def create
    @image = Redactor2Rails.image_model.new

    file = params[:file]
    @image.data = Redactor2Rails::Http.normalize_param(file, request)
    if @image.has_attribute?(:"#{Redactor2Rails.devise_user_key}")
      @image.send("#{Redactor2Rails.devise_user}=", redactor2_current_user)
      @image.assetable = redactor2_current_user
    end

    if @image.save
      ext = @image.data_file_name.split(".").last
      render json: { id: @image.id, url: image_path(@image, format: ext) }
    else
      render json: { error: @image.errors }
    end
  end

  def show
    @image = Redactor2Rails.image_model.find(params[:id])
    redirect_to @image.url(:content)
  end

  private

  def redactor2_authenticate_user!
    if Redactor2Rails.image_model.new.has_attribute?(Redactor2Rails.devise_user)
      super
    end
  end
end
