//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;


contract SimpleTerms {
    event NewTerms(string url, string value);
    event NewParticipant(address indexed participant);

    //The issuer must create the agreement on ricardian fabric
    address public issuer;

    Terms private terms;

    struct Terms {
        string url;
        bytes32 value;
    }

    // The key here is the hash from the terms hashed with the agreeing address.
    mapping(bytes32 => Participant) private agreements;

    // The participant any wallet that accepts the terms.
    struct Participant {
        bool signed;
    }

    constructor() {
        issuer = msg.sender;
    }

    /* The setTerms allows an issuer to add new Term to their contract

       Error code 901: "Only the deployer can call this." 
    */
    function setTerms(string calldata url, string calldata value)
        external
        returns (bool)
    {
        require(msg.sender == issuer, "901");
        // If the issuer signature is detected, the terms can be updated
        terms = Terms({url: url, value: keccak256(abi.encodePacked(value))});
        emit NewTerms(url, value);
        return true;
    }

    /* The accept function is called when a user accepts an agreement represented by the hash
    
       Error code 902: "Invalid terms."
    */
    function accept(string calldata value) external {
        require(
            keccak256(abi.encodePacked(value)) == terms.value,
            "902"
        );
        bytes32 access = keccak256(abi.encodePacked(msg.sender, terms.value));
        agreements[access] = Participant({signed: true});
        emit NewParticipant(msg.sender);
    }

    // We can check if an address accepted the current terms or not
    function acceptedTerms(address _address) external view returns (bool) {
        bytes32 access = keccak256(abi.encodePacked(_address, terms.value));
        return agreements[access].signed;
    }

    // Get the terms url to display it so people can visit it and accept it
    function getTerms() external view returns (string memory) {
        return (terms.url);
    }

    /* The modifier allows a contract inheriting from this, to controll access easily based on agreement signing.
      
       Error code 903: "You must accept the terms first."
    */
    modifier checkAcceptance() {
        bytes32 access = keccak256(abi.encodePacked(msg.sender, terms.value));
        require(agreements[access].signed, "903");
        _;
    }
}
