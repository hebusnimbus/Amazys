pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Sale.sol";

contract TestSale {

    function testConstructor() public {
        Sale sale = new Sale("name", 1234, 3456, 5678, 0x1234567890);

        Assert.equal(sale.storeName(), "name", "Store name of the sale should be 'name'.");
        Assert.equal(sale.productId(), 1234, "Id of the sale should be '1234'.");
        Assert.equal(sale.quantity(), 3456, "Quantity of the sale should be '3456'.");
        Assert.equal(sale.priceUnit(), 5678, "Unit Price of the sale should be '5678'.");
        Assert.equal(sale.buyer(), 0x1234567890, "Buyer of the sale should be '0x1234567890'.");
    }

    function testGetTotal() public {
        Sale sale = new Sale("name", 1234, 3456, 5678, 0x1234567890);

        Assert.equal(sale.getTotal(), 19623168, "Total of the sale should be '19623168'.");
    }

}
