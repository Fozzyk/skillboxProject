<template>
     <main class="content container">
    <div class="content__top content__top--catalog">
      <h1 class="content__title">
        Каталог
      </h1>
      <span class="content__info">
        152 товара
      </span>
    </div>

    <div class="content__catalog">
      <ProductFilter :price-from.sync="filterPriceFrom" :price-to.sync="filterPriceTo"
      :category-id.sync="FilterCategoryId" :color-id.sync="FilterColorId" />
           <section class="catalog">

       <div v-if="productsLoading">Загрузка товаров...</div>
       <div v-if="productsLoadingFailed">Произошла ошибка при загрузке товаров
       <button @click.prevent="loadProducts">Попробовать ещё раз</button>
       </div>

       <ProductList :products="products"
       @gotoPage="(pageName, pageParams) => $emit('gotoPage', pageName, pageParams)"></ProductList>
       <BasePagination v-model="page" :count="countProducts" :per-page="productsPerPage" />
      </section>
    </div>
  </main>
</template>

<script>
import ProductList from '@/components/ProductList.vue';
import BasePagination from '@/components/BasePagination.vue';
import ProductFilter from '@/components/ProductFilter.vue';
import axios from 'axios';
import { API_BASE_URL } from '../config';

export default {
  name: 'MainPage',
  components: { ProductList, BasePagination, ProductFilter },
  data() {
    return {
      filterPriceFrom: 0,
      filterPriceTo: 0,
      FilterCategoryId: 0,
      FilterColorId: 0,

      page: 1,
      productsPerPage: 6,

      productsData: null,
      productsLoading: false,
      productsLoadingFailed: false,

    };
  },
  computed: {
    products() {
      return this.productsData ? this.productsData.items.map((product) => ({
        ...product,
        image: product.image.file.url,
      }))
        : [];
      //      const offset = (this.page - 1) * this.productsPerPage;
      //      return this.filteredProducts.slice(offset, offset + this.productsPerPage);
    },

    countProducts() {
      return this.productsData ? this.productsData.pagination.total : 0;
      // return this.filteredProducts.length;
    },
  },

  methods: {
    loadProducts() {
      this.productsLoading = true;
      this.productsLoadingFailed = false;
      clearTimeout(this.loadProductsTimer);
      this.loadProductsTimer = setTimeout(() => {
        axios
          .get(API_BASE_URL + '/api/products/', {
            params: {
              page: this.page,
              limit: this.productsPerPage,
              categoryId: this.FilterCategoryId,
              minPrice: this.filterPriceFrom,
              maxPrice: this.filterPriceTo,
              colorId: this.FilterColorId,
            },
          })
          .then((response) => { this.productsData = response.data; })
          .catch(() => { this.productsLoadingFailed = true; })
          .then(() => { this.productsLoading = false; });
      }, 500);
    },
  },
  watch: {
    page() {
      this.loadProducts();
    },
    filterPriceFrom() {
      this.loadProducts();
    },
    filterPriceTo() {
      this.loadProducts();
    },
    FilterCategoryId() {
      this.loadProducts();
    },
    FilterColorId() {
      this.loadProducts();
    },
  },
  created() {
    this.loadProducts();
  },
};

</script>
