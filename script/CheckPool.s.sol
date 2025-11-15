// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

interface IUniswapV3Pool {
    function tickSpacing() external view returns (int24);
    function fee() external view returns (uint24);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function slot0() external view returns (
        uint160 sqrtPriceX96,
        int24 tick,
        uint16 observationIndex,
        uint16 observationCardinality,
        uint16 observationCardinalityNext,
        uint8 feeProtocol,
        bool unlocked
    );
}

contract CheckPoolScript is Script {
    address constant POOL = 0xB5AD58CBcc1a9DB06A9852b20aEc95FF3ba56F3a;

    function run() external view {
        IUniswapV3Pool pool = IUniswapV3Pool(POOL);
        
        int24 tickSpacing = pool.tickSpacing();
        uint24 fee = pool.fee();
        address token0 = pool.token0();
        address token1 = pool.token1();
        (uint160 sqrtPriceX96, int24 tick, , , , , ) = pool.slot0();
        
        console.log("Pool Info:");
        console.log("  Tick Spacing:", int256(tickSpacing));
        console.log("  Fee:", fee);
        console.log("  Token0:", token0);
        console.log("  Token1:", token1);
        console.log("  Current Tick:", int256(tick));
        console.log("  Current SqrtPriceX96:", sqrtPriceX96);
        
        console.log("\nValid ticks must be multiples of", int256(tickSpacing));
        console.log("For default range near current tick:");
        
        int24 lower = (tick / tickSpacing) * tickSpacing - (20 * tickSpacing);
        int24 upper = (tick / tickSpacing) * tickSpacing + (20 * tickSpacing);
        
        console.log("  Suggested tickLower:", int256(lower));
        console.log("  Suggested tickUpper:", int256(upper));
    }
}
