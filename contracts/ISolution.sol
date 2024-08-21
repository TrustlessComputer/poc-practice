// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ISolution {
    function getProblemID() external view returns (string memory);
    function getProblemName() external view returns (string memory);
}
