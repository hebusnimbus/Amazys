pragma solidity ^0.4.4;

/** @title Product implementation. */
contract Product {
    address        owner;
    string  public name;
    uint256 public price;

    modifier onlyOwner() {
        if (msg.sender == owner) _;
    }

    constructor(string _name, uint256 _price) public {
        owner = msg.sender;
        name  = _name;
        price = _price;
    }

    /** @dev Sets the price of this product
      * @param newPrice the new price of the product
      */
    function setPrice (uint256 newPrice) public onlyOwner () {
        price = newPrice;
    }
}
