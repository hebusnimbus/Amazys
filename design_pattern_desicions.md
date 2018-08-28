### Use mappings whenever possible (cheaper storage and faster to execute)

For example:
- https://github.com/hebusnimbus/Amazys/blob/master/contracts/MarketPlace.sol#L23
- https://github.com/hebusnimbus/Amazys/blob/master/contracts/MarketPlace.sol#L26


### Separate logical units in their own contracts (easier to read code and avoid bugs)

- Followed object oriented approach (Store, Product, MarketPlace) to keep the flow between contracts as simple as possible.


### Implemented a circuit breaker

- The circuit breaker `stopInEmergency` stops any write operations in the MarketPlace contract (read operations are still allowed).
