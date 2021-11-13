//SPDX-License-Identifier: Unlicense
pragma solidity >= 0.4.22 <0.9.0;

// The agreement contract as called by Ricardian Fabric

interface ISimpleTerms {
    event NewTerms(string url, bytes32 value);
    event NewParticipant(address indexed participantAddress);

    /**
     * setTerms
     *
     * Adds new terms to the smart contract.
     * This is called by Ricardian Fabric when a new agreement is deployed.
     * Can be only called by the issuer.
     * The url is the acceptable contracts page and value is the hash of the agreement passed in from Ricardian Fabric
     */
    function setTerms(string calldata url, string calldata value)
        external
        returns (bool);

    /**
     * getTerms
     *
     *  You can get the terms for the contract by calling this function.
     *
     */
    function getTerms() external view returns (string memory);

    /**
     * Accept
     *
     * When a contract is accepted in Ricardian Fabric, it calls this function.
     */
    function accept(string calldata value) external;

    /**
     * acceptedTerms
     *
     * This external view function is used to verify if an address has accepted the agreement already.
     *
     */
    function acceptedTerms(address _address) external view returns (bool);
}
