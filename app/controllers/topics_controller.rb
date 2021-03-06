class TopicsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:edit, :update]}
  impressionist :actions => [:show, :index]

  def index
    @topics = Topic.all.order(created_at: "desc").page(params[:page]).per(5)
  end

  def most_view
    @most_viewed_topics = Topic.order('impressions_count DESC').take(3)
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
    @comment = Comment.new
    impressionist(@topic_user, nil, unique: [:session_hash])
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

  def destroy
    @topic = Topic.find_by(id: params[:id])
    @topic.destroy
    flash[:notice] = "トピックを削除しました"
    if @current_user.admin?
      redirect_to(admin_path)
    else
      redirect_to("/")
    end
  end

  def search_result
    @topics = Topic.search(params[:title])
    @title = params[:title]
  end
end
