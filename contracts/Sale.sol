pragma solidity ^0.4.4;

/** @title Sale implementation. */
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

    /** @dev Returns the total purchase price of the buy order (sale)
      * @param the total cost of the transaction
      */
    function getTotal() public view returns (uint256) {
        return quantity * priceUnit;
    }
}
