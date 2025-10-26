class CommentsController < ApplicationController
  before_action :set_movie, only: %i[ create destroy ]
  before_action :set_comment, only: %i[ destroy ]
  before_action :authorize_destroy!, only: %i[ destroy ]

  def create
    @comment = @movie.comments.build(comment_params)
    @comment.user = current_user if user_signed_in?  # associa o comentário ao usuário logado

    if @comment.save
      redirect_to movie_path(@movie), notice: "Comentário criado com sucesso!"
    else
      @comments = @movie.comments.order(created_at: :desc)
      render 'movies/show', status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to movie_path(@movie), notice: "Comentário deletado com sucesso!"
  end

  private

  def comment_params
    params.require(:comment).permit(:author_name, :content)
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def set_comment
    @comment = @movie.comments.find(params[:id])
  end

  def authorize_destroy!
    unless @movie.user == current_user || @comment.user == current_user
      redirect_to movies_path, alert: "Você não está autorizado a realizar esta ação."
    end
  end
end
