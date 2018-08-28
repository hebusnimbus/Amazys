There were a few paradigms that were followed during the development phase:

### Made sure to add the correct restrictions on functions

For example: https://github.com/hebusnimbus/Amazys/blob/master/contracts/MarketPlace.sol#L49

--> prevents wrong user to execute functions they are not supposed to execute

### Used `require` statements whenever possible

For example: https://github.com/hebusnimbus/Amazys/blob/master/contracts/MarketPlace.sol#L88

--> insures execution is aborted if bad data is sent to the contract
