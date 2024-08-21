// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IHammingDistance } from "./IHammingDistance.sol";
import { ISolution } from "../ISolution.sol";


contract HammingDistance is IHammingDistance, ISolution {
    function solve(uint[] calldata a) external returns (uint) {
        return 0;
    }

    function getProblemName() external view returns (string memory){
        return "HammingDistance";
    }

    function getProblemID() external view returns (string memory){
        return "12";
    }
}
