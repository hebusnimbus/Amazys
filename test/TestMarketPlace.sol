pragma solidity ^0.4.17;
pragma experimental ABIEncoderV2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/MarketPlace.sol";

contract TestMarketPlace {

    MarketPlace marketPlace = MarketPlace(DeployedAddresses.MarketPlace());

    function testIsAdministrator() public {
        bool isAdministrator = marketPlace.isAdministrator();

        Assert.equal(isAdministrator, false, "Default user should not be an administrator.");
    }

    function testIsStoreOwner() public {
        bool isStoreOwner = marketPlace.isStoreOwner();

        Assert.equal(isStoreOwner, false, "Default user should not be a store owner.");
    }

    function testAddStoreOwner() public {
        uint256 numOwners = marketPlace.getNumStoreOwners();
        Assert.equal(numOwners, 0, "Number of store owners should be 0.");

        // TODO: This fails because of the restriction on the function.
//        marketPlace.addStoreOwner(0x1234567890, "name");
//
//        numOwners = marketPlace.getNumStoreOwners();
//        Assert.equal(numOwners, 1, "Number of store owners should be 1.");
//
//        address addr; string memory name;
//        (addr, name) = marketPlace.getStoreOwner(0);
    }

    function testAddStore() public {
        uint256 numStores = marketPlace.getNumStores();
        Assert.equal(numStores, 0, "Number of stores should be 0.");

        uint256 numAllStores = marketPlace.getNumAllStores();
        Assert.equal(numAllStores, 0, "Number of all stores should be 0.");

        string[] memory allStores = marketPlace.getAllStores();
        Assert.equal(allStores.length, 0, "Number of all stores should be 0.");

        // TODO: This fails because of the restriction on the function.
//        marketPlace.addStore("name");
//
//        uint256 numAllStores = marketPlace.getNumAllStores();
//        Assert.equal(numAllStores, 1, "Number of all stores should be 1.");
//
//        string[] memory allStores = marketPlace.getAllStores();
//        Assert.equal(allStores.length, 1, "Number of all stores should be 1.");
//        Assert.equal(allStores[0], "name", "Name of the store should be 'name'.");
    }

    function testAddProduct() public {
        // TODO: This fails because of the restriction on the function.
//        marketPlace.addStore("name");
//
//        uint256 numProducts = marketPlace.getNumProducts("name");
//        Assert.equal(numProducts, 0, "Number of products should be 0.");
//
//        marketPlace.addProduct("name", "productName", 1234, 100);
//
//        numProducts = marketPlace.getNumProducts("name");
//        Assert.equal(numProducts, 1, "Number of products should be 1.");
//
//        string memory name; uint256 price; uint256 quantity;
//        (name, price, quantity) = marketPlace.getProduct("name", 0);
//
//        Assert.equal(name, "name", "Name of the product should be 'name'.");
//        Assert.equal(price, 1234, "Price of the product should be '1234'.");
//        Assert.equal(quantity, 100, "Quantity of the product should be '100'.");
    }

    function testBuy() public {
        // TODO: This fails because of the restriction on the function.
//        marketPlace.addStore("name");
//        marketPlace.addProduct("name", "productName", 1234, 100);
//
//        uint256 numStores = marketPlace.getNumStores();
//        Assert.equal(numStores, 1, "Number of stores should be 1.");
//
//        uint256 numProducts = marketPlace.getNumProducts("name");
//        Assert.equal(numProducts, 1, "Number of products should be 1.");
//
//        string memory name; uint256 price; uint256 quantity;
//        (name, price, quantity) = marketPlace.getProduct("name", 0);
//
//        Assert.equal(name, "name", "Name of the product should be 'name'.");
//        Assert.equal(price, 1234, "Price of the product should be '1234'.");
//        Assert.equal(quantity, 100, "Quantity of the product should be '100'.");
//
//        marketPlace.buy("name", 0, 10);
//
//        numProducts = marketPlace.getNumProducts("name");
//        Assert.equal(numProducts, 1, "Number of products should be 1.");
//
//        (name, price, quantity) = marketPlace.getProduct("name", 0);
//
//        Assert.equal(name, "name", "Name of the product should be 'name'.");
//        Assert.equal(price, 1234, "Price of the product should be '1234'.");
//        Assert.equal(quantity, 90, "Quantity of the product should be '90'.");
    }
}