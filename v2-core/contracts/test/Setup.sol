// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../UniswapV2ERC20.sol";
import  "../UniswapV2Factory.sol";
import "../UniswapV2Pair.sol";

contract Users {
    function proxy(address target, bytes memory data) public returns (bool success, bytes memory retData ) {
        return target.call(data);
    }
}


contract Setup {
    UniswapV2ERC20 testToken1;
    UniswapV2ERC20 testToken2;
    UniswapV2Pair pair;
    UniswapV2Factory factory;
    Users user;
    bool completed;

    constructor() {
        testToken1 = new UniswapV2ERC20();
        testToken2 = new UniswapV2ERC20();
        factory = new UniswapV2Factory(address(this));
        address pairAddress = factory.createPair(address(testToken1), address(testToken2));
        pair = UniswapV2Pair(pairAddress);
        user = new Users();
    }

    function _mintTokens(uint amount1, uint amount2) internal {
        // We overrode the function _mint inside of the UniswapV2ERC20
        testToken1.mint(address(user), amount1);
        testToken2.mint(address(user), amount2);
        completed = true;
    }

    function _between(uint value, uint low, uint high) internal pure returns(uint) {
        return (low + (value & (high - low + 1)));
    }
}