# db/seeds.rb

puts "Iniciando seed..."

# Encontrar ou criar usuário (evita duplicação)
puts "Criando/encontrando usuário..."
user = User.find_or_create_by!(
  email: "joao@example.com"
) do |u|
  u.name = "João Silva"
  u.password = "password123"
  u.password_confirmation = "password123"
end

# Limpar apenas filmes e comentários (preserva usuários existentes)
puts "Limpando filmes e comentários..."
Movie.destroy_all
Comment.destroy_all

puts "Criando filme..."
movie = Movie.create!(
  title: "O Poderoso Chefão",
  synopsis: "Uma família mafiosa luta para estabelecer sua supremacia nos Estados Unidos depois da Segunda Guerra Mundial. Uma tentativa de assassinato deixa o chefão Vito Corleone incapacitado e força os filhos Michael e Sonny a assumir os negócios.",  # ← CORRIGIDO: "synopsis"
  release_year: 1972,
  duration: 175,
  director: "Francis Ford Coppola",
  user: user
)

puts "Criando comentários..."

# Comentário ANÔNIMO (sem usuário)
Comment.create!(
  content: "Filme incrível! A atuação do Marlon Brando é magistral. Uma obra-prima do cinema que envelheceu como vinho.",
  author_name: "Cinéfilo Anônimo",
  user: nil,
  movie: movie
)

# Comentário do USUÁRIO CADASTRADO
Comment.create!(
  content: "Assisti pela terceira vez e continuo descobrindo detalhes novos. A cena do batizado é uma das melhores já filmadas!",
  author_name: user.name,
  user: user,
  movie: movie
)

# Comentário extra anônimo
Comment.create!(
  content: "Clássico absoluto! Todo mundo deveria assistir pelo menos uma vez na vida.",
  author_name: "Amante de Cinema",
  user: nil,
  movie: movie
)

puts "Seed concluído com sucesso! 🎉"
puts "Usuário: #{user.name} (#{user.email})"
puts "Filme: #{movie.title}"
puts "Total de comentários: #{Comment.count}"
puts ""
puts "Credenciais para teste:"
puts "Email: joao@example.com"
puts "Senha: password123"