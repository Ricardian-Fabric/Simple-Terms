//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// The agreement contract as called by Ricardian Fabric

interface IAgreement {
      event NewTerms(string url, bytes32 termHash);
      event NewParticipant(address indexed participantAddress, string proof);

    /**
     * setTerms
     *
     * Adds new terms to the smart contract.
     * This is called by Ricardian Fabric when a new agreement is deployed.
     * Should be only called by the issuer.
     * T, the hash is the precomputed hash of the agreement and the _v,_r,_s are the signature of the issuer.
     */
    function setTerms(
        string calldata _url,
        bytes32 _hash) external returns (bool);

    /**
     * getTerms
     *
     *  You can get the terms for the contract by calling this function.
     *
     */
    function getTerms() external view returns (string memory, bytes32);



    /**
     * Accept
     *
     * When a contract is signed in ricardian fabric, it calls this function with the signature
     * The _url is the deployed website's url, the hash is the agreement's hash and the _v,_r,_s are the signature of the participant
     */
    function Accept(
        uint8 v,
        bytes32 r,
        bytes32 s,
        string calldata value,
        string calldata url
    ) external;

    /**
     * acceptedTerms
     *
     * This external view function is used to verify if an address has accepted the agreement already.
     *
     */
    function acceptedTerms(address _address) external view returns (bool);


}