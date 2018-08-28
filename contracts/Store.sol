pragma solidity ^0.4.4;

import './Product.sol';
import './Sale.sol';

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

    function addProduct(string productName, uint256 price, uint256 quantity) public onlyOwner {
        Product product = new Product(productName, price);

        productQuantities[numProducts] = quantity;
        products.push(product);

        ++numProducts;
    }

    function getNumProducts() public view returns (uint256) {
        return products.length;
    }

    function getProduct(uint256 productId) public view returns (string, uint256, uint256) {
        require(productId < products.length);
        return (products[productId].name(), products[productId].price(), productQuantities[productId]);
    }

    function sell(address buyer, uint256 productId, uint256 quantity) public {
        require(productId < numProducts);
        require(productQuantities[productId] >= quantity);

        productQuantities[productId] -= quantity;

        Sale sale = new Sale(name, productId, quantity, products[productId].price(), buyer);
        sales.push(sale);

        balance += sale.getTotal();
    }

    function getBalance() public onlyOwner view returns (uint256) {
        return balance;
    }

    function getNumSales() public onlyOwner view returns (uint256) {
        return sales.length;
    }

    function getSale(uint256 saleId) public onlyOwner view returns (string, uint256, uint256, uint256, address) {
        require(saleId < sales.length);

        Sale sale = sales[saleId];

        return (sale.storeName(), sale.productId(), sale.quantity(), sale.priceUnit(), sale.buyer());
    }
}
