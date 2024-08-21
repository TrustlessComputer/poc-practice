// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IClosestSum} from "./IClosestSum.sol";
import {ISolution} from "../ISolution.sol";

contract ClosestSum is IClosestSum, ISolution {
    function solve(int256[] calldata input, int256 target) external returns (uint256) {
        return 0;
    }

    function getProblemName() external view returns (string memory){
        return "ClosestSum";
    }

    function getProblemID() external view returns (string memory){
        return "13";
    }
}
