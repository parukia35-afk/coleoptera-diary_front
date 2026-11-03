<template>
  <Header></Header>
  <Hero></Hero>
  <Footer></Footer>
  <recordHero></recordHero>
  <FilterBar></FilterBar>
  <RecordTable></RecordTable>
</template>

<script setup lang="ts">
import Header from './components/layout/Header.vue';
import Footer from './components/layout/Footer.vue';
import Hero from './components/home/HomeHero.vue';
import recordHero from './components/record/RecordHero.vue';
import FilterBar from './components/record/FilterBar.vue';
import RecordTable from './components/record/RecordTable.vue';
</script>

<style scoped></style>
