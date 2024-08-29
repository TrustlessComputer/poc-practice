// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProductKInteger} from "./IProductKInteger.sol";
import {ISolution} from "../../ISolution.sol";

contract ProductKInteger is IProductKInteger, ISolution {
    function solve(int256[] calldata a, uint256 k) external returns (uint256) {
        return 0;
    }

    function getProblemName() external view returns (string memory){
        return "ProductKInteger";
    }

    function getProblemID() external view returns (string memory){
        return "23";
    }
}
