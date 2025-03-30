<template>
  <div>
    <h1>Top 10 Operadoras - Q4 2024</h1>
    <ul>
      <li v-for="operadora in operadorasQ4" :key="operadora.razao_social">
        {{ operadora.razao_social }} - R$ {{ formatCurrency(operadora.total_despesas) }}
      </li>
    </ul>
    <h1>Top 10 Operadoras - 2024</h1>
    <ul>
      <li v-for="operadora in operadorasYear" :key="operadora.razao_social">
        {{ operadora.razao_social }} - R$ {{ formatCurrency(operadora.total_despesas) }}
      </li>
    </ul>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'TopOperadoras',
  data() {
    return {
      operadorasQ4: [],
      operadorasYear: []
    };
  },
  mounted() {
    this.fetchOperadorasQ4();
    this.fetchOperadorasYear();
  },
  methods: {
    fetchOperadorasQ4() {
      axios.get('http://localhost:5000/api/top-operadoras/q4-2024')
        .then(response => {
          this.operadorasQ4 = response.data;
        })
        .catch(error => {
          console.error('Erro ao buscar operadoras Q4:', error);
        });
    },
    fetchOperadorasYear() {
      axios.get('http://localhost:5000/api/top-operadoras/2024')
        .then(response => {
          this.operadorasYear = response.data;
        })
        .catch(error => {
          console.error('Erro ao buscar operadoras 2024:', error);
        });
    },
    formatCurrency(value) {
      return Number(value).toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }
  }
};
</script>

<style scoped>
ul {
  list-style-type: none;
  padding: 0;
}
li {
  margin: 10px 0;
}
</style>