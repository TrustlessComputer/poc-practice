// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IGridPower} from "./IGridPower.sol";
import {ISolution} from "../../ISolution.sol";

contract GridPower is IGridPower, ISolution {
    function solve(uint256 n, uint256[] calldata x, uint256[] calldata y, uint256[] calldata c) external returns (uint256) {
        return 0;
    }

    function getProblemName() external view returns (string memory){
        return "GridPower";
    }

    function getProblemID() external view returns (string memory){
        return "24";
    }
}
