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
    $(document).on('click', '.btn-addowner',   App.addOwner);
    $(document).on('click', '.btn-addstore',   App.addStore);
  },

  async loadMainPage() {
    const marketPlace = await App.contracts.MarketPlace.deployed();
    const isAdministrator = await marketPlace.isAdministrator();
    const isStoreOwner = await marketPlace.isStoreOwner();
    console.log(isAdministrator);
    console.log(isStoreOwner);

    // console.log(await marketPlace.addStoreOwner('0xcd03f6bfe72ead29afdc828a724bc82caac1a232', 'Joanes'));

    if (isAdministrator) {
      await App.loadOwnersView(marketPlace);
    }
    else if (isStoreOwner) {
      await App.loadStoresView(marketPlace);
    }
    else {
      await App.loadShoppersView(marketPlace);
    }
  },

  async loadOwnersView(marketPlace) {
    const numStoreOwners = parseInt(await marketPlace.getNumStoreOwners(), 10);
    console.log(`num store owners: ${numStoreOwners}`);

    var ownerView = $('#ownerView');
    var ownerViewTop = $('#ownerViewTop');
    var ownerTemplate = $('#ownerTemplate');

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
    const isStoreOwner = await marketPlace.isStoreOwner();
    const numStores = parseInt(await marketPlace.getNumStores(), 10);
    console.log(`num stores: ${numStores}`);

    var storeView = $('#storeView');
    var storeViewTop = $('#storeViewTop');
    var storeTemplate = $('#storeTemplate');

    storeViewTop.append(
        '<center>'
        + '<input id="id-storename" type="text" value="New Store\'s Name" onfocus="this.value=\'\'"/> '
        + '<button class="btn btn-default btn-addstore" type="button" data-id="0">Add Store</button>'
        + '</center>'
    );

    for (i = 0; i < numStores; i ++) {
      const store = await marketPlace.getStore(i);
      storeTemplate.find('.panel-title').text(store);
      storeTemplate.find('.btn-products').attr('data-store-id', i);
      storeTemplate.find('.btn-products').attr('data-store-name', store);
      storeView.append(storeTemplate.html());
    }
  },

  async loadShoppersView(marketPlace) {
    const numStores = parseInt(await marketPlace.getNumAllStores(), 10);
    console.log(`num all stores: ${numStores}`);

    var shopperView = $('#shopperView');
    var shopperTemplate = $('#shopperTemplate');

    const stores = await marketPlace.getAllStores();
    console.log(stores);

    for (i = 0; i < stores.length; i ++) {
      shopperTemplate.find('.panel-title').text(stores[i]);
      shopperTemplate.find('.btn-shop').attr('data-store-id', stores[i]);
      shopperTemplate.find('.btn-shop').attr('data-store-name', stores[i]);
      shopperView.append(shopperTemplate.html());
    }
  },

  async addOwner(event) {
    event.preventDefault();
    console.log(event.target);

    // var ownerView = $('#ownerView');
    const ownerAddress = document.getElementById('id-owneraddress').value;
    const ownerName = document.getElementById('id-ownername').value;
    console.log(ownerAddress);

    console.log('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    const marketPlace = await App.contracts.MarketPlace.deployed();
    console.log('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    const txn = await marketPlace.addStoreOwner(ownerAddress, ownerName);
    console.log(txn);
  },

  async addStore(event) {
    event.preventDefault();
    console.log(event.target);

    const storeName = document.getElementById('id-storename').value;
    console.log(storeName);

    console.log('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
    const marketPlace = await App.contracts.MarketPlace.deployed();
    console.log('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
    const txn = await marketPlace.addStore(storeName);
    console.log(txn);
  },

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});