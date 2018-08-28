pragma solidity ^0.4.4;
pragma experimental ABIEncoderV2;

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

    Owner[]                    owners;
    mapping (address => Owner) ownersByAddress;

    Store[]                    stores;
    mapping (string => Store)  storesByName;

    // ----------  Modifiers  ----------

    modifier onlyAdministrators() {
        require(testing || administrators[msg.sender] != address(0));
        _;
    }

    modifier onlyStoreOwners () {
        require(testing || ownersByAddress[msg.sender].addr != address(0));
        _;
    }

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

    modifier stopInEmergency { if (!stopped) _; }

    modifier onlyInEmergency { if (stopped) _; }

    // ----------  Store owners  ----------

    /** @dev Adds a new store owner - only administrators can perform this task.
      * @param storeOwner the owner of the store.
      * @param name the name of the owner.
      */
    function addStoreOwner(address storeOwner, string name) public stopInEmergency onlyAdministrators {
        require(testing || ownersByAddress[storeOwner].addr == address(0));

        Owner memory owner = Owner(storeOwner, name, new Store[](0));
        ownersByAddress[storeOwner] = owner;
        owners.push(owner);
    }

    /** @dev Returns the total number of store owners.
      * @return the total number of store owners
      */
    function getNumStoreOwners() public view returns (uint256) {
        return owners.length;
    }

    /** @dev Returns a specific store owner.
      * @param storeOwnerId the id of the store owner
      * @return the address and name of the store owner
      */
    function getStoreOwner(uint256 storeOwnerId) public view returns (address, string) {
        require(storeOwnerId < owners.length);
        return (owners[storeOwnerId].addr, owners[storeOwnerId].name);
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
        stores.push(store);
        storesByName[storeName] = store;
    }

    /** @dev Returns the number of stores for the current store owner (msg.sender).
      * @return the total number of stores for the current owner
      */
    function getNumStores() public view returns (uint256) {
        if (ownersByAddress[msg.sender].addr == address(0)) {
            return 0;
        }

        return ownersByAddress[msg.sender].stores.length;
    }

    /** @dev Returns a specific store belonging to the current store owner (msg.sender).
      * @param storeId the id of the store
      * @return the name of the store
      */
    function getStore(uint256 storeId) public view returns (string) {
        require(ownersByAddress[msg.sender].addr != address(0));
        return ownersByAddress[msg.sender].stores[storeId].name();
    }

    /** @dev Returns the total number of all stores available in the market place (all owners conbined).
      * @return the total number of stores
      */
    function getNumAllStores() public view returns (uint256) {
        return stores.length;
    }

    /** @dev Returns all the names of all the stores available in the market place (all owners conbined).
      * @return the names of the stores
      */
    function getAllStores() public view returns (string[]) {
        string[] memory allStores = new string[](stores.length);
        for (uint i=0; i<stores.length; i++) {
            allStores[i] = stores[i].name();
        }
        return allStores;
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
      * @param productId the id of the product
      * @return the name of the store, price and quantity of the product
      */
    function getProduct(string storeName, uint256 productId) public view returns (string, uint256, uint256) {
        require(storesByName[storeName] != address(0));

        return storesByName[storeName].getProduct(productId);
    }

    // ----------  Sales  ----------

    /** @dev Executes a buy order of a specific product.
      * @param storeName the name of the store
      * @param productId the id of the product
      * @param quantity the quantity of products to purchase
      */
    function buy(string storeName, uint256 productId, uint256 quantity) public stopInEmergency {
        require(storesByName[storeName] != address(0));

        storesByName[storeName].sell(msg.sender, productId, quantity);
    }
}
