// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
// #Font Awesomeの導入
import '@fortawesome/fontawesome-free/js/all';

// ＃yarn installでBootstrapをインストールする場合に、下記を追記する必要がある
import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application";

// #追記 5段階評価の実装
import Raty from "raty.js"
window.raty = function(elem,opt) {
  let raty =  new Raty(elem,opt)
  raty.init();
  return raty;
}

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// #追記 5段階評価の実装
window.$ = window.jQuery = require('jquery');

// // #Swiper.jsのための記述
// import Swiper from 'swiper';

// document.addEventListener('DOMContentLoaded', function() {
//   const swiper = new Swiper(".swiper", {
//     pagination: {
//       el: ".swiper-pagination",
//     },
//     navigation: {
//       nextEl: ".swiper-button-next",
//       prevEl: ".swiper-button-prev",
//     },
//   });
// });
