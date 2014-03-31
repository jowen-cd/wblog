class Admin::PostsController < ApplicationController
  layout 'layouts/admin'
  before_action :authericate_user!

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find( params[:id] )
  end

  def destroy
    @post = Post.find( params[:id] )
    if @post.destroy
      render :json=> { success: true }
    else
      render :json=> { success: false }
    end
  end

  def index
  end

  def create
    labels = params.delete(:labels).to_s
    @post = Post.new( params.permit(:title, :content, :type) )

    labels.split(",").each do |name|
      label = Label.find_or_initialize_by(name: name.strip)
      label.save!
      @post.labels << label
    end

    #binding.pry

    if @post.save
      flash[:notice] = '创建博客成功'
      redirect_to admin_root_path
    else
      flash[:error] = '创建失败'
      render :new
    end
  end

  def update
    @post = Post.find( params[:id] )

    labels = params.delete(:labels).to_s
    #clear labels
    @post.labels = []

    labels.split(",").each do |name|
      label = Label.find_or_initialize_by(name: name.strip)
      label.save!
      @post.labels << label
    end

    if @post.update( params.permit(:title, :content, :type) )
      render :json=> { success: true }
    else
      render :json=> { success: false }
    end
  end

  def preview
    render :text => Post.render_html(params[:content] || "")
  end
end
