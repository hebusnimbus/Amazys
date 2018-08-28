App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    // Is there an injected web3 instance?
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
    } else {
      // If no injected web3 instance is detected, fall back to Ganache
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
    }
    web3 = new Web3(App.web3Provider);

    const queryDictionary = {};
    location.search.substr(1).split("&").forEach(function(item) {queryDictionary[item.split("=")[0]] = item.split("=")[1]});
    App.queryParameters = queryDictionary;

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('MarketPlace.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      App.contracts.MarketPlace = TruffleContract(data);

      // Set the provider for our contract
      App.contracts.MarketPlace.setProvider(App.web3Provider);

      // Use our contract to retrieve and mark the adopted pets
      return App.loadMainPage();
    });

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn-addproduct', App.addProduct);
    $(document).on('click', '.btn-buy', App.buyProduct);
  },

  getRandomInt(max) {
    return Math.floor(Math.random() * Math.floor(max));
  },

  async loadMainPage() {
    const marketPlace = await App.contracts.MarketPlace.deployed();
    const isStoreOwner = await marketPlace.isStoreOwner();

    const idAccount = $('#id-account');
    idAccount[0].textContent = `(${web3.eth.accounts[0]})`;

    const storeName = decodeURIComponent(App.queryParameters.storeName.replace(/\+/g, '%20'));

    const numProducts = parseInt(await marketPlace.getNumProducts(storeName), 10);
    console.log(`num products: ${numProducts}`);

    const productView = $('#productView');
    const productViewTop = $('#productViewTop');
    const productTemplate = $('#productTemplate');

    if (isStoreOwner) {
      productViewTop.append(
          '<center>'
          + '<input id="id-productname" type="text" value="New Product\'s Name" onfocus="this.value=\'\'"/> '
          + '<input id="id-productprice" type="text" value="New Product\'s Price" onfocus="this.value=\'\'"/> '
          + '<input id="id-productquantity" type="text" value="New Product\'s Quantity" onfocus="this.value=\'\'"/> '
          + '<button class="btn btn-default btn-addproduct" type="button" data-id="0">Add Product</button>'
          + '</center>'
      );
    }

    const images = [ 'background-mugs.jpg', 'cosmetic-oil-1533662273oZu.jpg', 'grated-cheese.jpg', 'essential-oil-1529590473ZTy.jpg' ];

    for (i = 0; i < numProducts; i ++) {
      const product = await marketPlace.getProduct(storeName, i);
      productTemplate.find('.panel-title').text(product[0]);
      productTemplate.find('.product-price').text(product[1]);
      productTemplate.find('.product-quantity').text(product[2]);
      productTemplate.find('.img-product').attr('src', 'images/products/' + images[App.getRandomInt(images.length)]);
      productTemplate.find('.btn-buy').attr('data-id', i);
      productTemplate.find('.btn-modify').attr('data-id', i);
      productTemplate.find('.btn-delete').attr('data-id', i);
      if (isStoreOwner) {
        productTemplate.find('.btn-buy').attr('style', 'display: none;');
      } else {
        productTemplate.find('.btn-modify').attr('style', 'display: none;');
        productTemplate.find('.btn-delete').attr('style', 'display: none;');
      }
      productView.append(productTemplate.html());
    }
  },

  async addProduct(event) {
    event.preventDefault();

    const productName = document.getElementById('id-productname').value;
    const productPrice = document.getElementById('id-productprice').value;
    const productQuantity = document.getElementById('id-productquantity').value;
    const storeName = decodeURIComponent(App.queryParameters.storeName.replace(/\+/g, '%20'));

    const marketPlace = await App.contracts.MarketPlace.deployed();
    const txn = await marketPlace.addProduct(storeName, productName, productPrice, productQuantity);
    console.log(txn);
  },

  async buyProduct(event) {
    event.preventDefault();

    const productId = event.target.attributes['data-id'].value;
    const storeName = decodeURIComponent(App.queryParameters.storeName.replace(/\+/g, '%20'));

    const quantity = prompt("Quantity", "1");
    if (quantity !== null && quantity !== "") {
      const marketPlace = await App.contracts.MarketPlace.deployed();
      const txn = await marketPlace.buy(storeName, productId, quantity);
      console.log(txn);
    }
  },

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
