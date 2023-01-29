//SPDX-License-Identifier: MIT
pragma solidity 0.8.13;
import "./Setup.sol";

contract EchidnaTest is Setup {

    // 1 invariant: Providing liquidity increases invariant
    // x*y = k => increasing x and y increases k!
    function testProvideLiquidity(uint amount1, uint amount2) external {
    
        if(!completed) {
            // Pre-conditions: we gotta have 1000 as MINIMUM_LIQUIDITY
            amount1 = _between(amount1, 1000, ~uint(0));
            amount2 = _between(amount2, 1000, ~uint(0));
            _mintTokens(amount1, amount2);
        }
        uint lpTokenBalanceBefore = pair.balanceOf(address(user));
        (uint reserve0Before, uint reserve1Before,) = pair.getReserves();
        uint kBefore = reserve0Before * reserve1Before; // Solidity ^0.6.0, it might create an overflow/underflow, but since we use uint112/uint112 => uint112 * uint112 = uint224<uint256, it's not gonna happen

        (bool success,) = user.proxy(address(testToken1), abi.encodeWithSelector(testToken1.transfer.selector, address(pair), amount1));
        (bool success1,) = user.proxy(address(testToken2), abi.encodeWithSelector(testToken2.transfer.selector, address(pair), amount2));
        require(success && success1);

        // Actions. Adding liquidity
        (bool success2, ) = user.proxy(address(pair), abi.encodeWithSelector(bytes4(keccak256("mint(address)")), address(user)));

        // Post-conditions
        if(success2) {

            uint lpTokenBalanceAfter = pair.balanceOf(address(user));
            (uint reserve0After, uint reserve1After,) = pair.getReserves();
            uint kAfter = reserve0After * reserve1After;

            assert(lpTokenBalanceBefore < lpTokenBalanceAfter);
            assert(kBefore < kAfter);

        }
    }
    function testSwap(uint amount1, uint amount2) external {
        // Pre-conditions:
        if(!completed) {
            _mintTokens(amount1, amount2);

        }
        require(pair.balanceOf(address(user)) > 0); // there is liquidity
        pair.sync(); // match the balances with the reserves

        //Call:
        (bool success1,) = user.proxy(address(pair), abi.encodeWithSelector(pair.swap.selector, amount1, amount2, address(user), ""));

        // Post-condition
        assert(!success1); // call should never succeed
    
    }

}