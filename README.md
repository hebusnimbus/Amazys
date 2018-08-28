# Amazys

Amazys is a market place implementation on top of the Ethereum network.

The application is a node application running [lite-server](https://www.npmjs.com/package/lite-server) as a proof of concept.

**Beware**: The focus was on the implementation of the Solidity contracts, not so much the UI.  While the UI is functional, it could be greatly improved later on with the help of a professional designer.

There are 3 types of user personas interacting with the application:
  - administrators: they manage store owners
  - store owners: they manage one or multiple stores, as well as the inventory of the stores
  - shoppers: they browse the online market place and purchase goods made available by the store owners


## Requirements

A few software and applications need to be installed prior to running this project:
  - Node, version >= 0.8
  - Ganache CLI (RPC Geth client)
  - Truffle Frameworks (development and testing suite)
  - Metamask (awesome web3 client to interact with dApps in your web browser)


## Development & Testing environment

The application can connect to any running Geth client with the following piece of code:
```
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
    } else {
      // If no injected web3 instance is detected, fall back to Ganache
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
    }
```

During the development and testing phase, the Ganache CLI was used to provide a fast and reliable Geth client implementation.

Install it and run it in its own shell:
```
$ npm install -g ganache-cli
$ ganache-cli
```

Example output:
```
Ganache CLI v6.1.8 (ganache-core: 2.2.1)

Available Accounts
==================
(0) 0x26523dfd4679294a87161a2cf74684aba8d52eb4 (~100 ETH)
(1) 0xab638944e18b84e3e1180523687968a8c0b5001c (~100 ETH)
(2) 0xd0f9e5200186d2ad93582857878cb338ee93aa5c (~100 ETH)
(3) 0xf808eb04fe04e87d299dd7e2960e7f7d922e0dd3 (~100 ETH)
(4) 0x350fefaa00d137518c8b4f95cecc88762302815f (~100 ETH)
(5) 0x036683f0ba1d4eea1d3f02881c445446a8365176 (~100 ETH)
(6) 0xc05617b193e275062cb317ca803b3227ac3c020f (~100 ETH)
(7) 0xdae8daffd77fe717d092102f053a281ec2f907de (~100 ETH)
(8) 0x0dcd19aff8e3beae2ee108bf2020287548243d2a (~100 ETH)
(9) 0x684a9aa778ff489ca0945eb48587b6ab0d5de4a8 (~100 ETH)

Private Keys
==================
(0) 0x841693981c8f3fb98beffe8e23b516a10537cb63ec36dbf21dbd3389ce8a8016
(1) 0xba42b6679c410a28a18d35b84d03e7763d58ececca9a3710eea173e3d5ac8884
(2) 0x51dbcfeca321e8d7358fb62b05c98d812d6d2c87245d381279451d04e1338631
(3) 0x92216352a65b6c5d0e91d663219956d0684d0e10f320ddd1bdc07ad438f7fdbc
(4) 0xa9e6ec201460b450538c0cc77ec51d96655056566fc32b4734df0adff262a944
(5) 0x9f5fc2647fe843be19c3c5af72ee38615ca9a9e687fabd62f5a3ce3d442d4c5b
(6) 0x36bd4bf89f7b2c64a47f4eb2f7c57c1c12c44951d0e510dc73e74d428522dc9c
(7) 0x4bf82fe821d6ca0d9eaf893f73ddba27bde35e270064de45b471706ccb60fb5f
(8) 0xfffbdac81bc7e7ab507344e26bab2075e33f5a24189320560fc173fab8ccb2b6
(9) 0x4e31fa758eb290951e4862366816d47cb05fdff632e9053295b45e7cc9f05006

HD Wallet
==================
Mnemonic:      donkey table end match organ vintage genius noise glide shoe hen manage
Base HD Path:  m/44'/60'/0'/0/{account_index}

Gas Price
==================
20000000000

Gas Limit
==================
6721975

Listening on 127.0.0.1:8545
```

Please make sure to write down the first three private keys and the mnemonic, as they will be used in the rest of this documentation (note, they will differ from run to run).

We assumed that the reader is familiar with thr Truffle Framework and has it installed already - for more details, see [here](https://www.truffleframework.com/).


## Running AmaZys

```
$ git clone https://github.com/hebusnimbus/Amazys
$ cd Amazys
$ truffle compile
$ truffle test
$ truffle migrate
$ npm run dev
```

The last command will automatically start and shift the focus to http://localhost:3000 in your default web browser, which is where most of the interactions will take place.

When first started, the application assumes the the person who first deployed the contracts is an administrator, in our example it would be:
```
Account 1: 0x26523dfd4679294a87161a2cf74684aba8d52eb4 (this will be different on your local computer)
```

For this demonstration, we will need two other accounts:
```
Account 2: 0xab638944e18b84e3e1180523687968a8c0b5001c (this will be different on your local computer)
Account 2: 0xd0f9e5200186d2ad93582857878cb338ee93aa5c (this will be different on your local computer)
```

The easiest way to create them is to import their corresponding private keys in Metamask.  At the end you would end up with something similar to:

![MetaMask](https://github.com/hebusnimbus/Amazys/blob/master/images/Metamask_Accounts.png)

Also make sure to select the default local RPC client in the configuration:

![MetaMask](https://github.com/hebusnimbus/Amazys/blob/master/images/Metamask_Network.png)

We will use:
- Account 1 as the administrator
- Account 2 as the store owner
- Account 3 as the shopper
Of course, feel free to create more of each!


### Administrator

Make sure to select `Account 1` in your MetaMask.  You should now see a simple web page allowing you to add a store owner:

![Add Owner](https://github.com/hebusnimbus/Amazys/blob/master/images/Administrator_Add_Owner.png)

Copy and paste `Account 2` value (`0xab638944e18b84e3e1180523687968a8c0b5001c` in this tutorial) and add a new store owner.  MetaMask will prompt you to confirm the transaction.

If you try to add the same address more than once, the transaction and operation will fail as expected.

Once the transaction is confirmed by MetaMask and the page has been reloaded, we should see hour first Store Owner:

![Owner Added](https://github.com/hebusnimbus/Amazys/blob/master/images/Administrator_Owner_Added.png)


### Store owner

At this point, we need to switch to the `Account 2` created in the previous section in MetaMask, and reload the page.

Note how the application understands who the user is, and shows the appropriate web page !!

Add a store, and notice how MetaMask asks for confirmation once again. Location, category and image are randomly generated, but it is easy to imagine how they could be filled in and/or uploaded by the store owner, and store in IPFS for example:

![Store Added](https://github.com/hebusnimbus/Amazys/blob/master/images/StoreOwner_Store_Added.png)

Clicking on `Products` redirects the store owner to a web page where they can add/modify/delete products in each of their store.  The procedure is the same as above:
- add a product
- wait for MetaMask to confirm the transcation and reload the page
- details are randomly generated in this demo

Here is an example:

![Owner Products](https://github.com/hebusnimbus/Amazys/blob/master/images/StoreOwner_Products.png)


### Shopper

Here, let's switch to the `Account 3` created earlier in MetaMask, and impersonate an online shopper.

Note how the application understands who the user is, and shows the appropriate web page !!

The default web page lists all the available stores, and let's the shopper look at the products:

![Stores](https://github.com/hebusnimbus/Amazys/blob/master/images/Shopper_Stores.png)

The shopper can select a store they want to purchase from, and see the available products and quantities (note how the options presented are different then for the store owners):

![Shopper Products](https://github.com/hebusnimbus/Amazys/blob/master/images/Shopper_Products.png)

The shopper can then specify how much of a specific product they want to purchase:

![Shopper Buy](https://github.com/hebusnimbus/Amazys/blob/master/images/Shopper_Buy.png)

And how the total quantity of that same product decreases after the purchase has been made (in thise case `Mugs`):

![Shopper Bought](https://github.com/hebusnimbus/Amazys/blob/master/images/Shopper_Bought.png)


The store contract keeps track of how many products shoppers have bought, as well as their balances so total balances can be deduced from their account once they go to the store to pick up their items.


## Implementation

The whole marketplace application is organized around 4 contracts:
- [MarketPlace.sol](contracts/MarketPlace.sol): main contract the node.js application interacts with
- [Product.sol](contracts/Product.sol): secondary contract to keep track of a product (name, price, etc)
- [Sale.sol](contracts/Sale.sol): secondary contract to record each transaction (store, product, shopper, quantity, price)
- [Store.sol](contracts/Store.sol): secondary contract to keep track of a store (owner, products, balance, etc)

Note that is is important to keep track of the price at the time of purchase, since prices can change overtime.


Tests are available in the test directory, and should cover each contract functions (some of these contracts are very small, and so it was not possible to write at least 5 tests per). 
```
$ truffle test

  TestProduct
    √ testConstructor (190ms)
    √ testSetPrice (172ms)
    √ testDecreaseQuantity (146ms)

  TestMarketPlace
    √ testIsAdministrator (106ms)
    √ testIsStoreOwner (52ms)
    √ testAddStoreOwner (110ms)
    √ testAddStore (146ms)
    √ testAddProduct (213ms)
    √ testBuy (325ms)

  TestSale
    √ testConstructor (176ms)
    √ testGetTotal (57ms)

  TestStore
    √ testConstructor (68ms)
    √ testAddProduct (185ms)
    √ testSell (322ms)

  14 passing (7s)
```

And finally, a small library was used in the tests, called Strings:
```
pragma solidity ^0.4.4;

library Strings {

    function toAsciiString(address x) internal pure returns (string) {
    }
    ...

}
```

And the utilization of it:
```
pragma solidity ^0.4.17;

import "./Strings.sol";

contract TestStore {

    using Strings for *;

    ...

}
```


## Security

Please check the following documentation:
- [avoiding_common_attacks.md](avoiding_common_attacks.md)
- [design_pattern_desicions.md](design_pattern_desicions.md)

The circuit breaker pattern was also implemented, in case something goes wrong with the contract:
- https://github.com/hebusnimbus/Amazys/blob/master/contracts/MarketPlace.sol#L56 
- (all write operations are halted, read operations can continue) 
