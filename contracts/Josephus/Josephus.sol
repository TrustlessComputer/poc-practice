// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IJosephus } from "./IJosephus.sol";
import { ISolution } from "../ISolution.sol";


contract Josephus is IJosephus, ISolution {
    function solve(uint n, uint m, uint p, uint y) external returns (uint[2] memory) {
        uint[2] memory res;
        return res;
    }

    function getProblemName() external view returns (string memory){
        return "Josephus";
    }

    function getProblemID() external view returns (string memory){
        return "9";
    }
}
