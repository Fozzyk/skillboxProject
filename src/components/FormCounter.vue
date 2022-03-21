<template>
<div class="form__counter">
                <button type="button" aria-label="Убрать один товар"  @click="productAmount--" :disabled="productAmount === 1">
                  <svg width="12" height="12" fill="currentColor">
                    <use xlink:href="#icon-minus"></use>
                  </svg>
                </button>

                <input type="num" v-model.number="productAmount" name="count">

                <button type="button" aria-label="Добавить один товар" @click.prevent="productAmount++">
                  <svg width="12" height="12" fill="currentColor">
                    <use xlink:href="#icon-plus"></use>
                  </svg>
                </button>
              </div>
</template>

<script>
export default {
  props: {
    amount: { required: true },
  },
  computed: {
    productAmount: {
      get() {
        return this.amount;
      },
      set(value) {
        this.$emit('update:amount', value);
      },
    },
  },
};
</script>
