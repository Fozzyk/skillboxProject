<template>
    <main class="content container">
    <div class="content__top">
      <ul class="breadcrumbs">
        <li class="breadcrumbs__item">
          <a class="breadcrumbs__link" href="index.html">
            Каталог
          </a>
        </li>
        <li class="breadcrumbs__item">
          <router-link class="breadcrumbs__link" :to="{name: 'cart'}">
            Корзина
          </router-link>
        </li>
        <li class="breadcrumbs__item">
          <a class="breadcrumbs__link">
            Оформление заказа
          </a>
        </li>
      </ul>

      <h1 class="content__title">
        Корзина
      </h1>
      <span class="content__info">
        Количество товара: {{ totalAmount  }}
      </span>
    </div>

    <section class="cart">
      <form class="cart__form form" action="#" method="POST" @submit.prevent="order">
        <div class="cart__field">
          <div class="cart__data">

        <BaseFormText title="ФИО" v-model="formData.name" :error="formError.name" placeholder="Введите ваше полное имя" />

        <BaseFormText title="Адрес доставки" v-model="formData.address" :error="formError.address" placeholder="Введите ваш адрес" />

        <BaseFormText title="Телефон" v-model="formData.phone" :error="formError.phone" type="tel" placeholder="Введите ваш телефон" />

        <BaseFormText title="Email" v-model="formData.email" :error="formError.email" type="email" placeholder="Введи ваш Email" />

        <BaseFormTextArea title="Комментарий к заказу" v-model="formData.comment" :error="formError.comment" placeholder="Ваши пожелания"/>
          </div>

          <div class="cart__options">
            <h3 class="cart__title">Доставка</h3>
            <ul class="cart__options options">
              <li class="options__item">
                <label class="options__label">
                  <input class="options__radio sr-only" type="radio" name="delivery" value="0" checked="">
                  <span class="options__value">
                    Самовывоз <b>бесплатно</b>
                  </span>
                </label>
              </li>
              <li class="options__item">
                <label class="options__label">
                  <input class="options__radio sr-only" type="radio" name="delivery" value="500">
                  <span class="options__value">
                    Курьером <b>Бесплатно ₽</b>
                  </span>
                </label>
              </li>
            </ul>

            <h3 class="cart__title">Оплата</h3>
            <ul class="cart__options options">
              <li class="options__item">
                <label class="options__label">
                  <input class="options__radio sr-only" type="radio" name="pay" value="card">
                  <span class="options__value">
                    Картой при получении
                  </span>
                </label>
              </li>
              <li class="options__item">
                <label class="options__label">
                  <input class="options__radio sr-only" type="radio" name="pay" value="cash">
                  <span class="options__value">
                    Наличными при получении
                  </span>
                </label>
              </li>
            </ul>
          </div>
        </div>

        <div class="cart__block">
          <ul class="cart__orders">
<OrderItem  v-for="item in products" :key="item.productId" :item="item" />
          </ul>

          <div class="cart__total">
            <p>Доставка: <b>Бесплатно ₽</b></p>
            <p>Итого товаров: <b>{{ totalAmount  }}</b> на сумму <b>{{ totalPrice | numberFormat }} ₽</b></p>
          </div>

          <button class="cart__button button button--primery" type="submit"  :disabled="orderLoading">
            Оформить заказ
          </button>
       <Preloader v-if="orderLoading"/>
       <div v-if="orderLoadingFailed">Произошла ошибка при оформлении заказа</div>
        </div>
        <div class="cart__error form__error-block" v-if="formErrorMessage">
          <h4>Заявка не отправлена!</h4>
          <p>
            {{ formErrorMessage }}
          </p>
        </div>
      </form>
    </section>
  </main>
</template>

<script>
import numberFormat from '@/helpers/numberFormat';
import BaseFormText from '@/components/BaseFormText.vue';
import BaseFormTextArea from '@/components/BaseFormTextArea.vue';
import OrderItem from '@/components/OrderItem.vue';
import Preloader from '@/data/Preloader.vue';
import axios from 'axios';
import { mapGetters } from 'vuex';
import { API_BASE_URL } from '../config';

export default {
  name: 'OrderPage',
  filters: { numberFormat },
  components: {
    BaseFormText,
    BaseFormTextArea,
    OrderItem,
    Preloader,
  },
  computed: {
    ...mapGetters({ products: 'cartDetailProducts', totalPrice: 'cartTotalPrice', totalAmount: 'cartTotalAmount' }),

  },
  data() {
    return {
      formData: {},
      formError: {},
      formErrorMessage: '',

      orderLoading: false,
      orderLoadingFailed: false,
    };
  },
  methods: {
    order() {
      this.formError = {};
      this.formErrorMessage = '';
      this.orderLoading = true;
      this.orderLoadingFailed = false;
      clearTimeout(this.loadProductsTimer);
      this.loadProductsTimer = setTimeout(() => {
        axios
          .post(API_BASE_URL + '/api/orders', {
            ...this.formData,
          }, {
            params: {
              userAccessKey: this.$store.state.userAccessKey,
            },
          })
          .then((response) => {
            this.$store.commit('resetCart');
            this.$store.commit('updateOrderInfo', response.data);
            this.$router.push({ name: 'orderInfo', params: { id: response.data.id } }, 0);
          })
          .catch((error) => {
            this.formError = error.response.data.error.request || {};
            this.formErrorMessage = error.response.data.error.message;
          })
          .then((response) => { this.formData = response.data; })
          .catch(() => { this.orderLoadingFailed = true; })
          .then(() => { this.orderLoading = false; });
      }, 3000);
    },
  },
};

</script>
