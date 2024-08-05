// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IArraySort} from "./IArraySort.sol";

contract ArraySort is IArraySort {
    function quickSort(uint[] memory arr, int left, int right) internal pure{
        int i = left;
        int j = right;
        if(i==j) return;
        uint pivot = arr[uint(left + (right - left) / 2)];
        while (i <= j) {
            while (arr[uint(i)] < pivot) i++;
            while (pivot < arr[uint(j)]) j--;
            if (i <= j) {
                (arr[uint(i)], arr[uint(j)]) = (arr[uint(j)], arr[uint(i)]);
                i++;
                j--;
            }
        }
        if (left < j)
            quickSort(arr, left, j);
        if (i < right)
            quickSort(arr, i, right);
    }

    function solve(uint256[] memory a) external pure returns (uint256[] memory){
       quickSort(a, int(0), int(a.length - 1));
       return a;
    }
}
