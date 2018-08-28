pragma solidity ^0.4.4;
pragma experimental ABIEncoderV2;

import './Store.sol';

contract MarketPlace {
    // Structs
    struct Owner {
        address addr;
        string  name;
        Store[] stores;
    }

    // Variables
    mapping (address => uint8) administrators;

    Owner[]                    owners;
    mapping (address => Owner) ownersByAddress;

    Store[]                    stores;
    mapping (string => Store)  storesByName;

    // Modifiers
    modifier onlyAdministrators() {
        require(administrators[msg.sender] != address(0));
        _;
    }

    modifier onlyStoreOwners () {
        require(ownersByAddress[msg.sender].addr != address(0));
        _;
    }

    // Constructor
    constructor() public {
        administrators[msg.sender] = 1;
    }

    // Identity
    function isAdministrator() public view returns (bool) {
        return administrators[msg.sender] != address(0);
    }

    function isStoreOwner() public view returns (bool) {
        return ownersByAddress[msg.sender].addr != address(0);
    }

    // Store owners
    function addStoreOwner(address storeOwner, string name) public onlyAdministrators {
        require(ownersByAddress[storeOwner].addr == address(0));

        Owner memory owner = Owner(storeOwner, name, new Store[](0));
        ownersByAddress[storeOwner] = owner;
        owners.push(owner);
    }

    function getNumStoreOwners() public view returns (uint256) {
        return owners.length;
    }

    function getStoreOwner(uint256 storeOwnerId) public view returns (address, string) {
        require(storeOwnerId < owners.length);
        return (owners[storeOwnerId].addr, owners[storeOwnerId].name);
    }

    // Stores
    function addStore (string storeName) public onlyStoreOwners {
        address storeOwner = msg.sender;

        require(ownersByAddress[storeOwner].addr != address(0));
        require(storesByName   [storeName]       == address(0));

        Store store = new Store(storeName);
        ownersByAddress[storeOwner].stores.push(store);
        stores.push(store);
        storesByName[storeName] = store;
    }

    function getNumStores() public view returns (uint256) {
        if (ownersByAddress[msg.sender].addr == address(0)) {
            return 0;
        }

        return ownersByAddress[msg.sender].stores.length;
    }

    function getStore(uint256 storeId) public view returns (string) {
        require(ownersByAddress[msg.sender].addr != address(0));
        return ownersByAddress[msg.sender].stores[storeId].name();
    }

    function getNumAllStores() public view returns (uint256) {
        return stores.length;
    }

    function getAllStores() public view returns (string[]) {
        string[] memory allStores = new string[](stores.length);
        for (uint i=0; i<stores.length; i++) {
            allStores[i] = stores[i].name();
        }
        return allStores;
    }

    // Products
    function addProduct(string storeName, string productName, uint256 price, uint256 quantity) public onlyStoreOwners {
        require(storesByName[storeName] != address(0));

        storesByName[storeName].addProduct(productName, price, quantity);
    }

    function getNumProducts(string storeName) public view returns (uint256) {
        require(storesByName[storeName] != address(0));

        return storesByName[storeName].getNumProducts();
    }

    function getProduct(string storeName, uint256 productId) public view returns (string, uint256, uint256) {
        require(storesByName[storeName] != address(0));

        return storesByName[storeName].getProduct(productId);
    }

    // Sales
    function buy(string storeName, uint256 productId, uint256 quantity) public {
        require(storesByName[storeName] != address(0));

        storesByName[storeName].sell(msg.sender, productId, quantity);
    }
}
