// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
    
contract EstimateGasProxy {
    function estimateStaticCallGas(address _contract, bytes memory input) external view returns (uint256, bytes memory) {
        uint start = gasleft();
        (bool success, bytes memory data) = _contract.staticcall(input);
        uint end = gasleft();
        return (start - end, data);
    }
}
