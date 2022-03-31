<template>
        <ul>
            <router-link class="catalog__pic" :to="{name: 'product', params: {id: product.id}}">
              <img v-bind:src="product.image" :alt="product.title">
            </router-link>
            <h3 class="catalog__title">
              <a href="#">
                {{ product.title }}
              </a>
            </h3>
            <span class="catalog__price">
              {{ product.price | numberFormat }} ₽
            </span>
            <FormColor class="colors colors--black"
            :colors="product.colors" />
          </ul>
</template>

<script>
import gotoPage from '@/helpers/gotoPage';
import numberFormat from '@/helpers/numberFormat';
import FormColor from '@/components/FormColor.vue';

export default {
  components: { FormColor },
  filters: {
    numberFormat,
  },
  methods: {
    gotoPage,
  },
  props: ['product'],
};
</script>
