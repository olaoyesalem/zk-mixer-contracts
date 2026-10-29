# ZK Mixer Project

- Deposit : Users can deposit ETH into the mixer to break the connection between the depositor and the withdrawer

- Withdraw: Users will withdraw using a zk proof (Noir- generated off chain..) of knowledge of their deposit


## Proof

- We need to check that the commitment is present in the merkle tree
    - proposed root
    - merkle proof
    