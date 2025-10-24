// app/javascript/movies_form.js
document.addEventListener('DOMContentLoaded', function() {
  const fetchButton = document.getElementById('fetch-ai-data');
  const titleField = document.getElementById('movie-title');
  const loadingDiv = document.getElementById('ai-loading');
  const errorDiv = document.getElementById('ai-error');
  
  if (fetchButton && titleField) {
    fetchButton.addEventListener('click', function() {
      const title = titleField.value.trim();
      
      if (!title) {
        showError('Por favor, digite um título para buscar.');
        return;
      }
      
      // Mostrar loading
      loadingDiv.classList.remove('d-none');
      errorDiv.classList.add('d-none');
      
      // Fazer requisição para a API
      fetch(`/movies/fetch_ai_data?title=${encodeURIComponent(title)}`)
        .then(response => response.json())
        .then(data => {
          loadingDiv.classList.add('d-none');
          
          if (data.error) {
            showError(`Erro: ${data.error}`);
          } else {
            // Preencher os campos com os dados da IA
            fillFormWithData(data);
          }
        })
        .catch(error => {
          loadingDiv.classList.add('d-none');
          showError('Erro ao buscar dados: ' + error.message);
        });
    });
  }
  
  function showError(message) {
    errorDiv.textContent = message;
    errorDiv.classList.remove('d-none');
  }
  
  function fillFormWithData(data) {
    if (data.title) document.getElementById('movie-title').value = data.title;
    if (data.synopsis) document.getElementById('movie-synopsis').value = data.synopsis;
    if (data.year) document.getElementById('movie-release-year').value = data.year;
    if (data.director) document.getElementById('movie-director').value = data.director;
    if (data.duration) document.getElementById('movie-duration').value = data.duration;
    
    // Mostrar mensagem de sucesso
    showError('Dados preenchidos automaticamente! Revise as informações antes de salvar.');
    errorDiv.classList.remove('alert-danger');
    errorDiv.classList.add('alert-success');
  }
});