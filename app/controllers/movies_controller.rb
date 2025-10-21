class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[ create new edit update destroy ] # Apenas usuários logados podem criar, editar ou deletar filmes
  before_action :authorize_user!, only: %i[ edit update destroy ] # Apenas o usuário que criou o filme pode editá-lo ou deletá-lo

  # GET /movies or /movies.json usando paginação
  def index
    @movies = Movie.order(created_at: :desc).page(params[:page]).per(6)
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
    @movie = current_user.movies.new(movie_params)
    if @movie.save
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.expect(movie: [ :title, :synopsis, :release_year, :duration, :director, :user_id ])
    end

    def authorize_user!
      unless @movie.user == current_user
        redirect_to movies_path, alert: "Você não está autorizado a realizar esta ação."
      end
    end
end
