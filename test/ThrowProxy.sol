pragma solidity ^0.4.4;

// https://truffleframework.com/tutorials/testing-for-throws-in-solidity-tests

contract ThrowProxy {
    address public target;
    bytes          data;

    constructor(address _target) public {
        target = _target;
    }

    // Prime the data using the fallback function.
    function() public {
        data = msg.data;
    }

    function execute() public returns (bool) {
        return target.call(data);
    }
}
