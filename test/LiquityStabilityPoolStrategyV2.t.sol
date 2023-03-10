// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "utils/BaseTest.sol";
import "script/LiquityStabilityPoolStrategyV2.s.sol";

contract MyTest is BaseTest {
    LiquityStabilityPoolStrategy public strategy;

    function setUp() public override {
        forkMainnet(15371985);
        super.setUp();

        LiquityStabilityPoolStrategyV2Script script = new LiquityStabilityPoolStrategyV2Script();
        script.setTesting(true);
        (strategy) = script.run();
    }

    function test() public {
        
    }
}
