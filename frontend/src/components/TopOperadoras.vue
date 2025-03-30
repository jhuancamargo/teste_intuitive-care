<template>
    <div>
      <h1>Top 10 Operadoras - Q4 2024</h1>
      <ul>
        <li v-for="operadora in operadorasQ4" :key="operadora.razao_social">
          {{ operadora.razao_social }} - R$ {{ operadora.total_despesas.toLocaleString('pt-BR') }}
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
        operadorasQ4: []
      };
    },
    mounted() {
      this.fetchOperadoras();
    },
    methods: {
      fetchOperadoras() {
        axios.get('http://localhost:5000/api/top-operadoras/q4-2024')
          .then(response => {
            this.operadorasQ4 = response.data;
          })
          .catch(error => {
            console.error('Erro ao buscar operadoras:', error);
          });
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