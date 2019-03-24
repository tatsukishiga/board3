class TopicsController < ApplicationController
  before_action :authenticate_user

  def index
    @topics = Topic.page(params[:page])
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(
      title: params[:topic][:title],
      content: params[:topic][:content],
      user_id: @current_user.id
    )
    if @topic.save
      flash[:notice] = "トピックを作成しました"
      redirect_to(topics_path)
    else
      render("new")
    end
  end

  def show
    @topic_user = Topic.find_by(id: params[:id])
    @comments = Comment.all
  end

  def edit
    @topic = Topic.find_by(id: params[:id])
  end

  def update
    @topic = Topic.find_by(id: params[:id])
    if @topic.update(title: params[:topic][:title], content: params[:topic][:content])
      flash[:notice] = "トピックの情報を編集しました"
      redirect_to(topic_path(@topic.id))
    else
      render("edit")
    end
  end

  def search_result
    @topics = Topic.where(title: params[:title])
  end
end
