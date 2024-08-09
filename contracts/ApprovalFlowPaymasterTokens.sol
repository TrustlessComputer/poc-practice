// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IPaymaster, ExecutionResult, PAYMASTER_VALIDATION_SUCCESS_MAGIC} from "@matterlabs/zksync-contracts/l2/system-contracts/interfaces/IPaymaster.sol";
import {IPaymasterFlow} from "@matterlabs/zksync-contracts/l2/system-contracts/interfaces/IPaymasterFlow.sol";
import {TransactionHelper, Transaction} from "@matterlabs/zksync-contracts/l2/system-contracts/libraries/TransactionHelper.sol";

import "@matterlabs/zksync-contracts/l2/system-contracts/Constants.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

struct Token {
    uint128 gasPrice; // amount of tokens per gas
    bool isAllowed;
}

/// @notice This smart contract pays the gas fees for accounts with balance of a specific ERC20 token. It makes use of the approval-based flow paymaster.
contract ApprovalFlowPaymasterTokens is IPaymaster, Ownable {
    using SafeERC20 for IERC20;

    // gas price per token unit
    mapping(address => Token) private allowedTokens;

    modifier onlyBootloader() {
        require(
            msg.sender == BOOTLOADER_FORMAL_ADDRESS,
            "Only bootloader can call this method"
        );
        _;
    }

    constructor(address[] memory tokens, uint128[] memory gasPrices) {
        require(gasPrices.length == tokens.length, "l");

        for (uint i = 0; i < tokens.length; i++) {
            _addToken(tokens[i], gasPrices[i]);
        }
    }

    function validateAndPayForPaymasterTransaction(
        bytes32,
        bytes32,
        Transaction calldata _transaction
    )
        external
        payable
        onlyBootloader
        returns (bytes4 magic, bytes memory context)
    {
        // Default to transaction acceptance
        magic = PAYMASTER_VALIDATION_SUCCESS_MAGIC;
        require(
            _transaction.paymasterInput.length >= 4,
            "The standard paymaster input must be at least 4 bytes long"
        );

        bytes4 paymasterInputSelector = bytes4(
            _transaction.paymasterInput[0:4]
        );
        // Check if it's approval-based flow
        if (paymasterInputSelector == IPaymasterFlow.approvalBased.selector) {
            (address token, uint256 amount, bytes memory data) = abi.decode(
                _transaction.paymasterInput[4:],
                (address, uint256, bytes)
            );

            // Ensure the token is the allowed one
            require(allowedTokens[token].isAllowed, "Invalid token");

            // Check user's allowance
            address userAddress = address(uint160(_transaction.from));
            address thisAddress = address(this);
            uint256 providedAllowance = IERC20(token).allowance(userAddress, thisAddress);
            uint256 feeCharged = uint256(allowedTokens[token].gasPrice) * _transaction.gasLimit;
            require(
                providedAllowance >= feeCharged && amount >= feeCharged,
                "Min allowance too low"
            );

            uint256 requiredETH = _transaction.gasLimit * _transaction.maxFeePerGas;
            IERC20(token).safeTransferFrom(userAddress, thisAddress, amount);

            (bool success, ) = payable(BOOTLOADER_FORMAL_ADDRESS).call{value: requiredETH}("");
            require(success, "Failed to transfer tx fee to bootloader.");
        } else {
            revert("Unsupported paymaster flow");
        }
    }

    function postTransaction(
        bytes calldata _context,
        Transaction calldata _transaction,
        bytes32,
        bytes32,
        ExecutionResult _txResult,
        uint256 _maxRefundedGas
    ) external payable override onlyBootloader {}

    function withdraw(address token, address _to) external onlyOwner {
        if (token == address(0)) {
            (bool success, ) = payable(_to).call{value: address(this).balance}("");
            require(success, "Failed to withdraw funds from paymaster.");
        } else {
            IERC20 tokenTemp = IERC20(token);
            tokenTemp.safeTransfer(_to, tokenTemp.balanceOf(address(this)));
        }
    }

    function _addToken(address token, uint128 gasPrice) internal {
        // check token interface
        IERC20(token).totalSupply();
        require(!allowedTokens[token].isAllowed, "ad");

        allowedTokens[token] = Token(gasPrice, true);
    }

    function addToken(address token, uint128 gasPrice) public onlyOwner {
        _addToken(token, gasPrice);
    }

    function removeToken(address token) external onlyOwner {
        require(allowedTokens[token].isAllowed, "rm");

        allowedTokens[token] = Token(0, false);
    }

    function setGasPrice(address token, uint128 gasPrice) public onlyOwner {
        require(allowedTokens[token].isAllowed, "rm");

        allowedTokens[token].gasPrice = gasPrice;
    }

    // Getters
    function gasPrice(address token) external view returns(uint128) {
        return allowedTokens[token].gasPrice;
    }

    function isTokenAllowed(address token) external view returns(bool) {
        return allowedTokens[token].isAllowed;
    }

    receive() external payable {}
}