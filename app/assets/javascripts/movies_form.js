document.addEventListener('DOMContentLoaded', function() {
  const fetchButton = document.getElementById('fetch-ai-data');
  
  if (!fetchButton) return;

  const titleField = document.getElementById('movie-title');
  const synopsisField = document.getElementById('movie-synopsis');
  const releaseYearField = document.getElementById('movie-release-year');
  const durationField = document.getElementById('movie-duration');
  const directorField = document.getElementById('movie-director');
  const loadingDiv = document.getElementById('ai-loading');
  const errorDiv = document.getElementById('ai-error');

  fetchButton.addEventListener('click', function() {
    const title = titleField.value.trim();
    
    if (!title) {
      showError('Por favor, digite um título para buscar.');
      return;
    }

    // Mostrar loading
    loadingDiv.classList.remove('d-none');
    errorDiv.classList.add('d-none');
    fetchButton.disabled = true;

    // Fazer requisição para a IA
    fetch(`/movies/fetch_ai_data?title=${encodeURIComponent(title)}`)
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
      })
      .then(data => {
        if (data.error) {
          showError('Erro ao buscar dados: ' + data.error);
        } else {
          // Preencher os campos com os dados da IA
          if (data.title && data.title !== "Desconhecido") titleField.value = data.title;
          if (data.synopsis && data.synopsis !== "Desconhecido") synopsisField.value = data.synopsis;
          if (data.year && data.year !== "Desconhecido") releaseYearField.value = data.year;
          if (data.director && data.director !== "Desconhecido") directorField.value = data.director;
          if (data.duration && data.duration !== "Desconhecido") {
            const duration = extractMinutes(data.duration);
            if (duration) durationField.value = duration;
          }
          
          showSuccess('Dados preenchidos automaticamente! Revise e ajuste se necessário.');
        }
      })
      .catch(error => {
        console.error('Erro detalhado:', error);
        showError('Erro ao buscar dados do filme. Tente novamente.');
      })
      .finally(() => {
        loadingDiv.classList.add('d-none');
        fetchButton.disabled = false;
      });
  });

  function showError(message) {
    if (errorDiv) {
      errorDiv.textContent = message;
      errorDiv.classList.remove('d-none');
    }
  }

  function showSuccess(message) {
    // Mostrar mensagem de sucesso temporária
    const successDiv = document.createElement('div');
    successDiv.className = 'alert alert-success alert-dismissible fade show mt-3';
    successDiv.innerHTML = `
      ${message}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    const form = document.querySelector('form');
    if (form) {
      form.insertBefore(successDiv, form.firstChild);
    }
    
    // Remover após 5 segundos
    setTimeout(() => {
      if (successDiv.parentNode) {
        successDiv.remove();
      }
    }, 5000);
  }

  function extractMinutes(durationString) {
    if (typeof durationString !== 'string') return null;
    
    // Tentar extrair minutos de strings como "2h 30min", "150 min", etc.
    const hoursMatch = durationString.match(/(\d+)\s*h/);
    const minutesMatch = durationString.match(/(\d+)\s*min/);
    
    let totalMinutes = 0;
    
    if (hoursMatch) {
      totalMinutes += parseInt(hoursMatch[1]) * 60;
    }
    
    if (minutesMatch) {
      totalMinutes += parseInt(minutesMatch[1]);
    }
    
    // Se não encontrou padrões, tentar pegar apenas números
    if (totalMinutes === 0) {
      const numbers = durationString.match(/\d+/g);
      if (numbers && numbers.length > 0) {
        totalMinutes = parseInt(numbers[0]);
      }
    }
    
    return totalMinutes > 0 ? totalMinutes : null;
  }
});