// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ICourses } from "./ICourses.sol";
import { ISolution } from "../ISolution.sol";

contract Courses is ICourses, ISolution  {
    function solve(uint n, uint[] calldata a, uint[] calldata b) external returns (bool) {
        return false;
    }

    function getProblemName() external view returns (string memory){
        return "Courses";
    }

    function getProblemID() external view returns (string memory){
        return "8";
    }
}
