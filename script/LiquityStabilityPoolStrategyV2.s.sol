// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "utils/BaseScript.sol";
import "utils/CauldronDeployLib.sol";
import "oracles/ProxyOracle.sol";
import "oracles/InverseOracle.sol";
import "swappers/TokenSwapper.sol";
import "swappers/TokenLevSwapper.sol";
import "strategies/LiquityStabilityPoolStrategy.sol";

contract LiquityStabilityPoolStrategyV2Script is BaseScript {
    function run()
        public
        returns (
            LiquityStabilityPoolStrategy strategy
        )
    {
        address safe = constants.getAddress("mainnet.safe.ops");
        IBentoBoxV1 degenBox = IBentoBoxV1(constants.getAddress("mainnet.degenBox"));

        startBroadcast();

        strategy = new LiquityStabilityPoolStrategy(
            IERC20(constants.getAddress("mainnet.liquity.lusd")),
            degenBox,
            ILiquityStabilityPool(constants.getAddress("mainnet.liquity.stabilityPool"))
        );

        strategy.setRewardTokenEnabled(IERC20(address(0)), true);
        strategy.setRewardTokenEnabled(IERC20(constants.getAddress("mainnet.liquity.lqty")), true);
        strategy.setSwapper(constants.getAddress("mainnet.aggregators.zeroXExchangProxy"));

        if (!testing) {
            strategy.setStrategyExecutor(0x762d06bB0E45f5ACaEEA716336142a39376E596E, true); // Strategy Executor
            strategy.setStrategyExecutor(safe, true); // Strategy Executor
            strategy.setFeeParameters(safe, 10);
            strategy.transferOwnership(safe, true, false);
        } else {
            strategy.setStrategyExecutor(deployer(), true);
        }

        stopBroadcast();
    }
}
