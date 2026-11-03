//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


import {IVerifier} from "./Verifier.sol";
import {IncrementalMerkleTree, Poseidon2_BN254} from "./IncrementalMerkleTree.sol";


contract Mixer is IncrementalMerkleTree {
    IVerifier public immutable i_verifier;
    mapping(bytes32 => bool) public s_commitments;
    mapping (bytes32 => bool) public s_nullifierHashes;

    uint256 public constant DENOMINATION = 0.001 ether;
    error Mixer__CommitmentAlreadyUsed(bytes _commitment);
    error Mixer__DepositAmountNotCorrect(
        uint256 amountSent,
        uint256 expectedAmount
    );
    error Mixer__UnknownRoot(bytes32 _root);
    error Mixer__CommitmentAlreadyAdded(bytes32 _commitment);
    error Mixer__NullifierAlreadyUsed(bytes32 _nullifierHash);
    error Mixer__InvalidProof();
    error Mixer__PaymentFailed(address _recipient, uint256 _amount);

    event Deposit(bytes32 indexed commitment, uint32 insertedIndex, uint256 timestamp);
    event Withdrawal(address indexed recipient, bytes32 nullifierHash);

    constructor(IVerifier _verifier, uint32 _merkleTreeDepth, Poseidon2_BN254 _hasher) IncrementalMerkleTree(_merkleTreeDepth, _hasher) {
        // initialize the contract
        i_verifier = _verifier;
    }

    /// @notice Deposit funds into the mixer
    /// @param _commitment the posedion commiment of the nullifier and secret  (generated off-chain)
    function deposit(bytes32 _commitment) external payable {
        // check whether the commitment has been used before
        if (s_commitments[_commitment]) {
            revert Mixer__CommitmentAlreadyAdded(_commitment);
        }
        // allow the user to send eth and make sure it's of a current fixed amount
        if (msg.value != DENOMINATION) {
            revert Mixer__DepositAmountNotCorrect(msg.value, DENOMINATION);
        }

        // add the commitment to the onchain..  incremenatal  merkle tree
        uint32 insertedIndex = _insert(_commitment);
        s_commitments[_commitment] = true;

        emit Deposit(_commitment, insertedIndex, block.timestamp);
    }

    /// @notice Withdraw funds from the mixer in a private way.. we cant use the commitment because it will defeat the privacy purpose
    /// @param _proof the zk proof generated off-chain that proves the user has a valid commitment in the list of commitments
    function withdraw(bytes memory _proof, bytes32 _root, bytes32 _nullifierHash, address payable _recipient) external {
        // check that  the root  that was used in the proof generation  matches the root on-chain
        if (_root != s_root) {
            revert Mixer__UnknownRoot(_root);
        }
        // check whether the nullifier has not yet been used...
        if (s_nullifierHashes[_nullifierHash]) {
            revert Mixer__NullifierAlreadyUsed(_nullifierHash);
        }

        // check whether the proof is valid by calling  the verifier contract
        bytes32[] memory publicInputs = new bytes32[](3);
        publicInputs[0] = _root;
        publicInputs[1] = _nullifierHash;
        publicInputs[2] = bytes32(uint256(uint160(address(_recipient))));
        if (!i_verifier.verify(_proof, publicInputs)) {
            revert Mixer__InvalidProof();
        }

        s_nullifierHashes[_nullifierHash] = true;

        // send them the funds
        (bool success, ) = _recipient.call{value: DENOMINATION}("");
        if (!success) {
            revert Mixer__PaymentFailed(_recipient, DENOMINATION);
        }

        emit Withdrawal(_recipient, _nullifierHash);
    }
}
