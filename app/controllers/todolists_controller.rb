class TodolistsController < ApplicationController
  def new
    @list = List.new
  end

  def create
    list = List.new(list_params)
    # Natural Language API 使用
    list.score = Language.get_data(list_params[:body])  #この行を追加
    list.save
    # Vision API 使用
    tags = Vision.get_image_data(list.image)    
    tags.each do |tag|
      list.tags.create(name: tag)
    end　#この行までを追加
    
    redirect_to todolist_path(list.id)
  end

  def index
    @lists = List.all
  end

  def show
    @list = List.find(params[:id])
  end

  def edit
    @list = List.find(params[:id])
  end

  def update
    list = List.find(params[:id])
    list.update(list_params)
    redirect_to todolist_path(list.id)
  end

  def destroy
    list = List.find(params[:id])
    list.destroy
    redirect_to todolists_path
  end

  private

  def list_params
    params.require(:list).permit(:title, :body, :image)
  end

end
