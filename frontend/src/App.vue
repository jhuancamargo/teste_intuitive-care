<template>
  <div class="container">
    <h1>Operadoras de Saúde</h1>

    <!-- Navegação por abas -->
    <div class="tabs">
      <button
        :class="{ active: activeTab === 'top' }"
        @click="activeTab = 'top'"
      >
        Top 10 Operadoras
      </button>
      <button
        :class="{ active: activeTab === 'search' }"
        @click="activeTab = 'search'"
      >
        Pesquisar Operadoras
      </button>
    </div>

    <!-- Conteúdo da aba Top 10 -->
    <div v-if="activeTab === 'top'" class="tab-content">
      <div class="controls">
        <label for="periodo">Selecione o Período:</label>
        <select v-model="selectedPeriod" @change="fetchTopOperadoras" id="periodo">
          <option v-for="period in periods" :key="period.value" :value="period.value">
            {{ period.label }}
          </option>
        </select>
      </div>
      <div v-if="loadingTop" class="loading">Carregando...</div>
      <table v-else class="table">
        <thead>
          <tr>
            <th>Operadora</th>
            <th>Despesas (R$)</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="operadora in topOperadoras" :key="operadora.razao_social">
            <td>{{ operadora.razao_social }}</td>
            <td>{{ formatCurrency(operadora.total_despesas) }}</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Conteúdo da aba Pesquisa -->
    <div v-if="activeTab === 'search'" class="tab-content">
      <div class="search-container">
        <label for="search">Buscar Operadora:</label>
        <input
          type="text"
          v-model="searchQuery"
          @input="fetchSearchResults"
          id="search"
          placeholder="Digite o nome da operadora..."
        />
      </div>
      <div v-if="loadingSearch" class="loading">Carregando...</div>
      <table v-else-if="searchResults.length > 0" class="table">
        <thead>
          <tr>
            <th>Registro ANS</th>
            <th>Razão Social</th>
            <th>CNPJ</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="result in searchResults" :key="result.reg_ans">
            <td>{{ result.reg_ans }}</td>
            <td>{{ result.razao_social }}</td>
            <td>{{ result.cnpj }}</td>
          </tr>
        </tbody>
      </table>
      <p v-else-if="searchQuery && !loadingSearch" class="no-results">Nenhuma operadora encontrada.</p>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'OperadorasSaude',
  data() {
    return {
      activeTab: 'top', // Aba inicial
      topOperadoras: [],
      selectedPeriod: 'q1-2023',
      loadingTop: true,
      periods: [
        { value: 'q1-2023', label: 'Q1 2023' },
        { value: 'q2-2023', label: 'Q2 2023' },
        { value: 'q3-2023', label: 'Q3 2023' },
        { value: 'q4-2023', label: 'Q4 2023' },
        { value: 'q1-2024', label: 'Q1 2024' },
        { value: 'q2-2024', label: 'Q2 2024' },
        { value: 'q3-2024', label: 'Q3 2024' },
        { value: 'q4-2024', label: 'Q4 2024' },
        { value: '2023', label: 'Ano 2023' },
        { value: '2024', label: 'Ano 2024' }
      ],
      searchQuery: '',
      searchResults: [],
      loadingSearch: false
    };
  },
  mounted() {
    this.fetchTopOperadoras();
  },
  methods: {
    fetchTopOperadoras() {
      this.loadingTop = true;
      axios.get(`/api/top-operadoras/${this.selectedPeriod}`)
        .then(response => {
          this.topOperadoras = response.data;
          this.loadingTop = false;
        })
        .catch(error => {
          console.error('Erro ao buscar top operadoras:', error);
          this.loadingTop = false;
        });
    },
    fetchSearchResults() {
      if (!this.searchQuery.trim()) {
        this.searchResults = [];
        return;
      }
      this.loadingSearch = true;
      axios.get(`/api/search-operadoras?q=${encodeURIComponent(this.searchQuery)}`)
        .then(response => {
          this.searchResults = response.data;
          this.loadingSearch = false;
        })
        .catch(error => {
          console.error('Erro ao buscar operadoras:', error);
          this.loadingSearch = false;
        });
    },
    formatCurrency(value) {
      return Number(value).toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }
  }
};
</script>

<style scoped>
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  font-family: Arial, sans-serif;
}

h1 {
  text-align: center;
  color: #333;
  margin-bottom: 30px;
}

.tabs {
  display: flex;
  justify-content: center;
  gap: 10px;
  margin-bottom: 20px;
}

.tabs button {
  padding: 10px 20px;
  font-size: 16px;
  border: none;
  background-color: #f0f0f0;
  cursor: pointer;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.tabs button.active {
  background-color: #007bff;
  color: white;
}

.tabs button:hover:not(.active) {
  background-color: #e0e0e0;
}

.tab-content {
  padding: 20px 0;
}

.controls, .search-container {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 20px;
}

label {
  font-weight: bold;
  color: #555;
}

select, input {
  padding: 8px 12px;
  font-size: 16px;
  border: 1px solid #ccc;
  border-radius: 4px;
  outline: none;
  transition: border-color 0.3s;
}

select:focus, input:focus {
  border-color: #007bff;
}

input {
  flex: 1;
  max-width: 400px;
}

.table {
  width: 100%;
  border-collapse: collapse;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

th, td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

th {
  background-color: #007bff;
  color: white;
  font-weight: bold;
}

tr:nth-child(even) {
  background-color: #f9f9f9;
}

tr:hover {
  background-color: #f1f1f1;
}

.loading {
  text-align: center;
  color: #777;
  margin: 20px 0;
}

.no-results {
  text-align: center;
  color: #888;
  margin: 20px 0;
}
</style>