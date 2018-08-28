pragma solidity ^0.4.4;

import './Product.sol';
import './Sale.sol';

/** @title Store implementation. */
contract Store {
    address                      public owner;
    string                       public name;
    uint256                             balance;

    Product[]                           products;
    mapping (uint256 => uint256)        productQuantities;
    uint256                             numProducts;

    Sale[]                              sales;

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
        Product product = new Product(productName, price);

        productQuantities[numProducts] = quantity;
        products.push(product);

        ++numProducts;
    }

    /** @dev Returns the total number of distinct products for this store
      * @return the number of products
      */
    function getNumProducts() public view returns (uint256) {
        return products.length;
    }

    /** @dev Returns a specific product for this store
      * @param productId the id of the product
      * @return returns the product name, product price & product quantity
      */
    function getProduct(uint256 productId) public view returns (string, uint256, uint256) {
        require(productId < products.length);
        return (products[productId].name(), products[productId].price(), productQuantities[productId]);
    }

    /** @dev Executes a buy order for this store
      * @param buyer the address of the buyer
      * @param productId the id of the product
      * @param quantity the quantity of product to purchase
      */
    function sell(address buyer, uint256 productId, uint256 quantity) public {
        require(productId < numProducts);
        require(productQuantities[productId] >= quantity);

        productQuantities[productId] -= quantity;

        Sale sale = new Sale(name, productId, quantity, products[productId].price(), buyer);
        sales.push(sale);

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
        return sales.length;
    }

    /** @dev Returns a specific sale for this store
      * @param the id of the sale
      * @return the store name, product id, quantity, unit price and buyer address
      */
    function getSale(uint256 saleId) public onlyOwner view returns (string, uint256, uint256, uint256, address) {
        require(saleId < sales.length);

        Sale sale = sales[saleId];

        return (sale.storeName(), sale.productId(), sale.quantity(), sale.priceUnit(), sale.buyer());
    }
}
