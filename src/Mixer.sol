//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


contract Mixer {
    Iverifier public immutable i_verifier;
    mapping(bytes32 => bool) public s_commitments;


    uint256 public constant DENOMINATION = 0.001 ether;
    error Mixer__CommitmentAlreadyUsed(bytes _commitment);
    error Mixer__DepositAmountNotCorrect(uint256 amountSent, uint256 expectedAmount);


    constructor(Iverifier _verifier) {
        // initialize the contract
        i_verifier = _verifier;
    }

    /// @notice Deposit funds into the mixer
    /// @param _commitment the posedion commiment of the nullifier and secret  (generated off-chain)
    function deposit(bytes32 _commitment) external payable {

        // check whether the commitment has been used before
        if (s_commitments[_commitment]){
            revert Mixer__CommitmentAlreadyAdded(_commitment);

        }
        // allow the user to send eth and make sure it's of a current fixed amount 
        if (msg.value != DENOMINATION) {
            revert Mixer__DepositAmountNotCorrect(msg.value, DENOMINATION);
        }
        // add the commitment to the onchain..  incremenatal  merkle tree 
        s_commitments[_commitment] = true;

    }

    /// @notice Withdraw funds from the mixer in a private way.. we cant use the commitment because it will defeat the privacy purpose
    /// @param _proof the zk proof generated off-chain that proves the user has a valid commitment in the list of commitments
       function withdraw(bytes memory _proof) external {
        // check whether the proof is valid by calling  the verifier contract
        // check whether the nullifier has not yet been used...
        //send them the funds 
        
    }
}