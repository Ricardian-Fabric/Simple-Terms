# Simple terms

Simple terms is a Smart contract written in Solidity and used with Ricardian Fabric.
It allows adding terms, tracking who accepted it and allows for access control by inheritance as shown in the example.

## Events

    event NewTerms(string url, string value);

NewTerms is emitted when the terms are set. They can be only set by the issuer, who deployed the contract.

    event NewParticipant(address indexed participant);

NewParticipant event is emitted every time a participant accepts the terms.

## External functions

    function setTerms(string calldata url, string calldata value) external returns (bool);

setTerms is called by the deployer of the contract (the issuer) and can be used to reset the terms attached to the smart contract.
This function is called by Ricardian Fabric automaticly when new terms are set.

     function accept(string calldata value) external;

The accept function is called when a Ricardian Fabric contract is accepted. The value is a hash computed from the Ricardian Contract.

## View functions

    function acceptedTerms(address _address) external view returns (bool);

acceptedTerms will return true if an address has already accepted the terms.
This can be called from other contracts or by a client to check if an address accepted the terms

    function getTerms() external view returns (string memory);

You can get the terms, this will return the url of the acceptable contract.

## Modifier

    modifier checkAcceptance();

The modifier is used when inheriting the simpleTesrms contract, it's used for access control on the functions that can be only called after accepting the terms.


## Tests and Compilation

This project uses hardhat via npx. 

    npx hardhat test
    npx hardhat compile


## Error codes

901 : "Only the deployer can call this." 
902 : "Invalid terms."
903 : "You must accept the terms first."