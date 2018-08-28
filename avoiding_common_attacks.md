There were a few paradigms that were followed during the development phase:

### Made sure to add the correct restrictions on functions

For example: https://github.com/hebusnimbus/Amazys/blob/master/contracts/MarketPlace.sol#L60

--> prevents wrong user to execute functions they are not supposed to execute

### Used `require` statements whenever possible

For example: https://github.com/hebusnimbus/Amazys/blob/master/contracts/MarketPlace.sol#L92-L93

--> insures execution is aborted if bad data is sent to the contract

### Explicitly mark visibility in functions and state variables

All functions and variables have been marked as public ONLY when necessary, defaulting all others to private.

### Race Conditions - Reentrancy

Special attention as given to re-entrancy issues.
