class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]
  before_action :authenticate, except: [:index, :show]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all.paginate(:per_page => 6, :page => params[:page])
    @categories = Category.all 
    @users = User.all

    if params[:search]
      @articles = Article.search(params[:search]).order("created_at DESC").paginate(:per_page => 6, :page => params[:page])
    else
      @articles = Article.order("created_at DESC").paginate(:per_page => 6, :page => params[:page])
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @users = User.all
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
      @article = current_user.articles.find(params[:id])
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = current_user.articles.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Thread was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    @article = current_user.articles.find(params[:id])
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Thread was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = current_user.articles.find(params[:id])
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Thread was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :location, :excerpt, :body, :published_at, :category_ids => [])
    end
end