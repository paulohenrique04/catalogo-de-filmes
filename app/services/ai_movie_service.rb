require 'openai'

class AiMovieService
    def initialize
        @client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    end

    def fetch_movie_information(title)
        prompt = <<~PROMPT
        Me retorne os dados abaixo **em formato JSON válido** sobre o filme #{title}. 
        {
            "title": "",
            "synopsis": "",
            "year": "",
            "director": "",
            "duration": ""
        } 
        Se não souber, preencha os campos com "Desconhecido".
        PROMPT

        response = @client.chat(
            parameters: {
                model: "gpt-4o-mini",
                messages: [{ role: "user", content: prompt}],
                temperature: 0.2
            }
        )

        raw = response.dig("choices", 0, "message", "content")
        JSON.parse(raw) rescue { error: "Falha ao interpretar a resposta da IA" }
    end
end