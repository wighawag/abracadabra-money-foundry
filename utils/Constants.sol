// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "forge-std/Vm.sol";

library ChainId {
    uint256 internal constant Mainnet = 1;
    uint256 internal constant BSC = 56;
    uint256 internal constant Polygon = 137;
    uint256 internal constant Fantom = 250;
    uint256 internal constant Optimism = 10;
    uint256 internal constant Arbitrum = 42161;
    uint256 internal constant Avalanche = 43114;
}

/// @dev https://stargateprotocol.gitbook.io/stargate/developers/chain-ids
library StargateChainId {
    uint256 internal constant Mainnet = 101;
    uint256 internal constant BSC = 102;
    uint256 internal constant Avalanche = 106;
    uint256 internal constant Polygon = 109;
    uint256 internal constant Arbitrum = 110;
    uint256 internal constant Optimism = 111;
    uint256 internal constant Fantom = 112;
    uint256 internal constant Metis = 151;
}

library Block {
    uint256 internal constant Latest = 0;
}

struct CauldronInfo {
    address cauldron;
    bool deprecated;
    uint8 version;
    string name;
    uint256 creationBlock;
}

contract Constants {
    mapping(string => address) private addressMap;
    mapping(string => bytes32) private pairCodeHash;

    // Cauldron Information
    mapping(string => CauldronInfo[]) private cauldronsPerChain;
    mapping(string => mapping(string => mapping(uint8 => address))) public cauldronAddressMap;
    mapping(string => mapping(address => bool)) private cauldronsPerChainExists;
    mapping(string => uint256) private totalCauldronsPerChain;
    mapping(string => uint256) private deprecatedCauldronsPerChain;
    mapping(uint256 => string) private chainIdToName;

    string[] private addressKeys;

    Vm private immutable vm;

    constructor(Vm _vm) {
        vm = _vm;

        setAddress("safe.devOps", 0x48c18844530c96AaCf24568fa7F912846aAc12B9);
        setAddress("create3Factory", 0x6d7255d2a37FC668e9274129C27B5c9D3f5a86FE);

        // Mainnet
        setAddress("mainnet.ethereumWithdrawer", 0xB2c3A9c577068479B1E5119f6B7da98d25Ba48f4);
        setAddress("mainnet.cauldronV3", 0x3E2a2BC69E5C22A8DA4056B413621D1820Eb493E);
        setAddress("mainnet.cauldronV3_2", 0xE19B0D53B6416D139B2A447C3aE7fb9fe161A12c);
        setAddress("mainnet.cauldronV4", 0xC4113Ae18E0d3213c6a06947a2fFC70AD3517c77);
        setAddress("mainnet.privilegedCauldronV4", 0xb2EBF227188E44ac268565C73e0fCd82D4Bfb1E3);
        setAddress("mainnet.cauldronV3Whitelisted", 0xe0d2007F6F2A71B90143D6667257d95643183F2b);
        setAddress("mainnet.sushiBentoBox", 0xF5BCE5077908a1b7370B9ae04AdC565EBd643966);
        setAddress("mainnet.degenBox", 0xd96f48665a1410C0cd669A88898ecA36B9Fc2cce);
        setAddress("mainnet.safe.main", 0x5f0DeE98360d8200b20812e174d139A1a633EDd2);
        setAddress("mainnet.safe.ops", 0xDF2C270f610Dc35d8fFDA5B453E74db5471E126B);
        setAddress("mainnet.safe.devOps.gelatoProxy", 0x4D0c7842cD6a04f8EDB39883Db7817160DA159C3);
        setAddress("mainnet.spellTreasury", 0x5A7C5505f3CFB9a0D9A8493EC41bf27EE48c406D);
        setAddress("mainnet.wbtc", 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
        setAddress("mainnet.weth", 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        setAddress("mainnet.mim", 0x99D8a9C45b2ecA8864373A26D1459e3Dff1e17F3);
        setAddress("mainnet.spell", 0x090185f2135308BaD17527004364eBcC2D37e5F6);
        setAddress("mainnet.sSpell", 0x26FA3fFFB6EfE8c1E69103aCb4044C26B9A106a9);
        setAddress("mainnet.usdc", 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        setAddress("mainnet.usdt", 0xdAC17F958D2ee523a2206206994597C13D831ec7);
        setAddress("mainnet.ftt", 0x50D1c9771902476076eCFc8B2A83Ad6b9355a4c9);
        setAddress("mainnet.yvsteth", 0xdCD90C7f6324cfa40d7169ef80b12031770B4325);
        setAddress("mainnet.y3Crypto", 0x8078198Fc424986ae89Ce4a910Fc109587b6aBF3);
        setAddress("mainnet.crv", 0xD533a949740bb3306d119CC777fa900bA034cd52);
        setAddress("mainnet.stargate.stg", 0xAf5191B0De278C7286d6C7CC6ab6BB8A73bA2Cd6);
        setAddress("mainnet.stargate.router", 0x8731d54E9D02c286767d56ac03e8037C07e01e98);
        setAddress("mainnet.stargate.usdcPool", 0xdf0770dF86a8034b3EFEf0A1Bb3c889B8332FF56);
        setAddress("mainnet.stargate.usdtPool", 0x38EA452219524Bb87e18dE1C24D3bB59510BD783);
        setAddress("mainnet.stargate.endpoint", 0x66A71Dcef29A0fFBDBE3c6a460a3B5BC225Cd675);
        setAddress("mainnet.chainlink.mim", 0x7A364e8770418566e3eb2001A96116E6138Eb32F);
        setAddress("mainnet.chainlink.btc", 0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c);
        setAddress("mainnet.chainlink.lusd", 0x3D7aE7E594f2f2091Ad8798313450130d0Aba3a0);
        setAddress("mainnet.chainlink.crv", 0xCd627aA160A6fA45Eb793D19Ef54f5062F20f33f);
        setAddress("mainnet.chainlink.ape", 0xD10aBbC76679a20055E167BB80A24ac851b37056);
        setAddress("mainnet.liquity.lusd", 0x5f98805A4E8be255a32880FDeC7F6728C6568bA0);
        setAddress("mainnet.liquity.lqty", 0x6DEA81C8171D0bA574754EF6F8b412F2Ed88c54D);
        setAddress("mainnet.liquity.stabilityPool", 0x66017D22b0f8556afDd19FC67041899Eb65a21bb);
        setAddress("mainnet.curve.mim3Crv", 0x5a6A4D54456819380173272A5E8E9B9904BdF41B);
        setAddress("mainnet.aggregators.zeroXExchangeProxy", 0xDef1C0ded9bec7F1a1670819833240f027b25EfF);
        setAddress("mainnet.cauldronOwner", 0x8f788F226d36298dEb09A320956E3E3318Cba812);
        setAddress("mainnet.oracle.yvCrvStETHOracleV2", 0xaEeF657A06e6D9255b2895c9cEf556Da5359D50a);
        setAddress("mainnet.anyswapV4Router", 0x6b7a87899490EcE95443e979cA9485CBE7E71522);
        setAddress("mainnet.cauldronFeeWithdrawer", 0x9cC903e42d3B14981C2109905556207C6527D482);
        setAddress("mainnet.mSpellSender", 0x9caB9fDB70F4B024b5916d428fC2b83186359439);
        setAddress("mainnet.tricryptoupdator", 0xBdaF491A8C45981ccDfe46455f9D62b5c9b1632f);
        setAddress("mainnet.repayhelper", 0x0D07E5d0c6657a59153359D6552c4664B6634f21);
        setAddress("mainnet.ape", 0x4d224452801ACEd8B2F0aebE155379bb5D594381);
        setAddress("mainnet.ape.staking", 0x5954aB967Bc958940b7EB73ee84797Dc8a2AFbb9);
        setAddress("mainnet.magicApe", 0xf35b31B941D94B249EaDED041DB1b05b7097fEb6);

        // v2
        addCauldron("mainnet", "ALCX", 0x7b7473a76D6ae86CE19f7352A1E89F6C9dc39020, 2, false, 13127188);
        addCauldron("mainnet", "AGLD", 0xc1879bf24917ebE531FbAA20b0D05Da027B592ce, 2, false, 13318362);
        addCauldron("mainnet", "FTT", 0x9617b633EF905860D919b88E1d9d9a6191795341, 2, false, 13491944);
        addCauldron("mainnet", "SHIB", 0x252dCf1B621Cc53bc22C256255d2bE5C8c32EaE4, 2, false, 13452048);
        addCauldron("mainnet", "SPELL", 0xCfc571f3203756319c231d3Bc643Cee807E74636, 2, false, 13492855);
        addCauldron("mainnet", "WBTC", 0x5ec47EE69BEde0b6C2A2fC0D9d094dF16C192498, 2, false, 13941597);
        addCauldron("mainnet", "WETH", 0x390Db10e65b5ab920C19149C919D970ad9d18A41, 2, false, 13852120);
        addCauldron("mainnet", "cvx3pool", 0x257101F20cB7243E2c7129773eD5dBBcef8B34E0, 2, false, 13518049);
        addCauldron("mainnet", "cvxtricrypto2", 0x4EAeD76C3A388f4a841E9c765560BBe7B3E4B3A0, 2, false, 13297740);
        addCauldron("mainnet", "sSPELL", 0x3410297D89dCDAf4072B805EFc1ef701Bb3dd9BF, 2, false, 13492815);
        addCauldron("mainnet", "xSUSHI", 0x98a84EfF6e008c5ed0289655CcdCa899bcb6B99F, 2, false, 13082618);
        addCauldron("mainnet", "yvCVXETH", 0xf179fe36a36B32a4644587B8cdee7A23af98ed37, 2, false, 14262369);
        addCauldron("mainnet", "yvWETH-v2", 0x920D9BD936Da4eAFb5E25c6bDC9f6CB528953F9f, 2, false, 12776693);
        addCauldron("mainnet", "yvcrvIB", 0xEBfDe87310dc22404d918058FAa4D56DC4E93f0A, 2, false, 12903352);

        // v3
        addCauldron("mainnet", "yvSTETH2", 0x53375adD9D2dFE19398eD65BAaEFfe622760A9A6, 3, false, 14771464);
        addCauldron("mainnet", "yvDAI", 0x7Ce7D9ED62B9A6c5aCe1c6Ec9aeb115FA3064757, 3, false, 14580479);
        addCauldron("mainnet", "Stargate-USDC", 0xd31E19A0574dBF09310c3B06f3416661B4Dc7324, 3, false, 14744272);
        addCauldron("mainnet", "Stargate-USDT", 0xc6B2b3fE7c3D7a6f823D9106E22e66660709001e, 3, false, 14744293);
        addCauldron("mainnet", "LUSD", 0x8227965A7f42956549aFaEc319F4E444aa438Df5, 3, false, 15448458);

        // v4
        addCauldron("mainnet", "magciAPE", 0x692887E8877C6Dd31593cda44c382DB5b289B684, 4, false, 16656455);

        // privileged v4
        addCauldron("mainnet", "WBTC", 0x85f60D3ea4E86Af43c9D4E9CC9095281fC25c405, 4, false, 16180626);
        addCauldron("mainnet", "yvSTETH3", 0x406b89138782851d3a8C04C743b010CEb0374352, 4, false, 16180626);
        addCauldron("mainnet", "CRV", 0x207763511da879a900973A5E092382117C3c1588, 4, false, 16154962);
        addCauldron("mainnet", "yv-3Crypto", 0x7259e152103756e1616A77Ae982353c3751A6a90, 4, false, 16520538);

        // Deprecated v1
        addCauldron("mainnet", "yvUSDC-v2", 0x6cbAFEE1FaB76cA5B5e144c43B3B50d42b7C8c8f, 1, true, 12558945);
        addCauldron("mainnet", "yvUSDT-v2", 0x551a7CfF4de931F32893c928bBc3D25bF1Fc5147, 1, true, 12558932);
        addCauldron("mainnet", "yvWETH", 0x6Ff9061bB8f97d948942cEF376d98b51fA38B91f, 1, true, 12558932);
        addCauldron("mainnet", "xSUSHI", 0xbb02A884621FB8F5BFd263A67F58B65df5b090f3, 1, true, 12558960);
        addCauldron("mainnet", "yvYFI", 0xFFbF4892822e0d552CFF317F65e1eE7b5D3d9aE6, 1, true, 12558943);

        // Deprecated v2
        addCauldron("mainnet", "sSPELL", 0xC319EEa1e792577C319723b5e60a15dA3857E7da, 2, true, 13239675);
        addCauldron("mainnet", "cvx3pool-v1", 0x806e16ec797c69afa8590A55723CE4CC1b54050E, 2, true, 13148516);
        addCauldron("mainnet", "cvx3pool-v2", 0x6371EfE5CD6e3d2d7C477935b7669401143b7985, 2, true, 13505014);
        addCauldron("mainnet", "wsOHM", 0x003d5A75d284824Af736df51933be522DE9Eed0f, 2, true, 13071089);
        addCauldron("mainnet", "FTM", 0x05500e2Ee779329698DF35760bEdcAAC046e7C27, 2, true, 13127890);
        addCauldron("mainnet", "yvcrvstETH", 0x0BCa8ebcB26502b013493Bf8fE53aA2B1ED401C1, 2, true, 13097463);
        addCauldron("mainnet", "cvxrenCrv", 0x35a0Dd182E4bCa59d5931eae13D0A2332fA30321, 2, true, 13393468);

        // Optimism
        setAddress("optimism.degenBox", 0xa93C81f564579381116ee3E007C9fCFd2EBa1723);
        setAddress("optimism.cauldronV3_2", 0xB6957806b7fD389323628674BCdFCD61b9cc5e02);
        setAddress("optimism.op", 0x4200000000000000000000000000000000000042);
        setAddress("optimism.safe.main", 0x4217AA01360846A849d2A89809d450D10248B513);
        setAddress("optimism.safe.ops", 0xCbb86ffF0F8094C370cdDb76C7F270C832a8C7C0);
        setAddress("optimism.safe.devOps.gelatoProxy", 0x4D0c7842cD6a04f8EDB39883Db7817160DA159C3);
        setAddress("optimism.weth", 0x4200000000000000000000000000000000000006);
        setAddress("optimism.mim", 0xB153FB3d196A8eB25522705560ac152eeEc57901);
        setAddress("optimism.usdc", 0x7F5c764cBc14f9669B88837ca1490cCa17c31607);
        setAddress("optimism.dai", 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1);
        setAddress("optimism.chainlink.op", 0x0D276FC14719f9292D5C1eA2198673d1f4269246);
        setAddress("optimism.chainlink.usdc", 0x16a9FA2FDa030272Ce99B29CF780dFA30361E0f3);
        setAddress("optimism.velodrome.velo", 0x3c8B650257cFb5f272f799F5e2b4e65093a11a05);
        setAddress("optimism.velodrome.router", 0xa132DAB612dB5cB9fC9Ac426A0Cc215A3423F9c9);
        setAddress("optimism.velodrome.vOpUsdc", 0x47029bc8f5CBe3b464004E87eF9c9419a48018cd);
        setAddress("optimism.velodrome.factory", 0x25CbdDb98b35ab1FF77413456B31EC81A6B6B746);
        setAddress("optimism.velodrome.vOpUsdcGauge", 0x0299d40E99F2a5a1390261f5A71d13C3932E214C);
        setAddress("optimism.aggregators.zeroXExchangeProxy", 0xDEF1ABE32c034e558Cdd535791643C58a13aCC10);
        setAddress("optimism.aggregators.1inch", 0x1111111254EEB25477B68fb85Ed929f73A960582);
        setAddress("optimism.bridges.anyswapRouter", 0xDC42728B0eA910349ed3c6e1c9Dc06b5FB591f98);
        setAddress("optimism.stargate.stg", 0x296F55F8Fb28E498B858d0BcDA06D955B2Cb3f97);
        setAddress("optimism.stargate.router", 0xB0D502E938ed5f4df2E681fE6E419ff29631d62b);
        setAddress("optimism.stargate.usdcPool", 0xDecC0c09c3B5f6e92EF4184125D5648a66E35298);
        setAddress("optimism.stargate.staking", 0x4DeA9e918c6289a52cd469cAC652727B7b412Cd2);
        setAddress("optimism.abraWrappedVOpUsdc", 0x6Eb1709e0b562097BF1cc48Bc6A378446c297c04);

        addCauldron("optimism", "Velodrome vOP/USDC", 0x68f498C230015254AFF0E1EB6F85Da558dFf2362, 3, false, 18919918);

        // Fantom
        setAddress("fantom.LZendpoint", 0xb6319cC6c8c27A8F5dAF0dD3DF91EA35C4720dd7);
        setAddress("fantom.degenBox", 0x74A0BcA2eeEdf8883cb91E37e9ff49430f20a616);
        setAddress("fantom.spell", 0x468003B688943977e6130F4F68F23aad939a1040);
        setAddress("fantom.sushiBentoBox", 0x74c764D41B77DBbb4fe771daB1939B00b146894A);
        setAddress("fantom.mspell", 0xa668762fb20bcd7148Db1bdb402ec06Eb6DAD569);
        setAddress("fantom.mim", 0x82f0B8B456c1A451378467398982d4834b6829c1);
        setAddress("fantom.wftm", 0x21be370D5312f44cB42ce377BC9b8a0cEF1A4C83);
        setAddress("fantom.safe.ops", 0xf68b78CB64C49967719214aa029a29712ddd567f);
        setAddress("fantom.safe.devOps.gelatoProxy", 0x4D0c7842cD6a04f8EDB39883Db7817160DA159C3);
        setAddress("fantom.anyswapRouterV4", 0x1CcCA1cE62c62F7Be95d4A67722a8fDbed6EEcb4);
        setAddress("fantom.spookyswap.wFtmMim", 0x6f86e65b255c9111109d2D2325ca2dFc82456efc);
        setAddress("fantom.spookyswap.factory", 0x152eE697f2E276fA89E96742e9bB9aB1F2E61bE3);
        setAddress("fantom.spookyswap.router", 0xF491e7B69E4244ad4002BC14e878a34207E38c29);
        setAddress("fantom.spookyswap.boo", 0x841FAD6EAe12c286d1Fd18d1d525DFfA75C7EFFE);
        setAddress("fantom.spookyswap.farmV2", 0x18b4f774fdC7BF685daeeF66c2990b1dDd9ea6aD);
        setAddress("fantom.safe.main", 0xb4ad8B57Bd6963912c80FCbb6Baea99988543c1c);
        setAddress("fantom.mspellReporter", 0x15f57fbCB7A443aC6022e051a46cAE19491bC298);

        // v2
        addCauldron("fantom", "FTM", 0x8E45Af6743422e488aFAcDad842cE75A09eaEd34, 2, false, 11536771);
        addCauldron("fantom", "FTM", 0xd4357d43545F793101b592bACaB89943DC89d11b, 2, false, 11536803);
        addCauldron("fantom", "yvWFTM", 0xed745b045f9495B8bfC7b58eeA8E0d0597884e12, 2, false, 1749482);
        addCauldron("fantom", "xBOO", 0xa3Fc1B4b7f06c2391f7AD7D4795C1cD28A59917e, 2, false, 3124064);
        addCauldron("fantom", "FTM/MIM-Spirit", 0x7208d9F9398D7b02C5C22c334c2a7A3A98c0A45d, 2, false, 31494241);
        addCauldron("fantom", "FTM/MIM-Spooky", 0x4fdfFa59bf8dda3F4d5b38F260EAb8BFaC6d7bC1, 2, false, 3149787);

        // Deprecated v2
        addCauldron("fantom", "ICE", 0xF08e4cc9015a1B8F49A8EEc7c7C64C14B9abD7C7, 2, true, 2710581);
        addCauldron("fantom", "FTM", 0xEf7A0bd972672b4eb5DF28f2F544f6b0BF03298a, 2, true, 28502448);

        // Avalanche
        setAddress("avalanche.LZendpoint", 0x3c2269811836af69497E5F486A85D7316753cf62);
        setAddress("avalanche.wavax", 0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7);
        setAddress("avalanche.mspell", 0xBd84472B31d947314fDFa2ea42460A2727F955Af);
        setAddress("avalanche.spell", 0xCE1bFFBD5374Dac86a2893119683F4911a2F7814);
        setAddress("avalanche.mim", 0x130966628846BFd36ff31a822705796e8cb8C18D);
        setAddress("avalanche.degenBox1", 0xf4F46382C2bE1603Dc817551Ff9A7b333Ed1D18f);
        setAddress("avalanche.degenBox2", 0x1fC83f75499b7620d53757f0b01E2ae626aAE530);
        setAddress("avalanche.degenBox", 0x1fC83f75499b7620d53757f0b01E2ae626aAE530);
        setAddress("avalanche.cauldronV4", 0x17b205F9b670a60F3629aF34Bc365a74b56F5341);
        setAddress("avalanche.cauldronOwner", 0x793a15cAF24fb54657FB54b593007A4bD454442D);
        setAddress("avalanche.anyswapRouterV4", 0xB0731d50C681C45856BFc3f7539D5f61d4bE81D8);
        setAddress("avalanche.safe.ops", 0xAE4D3a42E46399827bd094B4426e2f79Cca543CA);
        setAddress("avalanche.safe.devOps.gelatoProxy", 0x90ED9a40dc938F1A672Bd158394366c2029d6ca7);
        setAddress("avalanche.mspellReporter", 0x14D358136D2510dF260ef630E4f7eA2AaF81A2dD);
        setAddress("avalanche.magicGlp", 0x5EFC10C353FA30C5758037fdF0A233e971ECc2e0);
        setAddress("avalanche.gmx.gmx", 0x62edc0692BD897D2295872a9FFCac5425011c661);
        setAddress("avalanche.gmx.glp", 0x01234181085565ed162a948b6a5e88758CD7c7b8);
        setAddress("avalanche.gmx.esGmx", 0xFf1489227BbAAC61a9209A08929E4c2a526DdD17);
        setAddress("avalanche.gmx.sGLP", 0xaE64d55a6f09E4263421737397D1fdFA71896a69);
        setAddress("avalanche.gmx.fGLP", 0xd2D1162512F927a7e282Ef43a362659E4F2a728F);
        setAddress("avalanche.gmx.fsGLP", 0x9e295B5B976a184B14aD8cd72413aD846C299660);
        setAddress("avalanche.gmx.vault", 0x9ab2De34A33fB459b538c43f251eB825645e8595);
        setAddress("avalanche.gmx.glpManager", 0xD152c7F25db7F4B95b7658323c5F33d176818EE4);
        setAddress("avalanche.gmx.rewardRouterV2", 0x82147C5A7E850eA4E28155DF107F2590fD4ba327);
        setAddress("avalanche.gmx.glpRewardRouter", 0xB70B91CE0771d3f4c81D87660f71Da31d48eB3B3);
        setAddress("avalanche.gmx.fGlpWethRewardDistributor", 0xfc5A1A6EB076a2C7aD06eD22C90d7E710E35ad0a);
        setAddress("avalanche.aggregators.zeroXExchangeProxy", 0xDef1C0ded9bec7F1a1670819833240f027b25EfF);

        // v2
        addCauldron("avalanche", "AVAX", 0x3CFEd0439aB822530b1fFBd19536d897EF30D2a2, 2, false, 3709091);
        addCauldron("avalanche", "AVAX/MIM SLP", 0xAcc6821d0F368b02d223158F8aDA4824dA9f28E3, 2, false, 9512704);

        // Deprecated v2
        addCauldron("avalanche", "wMEMO-v1", 0x56984F04d2d04B2F63403f0EbeDD3487716bA49d, 2, true, 5046414);
        addCauldron("avalanche", "wMEMO-v2", 0x35fA7A723B3B39f15623Ff1Eb26D8701E7D6bB21, 2, true, 6888366);
        addCauldron("avalanche", "xJOE", 0x3b63f81Ad1fc724E44330b4cf5b5B6e355AD964B, 2, true, 6414426);
        addCauldron("avalanche", "AVAX/USDC.e-jLP", 0x95cCe62C3eCD9A33090bBf8a9eAC50b699B54210, 2, true, 6415427);
        addCauldron("avalanche", "AVAX/USDT.e-jLP", 0x0a1e6a80E93e62Bd0D3D3BFcF4c362C40FB1cF3D, 2, true, 6877723);
        addCauldron("avalanche", "AVAX/MIM-jLP", 0x2450Bf8e625e98e14884355205af6F97E3E68d07, 2, true, 6877772);

        // Arbitrum
        setAddress("arbitrum.LZendpoint", 0x3c2269811836af69497E5F486A85D7316753cf62);
        setAddress("arbitrum.mspell", 0x1DF188958A8674B5177f77667b8D173c3CdD9e51);
        setAddress("arbitrum.spell", 0x3E6648C5a70A150A88bCE65F4aD4d506Fe15d2AF);
        setAddress("arbitrum.mim", 0xFEa7a6a0B346362BF88A9e4A88416B77a57D6c2A);
        setAddress("arbitrum.anyswapRouterV4", 0xC931f61B1534EB21D8c11B24f3f5Ab2471d4aB50);
        setAddress("arbitrum.sushiBentoBox", 0x74c764D41B77DBbb4fe771daB1939B00b146894A);
        setAddress("arbitrum.cauldronV4", 0xeE22BA16e912694e925020F8F22EA2277214EB16);
        setAddress("arbitrum.cauldronOwner", 0xaF2fBB9CB80EdFb7d3f2d170a65AE3bFa42d0B86);
        setAddress("arbitrum.degenBox", 0x7C8FeF8eA9b1fE46A7689bfb8149341C90431D38);
        setAddress("arbitrum.degenBoxOwner", 0x0D2a5107435cbbBE21Db1ADB5F1E078E63e59449);
        setAddress("arbitrum.weth", 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1);
        setAddress("arbitrum.usdc", 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8);
        setAddress("arbitrum.usdt", 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9);
        setAddress("arbitrum.abracadabraWrappedStakedGlp", 0x3477Df28ce70Cecf61fFfa7a95be4BEC3B3c7e75);
        setAddress("arbitrum.magicGlp", 0x85667409a723684Fe1e57Dd1ABDe8D88C2f54214);
        setAddress("arbitrum.gmx.gmx", 0xfc5A1A6EB076a2C7aD06eD22C90d7E710E35ad0a);
        setAddress("arbitrum.gmx.esGmx", 0xf42Ae1D54fd613C9bb14810b0588FaAa09a426cA);
        setAddress("arbitrum.gmx.stakedGmx", 0xd2D1162512F927a7e282Ef43a362659E4F2a728F);
        setAddress("arbitrum.gmx.glp", 0x4277f8F2c384827B5273592FF7CeBd9f2C1ac258);
        setAddress("arbitrum.gmx.sGLP", 0x5402B5F40310bDED796c7D0F3FF6683f5C0cFfdf);
        setAddress("arbitrum.gmx.fGLP", 0x4e971a87900b931fF39d1Aad67697F49835400b6); // weth reward tracker
        setAddress("arbitrum.gmx.fsGLP", 0x1aDDD80E6039594eE970E5872D247bf0414C8903); // esGmx reward tracker
        setAddress("arbitrum.gmx.vault", 0x489ee077994B6658eAfA855C308275EAd8097C4A);
        setAddress("arbitrum.gmx.fGlpWethRewardDistributor", 0x5C04a12EB54A093c396f61355c6dA0B15890150d);
        setAddress("arbitrum.gmx.esGmxRewardDistributor", 0x60519b48ec4183a61ca2B8e37869E675FD203b34);
        setAddress("arbitrum.gmx.glpManager", 0x3963FfC9dff443c2A94f21b129D429891E32ec18);
        setAddress("arbitrum.gmx.rewardRouterV2", 0xA906F338CB21815cBc4Bc87ace9e68c87eF8d8F1);
        setAddress("arbitrum.gmx.glpRewardRouter", 0xB95DB5B167D75e6d04227CfFFA61069348d271F5);
        setAddress("arbitrum.safe.main", 0xf46BB6dDA9709C49EfB918201D97F6474EAc5Aea);
        setAddress("arbitrum.safe.ops", 0xA71A021EF66B03E45E0d85590432DFCfa1b7174C);
        setAddress("arbitrum.safe.devOps.gelatoProxy", 0x4D0c7842cD6a04f8EDB39883Db7817160DA159C3);
        setAddress("arbitrum.aggregators.zeroXExchangeProxy", 0xDef1C0ded9bec7F1a1670819833240f027b25EfF);
        setAddress("arbitrum.mimCauldronDistributor", 0xC4E343b89fB261f42432D9078Dde9798e67c33BA);
        setAddress("arbitrum.mspellReporter", 0x5f468E4C8d46004641F44DbD4de3EE734e90882d);

        // v2
        addCauldron("arbitrum", "WETH", 0xC89958B03A55B5de2221aCB25B58B89A000215E6, 2, false, 845270);

        // v4
        addCauldron("arbitrum", "abracadabraWrappedStakedGlp", 0x5698135CA439f21a57bDdbe8b582C62f090406D5, 4, false, 42827353);
        addCauldron("arbitrum", "magicGLP", 0x726413d7402fF180609d0EBc79506df8633701B1, 4, false, 55708731);

        // v4WithRewarder
        addCauldron("arbitrum", "abracadabraWrappedStakedGlpWithRewarder", 0x6c1E051b83Eab3c10395955F7c5421a69a2520cE, 4, false, 55511538);

        // BSC
        setAddress("bsc.mim", 0xfE19F0B51438fd612f6FD59C1dbB3eA319f433Ba);
        setAddress("bsc.wbnb", 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
        setAddress("bsc.usdt", 0x55d398326f99059fF775485246999027B3197955);
        setAddress("bsc.busd", 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);
        setAddress("bsc.btc", 0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c);
        setAddress("bsc.eth", 0x2170Ed0880ac9A755fd29B2688956BD959F933F8);
        setAddress("bsc.cake", 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82);
        setAddress("bsc.degenBox", 0x090185f2135308BaD17527004364eBcC2D37e5F6);
        setAddress("bsc.safe.main", 0x9d9bC38bF4A128530EA45A7d27D0Ccb9C2EbFaf6);
        setAddress("bsc.safe.ops", 0x5a1DE6c40EF68A3F00ADe998E9e0D687E4419450);
        setAddress("bsc.safe.devOps.gelatoProxy", 0x4D0c7842cD6a04f8EDB39883Db7817160DA159C3);
        setAddress("bsc.lvlfinance.liquidityPool", 0xA5aBFB56a78D2BD4689b25B8A77fd49Bb0675874);
        setAddress("bsc.lvlfinance.levelMasterV2", 0x5aE081b6647aEF897dEc738642089D4BDa93C0e7);
        setAddress("bsc.lvlfinance.seniorLLP", 0xB5C42F84Ab3f786bCA9761240546AA9cEC1f8821); // staking pid: 0
        setAddress("bsc.lvlfinance.mezzanineLLP", 0x4265af66537F7BE1Ca60Ca6070D97531EC571BDd); // staking pid: 1
        setAddress("bsc.lvlfinance.juniorLLP", 0xcC5368f152453D497061CB1fB578D2d3C54bD0A0); // staking pid: 2
        setAddress("bsc.lvlfinance.lvlToken", 0xB64E280e9D1B5DbEc4AcceDb2257A87b400DB149);
        setAddress("bsc.lvlfinance.oracle", 0x04Db83667F5d59FF61fA6BbBD894824B233b3693);
        setAddress("bsc.aggregators.zeroXExchangeProxy", 0xDef1C0ded9bec7F1a1670819833240f027b25EfF);

        addCauldron("bsc", "BNB", 0x692CF15F80415D83E8c0e139cAbcDA67fcc12C90, 2, false, 12763666);
        addCauldron("bsc", "CAKE", 0xF8049467F3A9D50176f4816b20cDdd9bB8a93319, 2, false, 12765698);

        pairCodeHash["optimism.velodrome"] = 0xc1ac28b1c4ebe53c0cff67bab5878c4eb68759bb1e9f73977cd266b247d149f0;
        pairCodeHash["avalanche.traderjoe"] = 0x0bbca9af0511ad1a1da383135cf3a8d2ac620e549ef9f6ae3a4c33c2fed0af91;
        pairCodeHash["fantom.spiritswap"] = 0xe242e798f6cee26a9cb0bbf24653bf066e5356ffeac160907fe2cc108e238617;
        pairCodeHash["fantom.spookyswap"] = 0xcdf2deca40a0bd56de8e3ce5c7df6727e5b1bf2ac96f283fa9c4b3e6b42ea9d2;

        chainIdToName[ChainId.Mainnet] = "mainnet";
        chainIdToName[ChainId.BSC] = "bsc";
        chainIdToName[ChainId.Polygon] = "polygon";
        chainIdToName[ChainId.Fantom] = "fantom";
        chainIdToName[ChainId.Optimism] = "optimism";
        chainIdToName[ChainId.Arbitrum] = "arbitrum";
        chainIdToName[ChainId.Avalanche] = "avalanche";
    }

    function setAddress(string memory key, address value) public {
        require(addressMap[key] == address(0), string.concat("address already exists: ", key));
        addressMap[key] = value;
        addressKeys.push(key);
        vm.label(value, key);
    }

    function addCauldron(
        string memory chain,
        string memory name,
        address value,
        uint8 version,
        bool deprecated,
        uint256 creationBlock
    ) public {
        require(!cauldronsPerChainExists[chain][value], string.concat("cauldron already added: ", vm.toString(value)));
        cauldronsPerChainExists[chain][value] = true;
        cauldronAddressMap[chain][name][version] = value;
        cauldronsPerChain[chain].push(
            CauldronInfo({deprecated: deprecated, cauldron: value, version: version, name: name, creationBlock: creationBlock})
        );

        totalCauldronsPerChain[chain]++;

        if (deprecated) {
            deprecatedCauldronsPerChain[chain]++;
            vm.label(value, string.concat(chain, ".cauldron.deprecated.", name));
        } else {
            vm.label(value, string.concat(chain, ".cauldron.", name));
        }
    }

    function getCauldrons(string calldata chain, bool includeDeprecated) public view returns (CauldronInfo[] memory filteredCauldronInfos) {
        uint256 len = totalCauldronsPerChain[chain];
        if (!includeDeprecated) {
            len -= deprecatedCauldronsPerChain[chain];
        }

        CauldronInfo[] memory cauldronInfos = cauldronsPerChain[chain];
        filteredCauldronInfos = new CauldronInfo[](len);

        uint256 index = 0;
        for (uint256 i = 0; i < cauldronInfos.length; i++) {
            CauldronInfo memory info = cauldronInfos[i];

            if (info.deprecated && !includeDeprecated) {
                continue;
            }

            filteredCauldronInfos[index] = info;
            index++;
        }
    }

    function getCauldrons(
        string calldata chain,
        bool includeDeprecated,
        // (address cauldron, bool deprecated, uint8 version, string memory name, uint256 creationBlock)
        function(address, bool, uint8, string memory, uint256) external view returns (bool) predicate
    ) public view returns (CauldronInfo[] memory filteredCauldronInfos) {
        CauldronInfo[] memory cauldronInfos = getCauldrons(chain, includeDeprecated);

        uint256 len = 0;

        // remove based on the predicate
        for (uint256 i = 0; i < cauldronInfos.length; i++) {
            CauldronInfo memory info = cauldronInfos[i];

            if (!predicate(info.cauldron, info.deprecated, info.version, info.name, info.creationBlock)) {
                cauldronInfos[i].cauldron = address(0);
                continue;
            }

            len++;
        }

        filteredCauldronInfos = new CauldronInfo[](len);
        uint256 filteredCauldronInfosIndex = 0;
        for (uint256 i = 0; i < cauldronInfos.length; i++) {
            if (cauldronInfos[i].cauldron != address(0)) {
                filteredCauldronInfos[filteredCauldronInfosIndex] = cauldronInfos[i];
                filteredCauldronInfosIndex++;
            }
        }
    }

    function getAddress(string memory key) public view returns (address) {
        require(addressMap[key] != address(0), string.concat("address not found: ", key));
        return addressMap[key];
    }

    function getAddress(uint256 chainid, string calldata name) public view returns (address) {
        string memory key = string.concat(chainIdToName[chainid], ".", name);
        return getAddress(key);
    }

    function getPairCodeHash(string calldata key) public view returns (bytes32) {
        require(pairCodeHash[key] != "", string.concat("pairCodeHash not found: ", key));
        return pairCodeHash[key];
    }
}
