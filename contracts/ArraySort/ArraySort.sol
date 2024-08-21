// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IArraySort} from "./IArraySort.sol";
import {ISolution} from "../ISolution.sol";

contract ArraySort is IArraySort, ISolution {
    function solve(uint256[] memory a) external pure returns (uint256[] memory) {
        return a;
    }
    function getProblemName() external view returns (string memory){
        return "ArraySort";
    }

    function getProblemID() external view returns (string memory){
        return "2";
    }
}
