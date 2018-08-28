pragma solidity ^0.4.4;

// TODO: add restriction like onlyOwner ?
contract Sale {
    string  public storeName;
    uint256 public productId;
    uint256 public quantity;
    uint256 public priceUnit;
    address public buyer;

    constructor(string _storeName, uint256 _productId, uint256 _quantity, uint256 _priceUnit, address _buyer) public {
        storeName = _storeName;
        productId = _productId;
        quantity  = _quantity;
        priceUnit = _priceUnit;
        buyer     = _buyer;
    }

    function getTotal() public view returns (uint256) {
        return quantity * priceUnit;
    }
}
