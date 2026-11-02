<template>
  <Header></Header>
  <Hero></Hero>
  <Footer></Footer>
  <recordHero></recordHero>
  <FilterBar></FilterBar>
</template>

<script setup lang="ts">
import Header from './components/layout/header.vue';
import Footer from './components/layout/footer.vue';
import Hero from './components/home/homeHero.vue';
import recordHero from './components/record/recordHero.vue';
import FilterBar from './components/record/filterBar.vue';
</script>

<style scoped></style>
