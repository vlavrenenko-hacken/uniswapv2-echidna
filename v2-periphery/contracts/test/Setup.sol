// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./UniswapV2Pair.sol";
import "./UniswapV2ERC20.sol";
import "./UniswapV2Factory.sol";
import {UniswapV2Library, UniswapV2Router02} from "../UniswapV2Router02.sol";

contract Users {
  function proxy(address target, bytes memory _calldata)
    public
    returns (bool success, bytes memory returnData)
  {
    (success, returnData) = address(target).call(_calldata);
  }
}

contract Setup {
    UniswapV2ERC20 testToken1; 
    UniswapV2ERC20 testToken2;
    UniswapV2Pair pair;
    UniswapV2Factory factory;
    UniswapV2Router02 router;
    Users user;
    bool completed;
   
    event Debug(string str);
    constructor() {
        testToken1 = new UniswapV2ERC20();
        testToken2 = new UniswapV2ERC20();
        factory = new UniswapV2Factory(address(this)); //this contract will be the fee setter
        router = new UniswapV2Router02(address(factory),address(0)); // we don't need to test WETH pairs for now
        address pairAddr = factory.createPair(address(testToken1), address(testToken2));
        pair = UniswapV2Pair(pairAddr);
        user = new Users();
    }
    
    function _doApprovals() internal {
        user.proxy(address(testToken1),abi.encodeWithSelector(testToken1.approve.selector,address(router), ~uint(0)));
        user.proxy(address(testToken2),abi.encodeWithSelector(testToken2.approve.selector,address(router), ~uint(0)));
    }

    function _mintTokens(uint amount1, uint amount2) internal {
        testToken2.mint(address(user), amount2);
        testToken1.mint(address(user), amount1); 
        _doApprovals();
        completed = true;
    }
    
    function _between(
        uint256 val,
        uint256 lower,
        uint256 upper
    ) internal pure returns (uint256) {
        return lower + (val % (upper - lower + 1));
    }
    
}