// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";


contract RCCStake is 
    Initializable,
    UUPSUpgradeable,
    PausableUpgradeable  
 {
  

   

    function initialize(
        IERC20 _RCC,
        uint256 _startBlock,
        uint256 _endBlock,
        uint256 _RCCPerBlock
    ) public initializer{
        require(_startBlock <= _endBlock && _RCCPerBlock > 0, "invalid parameters");

        __AccessControl_init();
        __UUPSUpgradeabel_init();
        _grantRole(DEFAULT_ADMIN_ROLE,msg.sender);
        _grantRole(UPGRADE_ROLE,msg.sender);
         _grantRole(ADMIN_ROLE,msg.sender);

         _setRCC(_RCC);

         startBlock = _startBlock;
         endBlock = _endBlock;
         RCCPerBlock = _RCCPerBlock;
    }

       function _authorizeUpgrade(address newImplementation)
        internal
        onlyRole(UPGRADE_ROLE)
        override
    {

    }
    function setRCC(IERC20 _RCC) public onlyRole(ADMIN_ROLE){
        RCC = _RCC;

    }
    
    struct UnstakeRequest{
        //Request withdraw amount;
        uint256 amount;
        //The blocks can be released when the request withdraw amount
        uint256 unlockBlocks;
    }
    struct User {
        //Stating token amount that user provided
        uint256 stAmount;
        //Finished distributed RCCS to user
        uint256 finishedRCC;
        //Pending to claim RCCS
        uint256 pendingRCC;
        //Withdraw request list;
        UnstakeRequest[] requests;
    }
    struct Pool {
        //Address of staking token
        address stTokenAddress;
        //Weight of pool;
        uint256 poolWeight;
        //Last block number that RCCS distribution occurs for pool
        uint256 lastRewardBlock;
        //Accumulated RCCs per staking token of pool
        uint256 accRCCPerST;
        //Staking token amount;
        uint256 stTokenAmount;
        //Min staking amount;
        uint256 minDepositAmount;
        //Withdraw locked blocks
        //uint256 unstakeLockedBlocks; 
        
    }

    function addPool(
        address _stTokenAddress,
        uint256 _minDepositAmount

    )  public onlyRole(ADMIN_ROLE) returns () {
        if (pool.length > 0){
            require(_stTokenAddress != address(0),"invalid staking token address");

        } else {
             require(_stTokenAddress == address(0),"invalid staking token address");
        }

        require(block.number < endBlock, "already ended");
        uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
        pool.push(
            Pool({
                stTokenAddress : _stTokenAddress,
                lastRewardBlock : lastRewardBlock,
                accRCCPerST : 0 ,
                minDepositAmount : _minDepositAmount
            })
        )
    }

    //***************************** STATE VARIABLES **************************************/
    //First block that RccState will start from
    uint256 public startBlock;
    //Block that RccState will end from
    uint256 public endBlock;
    //RCC token reward per token;
    uint256 public RCCPerBlock;

    //Pause the withdraw function
    bool public withdrawPaused;
    //Pause the claim function
    bool public claimPaused;

    //RCCToken
    IERC20 public RCC;

    //Total pool weight/ Sum of all pool weights;
    uint256 public totalPoolWeight;

    //pool id => user address => user info
    mapping (uint256 => mapping (address => User)) public user;

    Pool[] public pool;
}