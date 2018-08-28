pragma solidity ^0.4.4;

import './Store.sol';

/** @title Market Place implementation. */
contract MarketPlace {
    // ----------  Structs  ----------

    struct Owner {
        address addr;
        string  name;
        Store[] stores;
    }

    // ----------  Variables  ----------

    // The variable "testing" should be removed before going to production!!!
    // It has been added here so the tests can run, but should not be allowed in production.
    bool private testing = false;
    bool private stopped = false;

    mapping (address => uint8) administrators;

    mapping (address => Owner) ownersByAddress;
    mapping (uint256 => Owner) ownersIndex;
    uint256                    numOwners;

    mapping (string  => Store) storesByName;
    mapping (uint256 => Store) storesIndex;
    uint256                    numStores;

    // ----------  Modifiers  ----------

    modifier onlyAdministrators() {
        require(testing || administrators[msg.sender] != address(0));
        _;
    }

    modifier onlyStoreOwners () {
        require(testing || ownersByAddress[msg.sender].addr != address(0));
        _;
    }

    modifier stopInEmergency { if (!stopped) _; }

    modifier onlyInEmergency { if (stopped) _; }

    // ----------  Constructor  ----------

    constructor() public {
        administrators[msg.sender] = 1;
    }

    // ----------  Identity  ----------

    function isAdministrator() public view returns (bool) {
        return administrators[msg.sender] != address(0);
    }

    function isStoreOwner() public view returns (bool) {
        return ownersByAddress[msg.sender].addr != address(0);
    }

    function toggleContractActive() public onlyAdministrators {
        stopped = !stopped;
    }

    function setTesting(bool _testing) public {
        testing = _testing;
    }

    // ----------  Store owners  ----------

    /** @dev Adds a new store owner - only administrators can perform this task.
      * @param storeOwner the owner of the store.
      * @param name the name of the owner.
      */
    function addStoreOwner(address storeOwner, string name) public stopInEmergency onlyAdministrators {
        require(testing || ownersByAddress[storeOwner].addr == address(0));

        Owner memory owner = Owner(storeOwner, name, new Store[](0));
        ownersByAddress[storeOwner] = owner;
        ownersIndex[numOwners++] = owner;
    }

    /** @dev Returns the total number of store owners.
      * @return the total number of store owners
      */
    function getNumStoreOwners() public view returns (uint256) {
        return numOwners;
    }

    /** @dev Returns a specific store owner.
      * @param storeOwnerIndex the id of the store owner
      * @return the address and name of the store owner
      */
    function getStoreOwner(uint256 storeOwnerIndex) public view returns (address, string) {
        require(storeOwnerIndex < numOwners);

        Owner memory owner = ownersIndex[storeOwnerIndex];

        return (owner.addr, owner.name);
    }

    // ----------  Stores  ----------

    /** @dev Adds a new store - only store owners can perform this task.
      * @param storeName the name of the store.
      */
    function addStore (string storeName) public stopInEmergency onlyStoreOwners {
        address storeOwner = msg.sender;

        require(testing || ownersByAddress[storeOwner].addr != address(0));
        require(testing || storesByName   [storeName]       == address(0));

        Store store = new Store(storeName);
        ownersByAddress[storeOwner].stores.push(store);
        storesIndex[numStores++] = store;
        storesByName[storeName] = store;
    }

    /** @dev Returns the number of stores for the current store owner (msg.sender).
      * @return the total number of stores for the current owner
      */
    function getNumStoresForOwner() public view returns (uint256) {
        if (ownersByAddress[msg.sender].addr == address(0)) {
            return 0;
        }

        return ownersByAddress[msg.sender].stores.length;
    }

    /** @dev Returns a specific store belonging to the current store owner (msg.sender).
      * @param storeIndex the id of the store
      * @return the name of the store
      */
    function getStoreForOwner(uint256 storeIndex) public view returns (string) {
        require(ownersByAddress[msg.sender].addr != address(0));
        return ownersByAddress[msg.sender].stores[storeIndex].name();
    }

    /** @dev Returns the total number of all stores available in the market place (all owners combined).
      * @return the total number of stores
      */
    function getNumStores() public view returns (uint256) {
        return numStores;
    }

    /** @dev Returns a specific store among all the stores available in the market place (all owners combined).
      * @return the names of the store
      */
    function getStore(uint256 storeIndex) public view returns (string) {
        require(storeIndex < numStores);
        return storesIndex[storeIndex].name();
    }

    // ----------  Products  ----------

    /** @dev Adds a new product to a store - only store owners can perform this task.
      * @param storeName the name of the store
      * @param productName the name of the product
      * @param price the price of the product
      * @param quantity the quantity of the product
      */
    function addProduct(string storeName, string productName, uint256 price, uint256 quantity) public stopInEmergency onlyStoreOwners {
        require(testing || storesByName[storeName] != address(0));

        storesByName[storeName].addProduct(productName, price, quantity);
    }

    /** @dev Returns the number of products in a specific store.
      * @return the number of products in the store
      */
    function getNumProducts(string storeName) public view returns (uint256) {
        require(storesByName[storeName] != address(0));

        return storesByName[storeName].getNumProducts();
    }

    /** @dev Returns a specific product in a store.
      * @param storeName the name of the store
      * @param productIndex the id of the product
      * @return the name of the store, price and quantity of the product
      */
    function getProduct(string storeName, uint256 productIndex) public view returns (string, uint256, uint256) {
        require(storesByName[storeName] != address(0));

        return storesByName[storeName].getProduct(productIndex);
    }

    // ----------  Sales  ----------

    /** @dev Executes a buy order of a specific product.
      * @param storeName the name of the store
      * @param productIndex the id of the product
      * @param quantity the quantity of products to purchase
      */
    function buy(string storeName, uint256 productIndex, uint256 quantity) public stopInEmergency {
        require(storesByName[storeName] != address(0));

        storesByName[storeName].sell(msg.sender, productIndex, quantity);
    }
}
