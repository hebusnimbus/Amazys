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
    $(document).on('click', '.btn-addowner', App.addOwner);
    $(document).on('click', '.btn-addstore', App.addStore);
  },

  getRandomInt(max) {
    return Math.floor(Math.random() * Math.floor(max));
  },

  async loadMainPage() {
    try {
      const marketPlace = await App.contracts.MarketPlace.deployed();
      const isAdministrator = await marketPlace.isAdministrator();
      const isStoreOwner = await marketPlace.isStoreOwner();

      const idAccount = $('#id-account');
      idAccount[0].textContent = `(${web3.eth.accounts[0]})`;

      if (isAdministrator) {
        await App.loadOwnersView(marketPlace);
      }
      else if (isStoreOwner) {
        await App.loadStoresView(marketPlace);
      }
      else {
        await App.loadShoppersView(marketPlace);
      }
    } catch (e) {
      console.log(e);
    }
  },

  async loadOwnersView(marketPlace) {
    const numStoreOwners = parseInt(await marketPlace.getNumStoreOwners(), 10);
    console.log(`num store owners: ${numStoreOwners}`);

    const ownerView = $('#ownerView');
    const ownerViewTop = $('#ownerViewTop');
    const ownerTemplate = $('#ownerTemplate');

    ownerViewTop.append(
        '<center>'
        + '<input id="id-ownername" type="text" value="New Owner\'s Name" onfocus="this.value=\'\'"/> '
        + '<input id="id-owneraddress" type="text" value="New Owner\'s Address" onfocus="this.value=\'\'"/> '
        + '<button class="btn btn-default btn-addowner" type="button" data-id="0">Add Owner</button>'
        + '</center>'
    );

    for (i = 0; i < numStoreOwners; i ++) {
      const storeOwner = await marketPlace.getStoreOwner(i);
      ownerTemplate.find('.panel-title').text(storeOwner[1]);
      ownerTemplate.find('.btn-modify').attr('data-id', storeOwner[0]);
      ownerTemplate.find('.btn-delete').attr('data-id', storeOwner[0]);
      ownerView.append(ownerTemplate.html());
    }
  },

  async loadStoresView(marketPlace) {
    const numStores = parseInt(await marketPlace.getNumStoresForOwner(), 10);
    console.log(`num stores: ${numStores}`);

    const storeView = $('#storeView');
    const storeViewTop = $('#storeViewTop');
    const storeTemplate = $('#storeTemplate');

    storeViewTop.append(
        '<center>'
        + '<input id="id-storename" type="text" value="New Store\'s Name" onfocus="this.value=\'\'"/> '
        + '<button class="btn btn-default btn-addstore" type="button" data-id="0">Add Store</button>'
        + '</center>'
    );

    const categories = [ 'Finance', 'Health', 'Retail' ];
    const locations  = [ 'Warren, MI', 'San Francisco, CA', 'New York, NY' ];
    const images     = [ '865393164-1024x1024.jpg', '871227828-1024x1024.jpg', '881096270-1024x1024.jpg', '930645844-1024x1024.jpg' ];

    for (i = 0; i < numStores; i ++) {
      const store = await marketPlace.getStoreForOwner(i);
      storeTemplate.find('.panel-title').text(store);
      storeTemplate.find('.store-category').text(categories[App.getRandomInt(images.length)]);
      storeTemplate.find('.store-location').text(locations[App.getRandomInt(images.length)]);
      storeTemplate.find('.img-store').attr('src', 'images/stores/' + images[App.getRandomInt(images.length)]);
      storeTemplate.find('.btn-products').attr('data-store-id', i);
      storeTemplate.find('.btn-products').attr('data-store-name', store);
      storeView.append(storeTemplate.html());
    }
  },

  async loadShoppersView(marketPlace) {
    const numStores = parseInt(await marketPlace.getNumStores(), 10);
    console.log(`num all stores: ${numStores}`);

    const shopperView = $('#shopperView');
    const shopperTemplate = $('#shopperTemplate');

    const categories = [ 'Finance', 'Health', 'Retail' ];
    const locations  = [ 'Warren, MI', 'San Francisco, CA', 'New York, NY' ];
    const images     = [ '865393164-1024x1024.jpg', '871227828-1024x1024.jpg', '881096270-1024x1024.jpg', '930645844-1024x1024.jpg' ];

    for (i = 0; i < numStores; i ++) {
      const store = await marketPlace.getStore(i);
      shopperTemplate.find('.panel-title').text(store);
      shopperTemplate.find('.store-category').text(categories[App.getRandomInt(images.length)]);
      shopperTemplate.find('.store-location').text(locations[App.getRandomInt(images.length)]);
      shopperTemplate.find('.img-store').attr('src', 'images/stores/' + images[App.getRandomInt(images.length)]);
      shopperTemplate.find('.btn-shop').attr('data-store-id', store);
      shopperTemplate.find('.btn-shop').attr('data-store-name', store);
      shopperView.append(shopperTemplate.html());
    }
  },

  async addOwner(event) {
    event.preventDefault();

    // var ownerView = $('#ownerView');
    const ownerAddress = document.getElementById('id-owneraddress').value;
    const ownerName = document.getElementById('id-ownername').value;

    const marketPlace = await App.contracts.MarketPlace.deployed();
    const txn = await marketPlace.addStoreOwner(ownerAddress, ownerName);
    console.log(txn);

    // web3.eth.getTransactionReceipt(txn)
    //   .then(function (txnHash) {
    //     console.log(txnhash);
    //     return web3.eth.getTransactionReceipt(txnHash);
    //   })
    //   .then(function (receipt) {
    //     console.log(receipt);
    //   });
  },

  async addStore(event) {
    event.preventDefault();

    const storeName = document.getElementById('id-storename').value;

    const marketPlace = await App.contracts.MarketPlace.deployed();
    const txn = await marketPlace.addStore(storeName);
    console.log(txn);
  },

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
