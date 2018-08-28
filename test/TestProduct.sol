pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Product.sol";

contract TestProduct {

    function testConstructor() public {
        Product product = new Product("name", 1234, 5678);

        Assert.equal(product.name(), "name", "Name of the product should be 'name'.");
        Assert.equal(product.price(), 1234, "Price of the product should be '1234'.");
        Assert.equal(product.quantity(), 5678, "Quantity of the product should be '5678'.");
    }

    function testSetPrice() public {
        Product product = new Product("name", 1234, 5678);

        Assert.equal(product.name(), "name", "Name of the product should be 'name'.");
        Assert.equal(product.price(), 1234, "Price of the product should be '1234'.");
        Assert.equal(product.quantity(), 5678, "Quantity of the product should be '5678'.");

        product.setPrice(3456);

        Assert.equal(product.name(), "name", "Name of the product should be 'name'.");
        Assert.equal(product.price(), 3456, "Price of the product should be '3456'.");
        Assert.equal(product.quantity(), 5678, "Quantity of the product should be '5678'.");
    }

    function testDecreaseQuantity() public {
        Product product = new Product("name", 1234, 5678);

        Assert.equal(product.name(), "name", "Name of the product should be 'name'.");
        Assert.equal(product.price(), 1234, "Price of the product should be '1234'.");
        Assert.equal(product.quantity(), 5678, "Quantity of the product should be '5678'.");

        product.decreaseQuantity(678);

        Assert.equal(product.name(), "name", "Name of the product should be 'name'.");
        Assert.equal(product.price(), 1234, "Price of the product should be '1234'.");
        Assert.equal(product.quantity(), 5000, "Quantity of the product should be '5000'.");
    }

}
