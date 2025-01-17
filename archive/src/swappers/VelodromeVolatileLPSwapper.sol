// SPDX-License-Identifier: MIT
// solhint-disable avoid-low-level-calls
pragma solidity >=0.8.0;

import "BoringSolidity/interfaces/IERC20.sol";
import "BoringSolidity/libraries/BoringERC20.sol";
import "libraries/SafeApprove.sol";
import "interfaces/ISolidlyLpWrapper.sol";
import "interfaces/ISwapperV2.sol";
import "interfaces/ISolidlyPair.sol";
import "interfaces/IBentoBoxV1.sol";
import "interfaces/ISolidlyRouter.sol";

struct VelodromeVolatileLPSwapperSwap {
    address tokenIn;
    address tokenOut;
    bool stable;
}

contract VelodromeVolatileLPSwapper is ISwapperV2 {
    using BoringERC20 for IERC20;
    using SafeApprove for IERC20;

    error ErrToken0SwapFailed();
    error ErrToken1SwapFailed();

    IBentoBoxV1 public immutable bentoBox;
    ISolidlyLpWrapper public immutable wrapper;
    ISolidlyPair public immutable pair;
    IERC20 public immutable mim;
    IERC20 public immutable token0;
    IERC20 public immutable token1;
    ISolidlyRouter public immutable router;
    VelodromeVolatileLPSwapperSwap[] public swaps;

    constructor(
        IBentoBoxV1 _bentoBox,
        ISolidlyLpWrapper _wrapper,
        IERC20 _mim,
        ISolidlyRouter _router,
        VelodromeVolatileLPSwapperSwap[] memory _swaps
    ) {
        bentoBox = _bentoBox;
        wrapper = _wrapper;
        mim = _mim;

        pair = ISolidlyPair(address(_wrapper.underlying()));

        IERC20 _token0 = IERC20(pair.token0());
        IERC20 _token1 = IERC20(pair.token1());
        mim.approve(address(_bentoBox), type(uint256).max);
        _token0.safeApprove(address(_router), type(uint256).max);
        _token1.safeApprove(address(_router), type(uint256).max);

        token0 = _token0;
        token1 = _token1;
        router = _router;

        for (uint256 i = 0; i < _swaps.length; ) {
            swaps.push(_swaps[i]);
            unchecked {
                ++i;
            }
        }
    }

    /// @inheritdoc ISwapperV2
    function swap(
        address,
        address,
        address recipient,
        uint256 shareToMin,
        uint256 shareFrom,
        bytes calldata
    ) public override returns (uint256 extraShare, uint256 shareReturned) {
        (uint256 amountFrom, ) = bentoBox.withdraw(IERC20(address(wrapper)), address(this), address(this), 0, shareFrom);

        // Wrapper -> Solidly Pair
        wrapper.leaveTo(amountFrom, address(pair));

        // Solidly Pair -> Token0, Token1
        pair.burn(address(this));

        for (uint256 i = 0; i < swaps.length; ) {
            router.swapExactTokensForTokensSimple(
                IERC20(swaps[i].tokenIn).balanceOf(address(this)),
                0,
                swaps[i].tokenIn,
                swaps[i].tokenOut,
                swaps[i].stable,
                address(this),
                type(uint256).max
            );
            unchecked {
                ++i;
            }
        }

        (, shareReturned) = bentoBox.deposit(mim, address(this), recipient, mim.balanceOf(address(this)), 0);
        extraShare = shareReturned - shareToMin;
    }
}
