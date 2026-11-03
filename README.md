# ZK Mixer Project

- Deposit : Users can deposit ETH into the mixer to break the connection between the depositor and the withdrawer

- Withdraw: Users will withdraw using a zk proof (Noir- generated off chain..) of knowledge of their deposit


## Proof

- We need to check that the commitment is present in the merkle tree
    - proposed root
    - merkle proof
    - Check the nullifier matches the (public) nullifer Hash 


### Private Inputs 
- secret
- nullifier
- Merkle Proof ( intermidiate  nodes requires to construct the tree  )
- Boolean  to say whether node has even index

### Public Inputs
- proposed root..
- nullifier  hash 

    