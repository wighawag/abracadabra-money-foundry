// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "BoringSolidity/interfaces/IERC20.sol";
import "BoringSolidity/libraries/BoringERC20.sol";
import "interfaces/ILiquityStabilityPool.sol";
import "./BaseStrategy.sol";

contract LiquityStabilityPoolStrategyFrontendTag {
    constructor(ILiquityStabilityPool _pool) {
        _pool.registerFrontEnd(1e18);
    }
}

contract LiquityStabilityPoolStrategy is BaseStrategy {
    using BoringERC20 for IERC20;

    error ErrInvalidFeePercent();
    error ErrUnsupportedToken(IERC20 token);
    error ErrSwapFailed();
    error ErrInsufficientAmountOut();

    event LogFeeChanged(uint256 previousFee, uint256 newFee, address previousFeeCollector, address newFeeCollector);
    event LogFeeCollected(uint256 amountOu);
    event LogSwapperChanged(address oldSwapper, address newSwapper);
    event LogRewardSwapped(IERC20 token, uint256 total, uint256 amountOut);
    event LogRewardTokenUpdated(IERC20 token, bool enabled);

    uint256 public constant BIPS = 10_000;

    ILiquityStabilityPool public immutable pool;
    address public immutable tag;

    address public feeCollector;
    uint8 public feeBips;
    address public swapper;

    mapping(IERC20 => bool) public rewardTokenEnabled;

    constructor(
        IERC20 _strategyToken,
        IBentoBoxV1 _bentoBox,
        ILiquityStabilityPool _pool
    ) BaseStrategy(_strategyToken, _bentoBox) {
        pool = _pool;
        feeCollector = msg.sender;
        IERC20(_strategyToken).approve(address(_pool), type(uint256).max);

        // Register a dummy frontend tag set to 100% since we
        // should be getting all rewards in this contract.
        tag = address(new LiquityStabilityPoolStrategyFrontendTag(_pool));
    }

    /// @dev only allowed to receive eth from the stability pool
    receive() external payable {
        require(msg.sender == address(pool));
    }

/**
        uint256 feeAmount = (total * feeBips) / BIPS;
        if (feeAmount > 0) {
            amountOut = total - feeAmount;
            IERC20(strategyToken).safeTransfer(feeCollector, feeAmount);
        }
 */
    function _skim(uint256 amount) internal virtual override {
        pool.provideToSP(amount, tag);
    }

    function _harvest(uint256) internal virtual override returns (int256) {
        pool.withdrawFromSP(0);
        return int256(0);
    }

    function _withdraw(uint256 amount) internal virtual override {
        pool.withdrawFromSP(amount);
    }

    function _exit() internal virtual override {
        pool.withdrawFromSP(pool.getCompoundedLUSDDeposit(address(this)));
    }

    function swapRewards(
        uint256 amountOutMin,
        IERC20 rewardToken,
        bytes calldata data
    ) external onlyExecutor returns (uint256 amountOut) {
        if (!rewardTokenEnabled[rewardToken]) {
            revert ErrUnsupportedToken(rewardToken);
        }

        uint256 amountBefore = IERC20(strategyToken).balanceOf(address(this));
        uint256 value;

        // use eth reward?
        if (address(rewardToken) == address(0)) {
            value = address(this).balance;
        } else {
            rewardToken.approve(swapper, rewardToken.balanceOf(address(this)));
        }

        (bool success, ) = swapper.call{value: value}(data);
        if (!success) {
            revert ErrSwapFailed();
        }

        uint256 total = IERC20(strategyToken).balanceOf(address(this)) - amountBefore;

        if (total < amountOutMin) {
            revert ErrInsufficientAmountOut();
        }

        if (address(rewardToken) != address(0)) {
            rewardToken.approve(swapper, 0);
        }

        emit LogRewardSwapped(rewardToken, total, amountOut);
    }

    function setFeeParameters(address _feeCollector, uint8 _feeBips) external onlyOwner {
        if (feeBips > BIPS) {
            revert ErrInvalidFeePercent();
        }

        emit LogFeeChanged(feeBips, _feeBips, feeCollector, _feeCollector);

        feeCollector = _feeCollector;
        feeBips = _feeBips;
    }

    function setSwapper(address _swapper) external onlyOwner {
        emit LogSwapperChanged(swapper, _swapper);
        swapper = _swapper;
    }

    /// @param token The reward token to add, use address(0) for ETH
    function setRewardTokenEnabled(IERC20 token, bool enabled) external onlyOwner {
        rewardTokenEnabled[token] = enabled;
        emit LogRewardTokenUpdated(token, enabled);
    }

    function resetAllowance() external onlyOwner {
        IERC20(strategyToken).approve(address(pool), type(uint256).max);
    }
}
