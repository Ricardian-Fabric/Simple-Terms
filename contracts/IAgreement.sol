//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// The agreement contract as called by Ricardian Fabric


interface IAgreement{


   /**
     * setTerms
     *
     * Adds new terms to the smart contract.
     * This is called by Ricardian Fabric when a new agreement is deployed.
     * Should be only called by the issuer. 
     * The _url is the deployed website's url, the hash is the precomputed hash of the agreement and the _v,_r,_s are the signature of the issuer.
     */
	function setTerms(string calldata _url,bytes32  _hash,uint8 _v, bytes32 _r, bytes32 _s) external;

   /**
     * accept
     *
     * When a contract is signed in ricardian fabric, it calls this function with the signature
     * 
     * Should be only called by the issuer. 
     * The _url is the deployed website's url, the hash is the agreement's hash and the _v,_r,_s are the signature of the participant
     */
	function accept(string calldata _url,bytes32 _hash,uint8 _v, bytes32 _r, bytes32 _s ) external;

    

    /**
     * acceptedTerms
     *
     * This external view function is used to verify if an address has accepted the agreement already. 
     * 
     */
    function acceptedTerms(address _address) external view returns (bool);

   
}