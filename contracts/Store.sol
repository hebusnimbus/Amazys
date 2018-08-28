pragma solidity ^0.4.4;

import './Product.sol';
import './Sale.sol';

/** @title Store implementation. */
contract Store {
    address                      public owner;
    string                       public name;
    uint256                             balance;

    mapping (uint256 => Product)        productsIndex;
    uint256                             numProducts;

    mapping (uint256 => Sale)           salesIndex;
    uint256                             numSales;

    modifier onlyOwner() {
        if (msg.sender == owner) _;
    }

    constructor (string _name) public {
        owner = msg.sender;
        name  = _name;
    }

    /** @dev Adds a product to the store
      * @param productName the name of the product
      * @param price the price of the product
      * @param quantity the quantity for this product
      */
    function addProduct(string productName, uint256 price, uint256 quantity) public onlyOwner {
        productsIndex[numProducts] = new Product(productName, price, quantity);

        ++numProducts;
    }

    /** @dev Returns the total number of distinct products for this store
      * @return the number of products
      */
    function getNumProducts() public view returns (uint256) {
        return numProducts;
    }

    /** @dev Returns a specific product for this store
      * @param productIndex the id of the product
      * @return returns the product name, product price & product quantity
      */
    function getProduct(uint256 productIndex) public view returns (string, uint256, uint256) {
        require(productIndex < numProducts);

        Product product = productsIndex[productIndex];

        return (product.name(), product.price(), product.quantity());
    }

    /** @dev Executes a buy order for this store
      * @param buyer the address of the buyer
      * @param productIndex the id of the product
      * @param quantity the quantity of product to purchase
      */
    function sell(address buyer, uint256 productIndex, uint256 quantity) public {
        require(productIndex < numProducts);

        Product product = productsIndex[productIndex];

        require(product.quantity() >= quantity);

        product.decreaseQuantity(quantity);

        Sale sale = new Sale(name, productIndex, quantity, product.price(), buyer);
        salesIndex[numSales++] = sale;

        balance += sale.getTotal();
    }

    /** @dev Returns the total gains for this store
      * @return the total balance
      */
    function getBalance() public onlyOwner view returns (uint256) {
        return balance;
    }

    /** @dev Returns the total number of sales for this store
      * @return the number of sales
      */
    function getNumSales() public onlyOwner view returns (uint256) {
        return numSales;
    }

    /** @dev Returns a specific sale for this store
      * @param saleIndex the index of the sale
      * @return the store name, product id, quantity, unit price and buyer address
      */
    function getSale(uint256 saleIndex) public onlyOwner view returns (string, uint256, uint256, uint256, address) {
        require(saleIndex < numSales);

        Sale sale = salesIndex[saleIndex];

        return (sale.storeName(), sale.productIndex(), sale.quantity(), sale.priceUnit(), sale.buyer());
    }
}
