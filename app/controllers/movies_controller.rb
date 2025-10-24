class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[ create new edit update destroy ] # Apenas usuários logados podem criar, editar ou deletar filmes
  before_action :authorize_user!, only: %i[ edit update destroy ] # Apenas o usuário que criou o filme pode editá-lo ou deletá-lo

  # GET /movies or /movies.json usando paginação
  def index
    @movies = Movie.newest_first

    # Filtros
    @movies = @movies.joins(:categories).where(categories: { id: params[:category_id] }) if params[:category_id].present?
    @movies = @movies.where(release_year: params[:year]) if params[:year].present?
    @movies = @movies.where("LOWER(director) LIKE ?", "%#{params[:director].downcase}%") if params[:director].present?

    # Busca 
    @movies = @movies.search(params[:query]) if params[:query].present?
    @movies = @movies.page(params[:page]).per(6)

    @categories = Category.all
  end

  # GET /movies/1 or /movies/1.json
  def show
    @movie = Movie.find(params[:id])
    @comments = @movie.comments.order(created_at: :desc)
    @comment = Comment.new
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = current_user.movies.new(movie_params.except(:tags))
    if @movie.save
      attach_tags(@movie, params[:tag_names])
      redirect_to @movie, notice: "Filme criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    if @movie.update(movie_params)
      redirect_to @movie, notice: "Filme atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy
    redirect_to movies_url, notice: "Filme deletado com sucesso!"
  end

  def fetch_ai_data
    title = params[:title]
    
    unless title.present?
      return render json: { error: "Título não fornecido" }, status: :unprocessable_entity
    end

    begin
      service = AiMovieService.new
      movie_data = service.fetch_movie_information(title)
      
      Rails.logger.info "AI Movie Data: #{movie_data.inspect}"
      
      render json: movie_data
    rescue => e
      Rails.logger.error "Error in fetch_ai_data: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      
      render json: { error: "Erro interno do servidor: #{e.message}" }, status: :internal_server_error
    end
  end

  private

    def attach_tags(movie, tag_names)
      return unless tag_names
      movie.tags = tag_names.map { |name| Tag.find_or_create_by(name: name.strip)  }
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.expect(movie: [ :title, :synopsis, :release_year, :duration, :director, :image, :user_id, category_ids: [], tag_ids: [] ])
    end

    def authorize_user!
      unless @movie.user == current_user
        redirect_to movies_path, alert: "Você não está autorizado a realizar esta ação."
      end
    end
end
