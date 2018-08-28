pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Product.sol";

contract TestProduct {

    function testConstructor() public {
        Product product = new Product("name", 1234);

        Assert.equal(product.name(), "name", "Name of the product should be 'name'.");
        Assert.equal(product.price(), 1234, "Price of the product should be '1234'.");
    }

    function testSetPrice() public {
        Product product = new Product("name", 1234);

        Assert.equal(product.name(), "name", "Name of the product should be 'name'.");
        Assert.equal(product.price(), 1234, "Price of the product should be '1234'.");

        product.setPrice(5678);

        Assert.equal(product.name(), "name", "Name of the product should be 'name'.");
        Assert.equal(product.price(), 5678, "Price of the product should be '5678'.");
    }

}
