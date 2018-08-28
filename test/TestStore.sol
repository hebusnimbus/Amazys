pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Store.sol";
import "./Strings.sol";
//import "./ThrowProxy.sol";

contract TestStore {

    using Strings for *;

    function testConstructor() public {
        Store store = new Store("name");

        Assert.equal(store.name(), "name", "Name of the store should be 'name'.");
    }

    function testAddProduct() public {
        Store store = new Store("name");

        Assert.equal(store.name(), "name", "Name of the store should be 'name'.");
        Assert.equal(store.getNumProducts(), 0, "Number of products should be 0.");

        store.addProduct("productName", 1234, 100);

        Assert.equal(store.name(), "name", "Name of the store should be 'name'.");
        Assert.equal(store.getNumProducts(), 1, "Number of products should be 1.");

        string memory name; uint256 price; uint256 quantity;
        (name, price, quantity) = store.getProduct(0);

        Assert.equal(name, "productName", "Product name should be 'productName'.");
        Assert.equal(price, 1234, "Product price should be '1234'.");
        Assert.equal(quantity, 100, "Product quantity should be '100'.");
    }

//    function testGetProductException() public {
//        Store store = new Store("name");
//        store.addProduct("productName", 1234, 100);
//
//        // Set Store as the contract to forward requests to. The target.
//        ThrowProxy throwProxy = new ThrowProxy(address(store));
//
//        // Prime the proxy.
//        Store(address(throwProxy)).getProduct(0);
//
//        // Execute the call that is supposed to throw.
//        // r will be false if it threw. r will be true if it didn't.
//        // Make sure to send enough gas for the contract method.
//        bool r = throwProxy.execute.gas(1000000000)();
//
//        Assert.isFalse(r, "Expected exception since the product does not exist.");
//    }

    function testSell() public {
        Store store = new Store("name");

        Assert.equal(store.name(), "name", "Name of the store should be 'name'.");
        Assert.equal(store.getNumProducts(), 0, "Number of products should be 0.");

        store.addProduct("productName", 1234, 100);

        Assert.equal(store.name(), "name", "Name of the store should be 'name'.");
        Assert.equal(store.getNumProducts(), 1, "Number of products should be 1.");

        store.sell(0x1234567890, 0, 10);

        string memory name; uint256 price; uint256 quantity;
        (name, price, quantity) = store.getProduct(0);

        Assert.equal(name, "productName", "Product name should be 'productName'.");
        Assert.equal(price, 1234, "Product price should be '1234'.");
        Assert.equal(quantity, 90, "Product quantity should be '90'.");

        uint256 balance = store.getBalance();
        Assert.equal(balance, 12340, "Store balance should be '12340'.");

        uint256 numSales = store.getNumSales();
        Assert.equal(numSales, 1, "Number of sales should be '1'.");

        string memory storeName; uint256 productId; uint256 priceUnit; address buyer;
        (storeName, productId, quantity, priceUnit, buyer) = store.getSale(0);

        Assert.equal(storeName, "name", "Store name should be 'name'.");
        Assert.equal(productId, 0, "Sale Product id should be '0'.");
        Assert.equal(quantity, 10, "Sale quantity should be '90'.");
        Assert.equal(priceUnit, 1234, "Sale price unit should be '1234'.");
        Assert.equal(buyer, 0x1234567890, "Buyer should be '0x1234567890'.");
    }

}
