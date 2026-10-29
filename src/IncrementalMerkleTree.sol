//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract IncrementalMerkleTree{

    error IncrementalMerkleTree__DepthShouldBeGreaterThanZero();
    error IncrementalMerkleTree__DepthShouldBeLessThanTo32();

     uint32 public immutable i_depth;

     constructor (uint32 _depth) {
        if (_depth == 0) {
            revert IncrementalMerkleTree__DepthShouldBeGreaterThanZero();
        }

        if(_depth >= 32) {
            revert IncrementalMerkleTree__DepthShouldBeLessThanTo32();
        }
        i_depth = _depth;

        // initlaie the treess with zsro 
     }

    function _insert(bytes32 _leaf) internal {
        
        // insert the commitment into the merkle tree
   
    }
}