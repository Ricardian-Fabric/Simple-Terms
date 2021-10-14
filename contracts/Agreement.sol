//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Agreement {
 
 //The issuer must create the agreement on ricardian fabric 
 address private issuer;

 event NewTerms(string url, bytes32 termHash);
 event NewParticipant(address indexed participantAddress, bytes32 termHash,string proof);

 // A string to store the url and the hash of the terms
 Terms public terms;
 
 struct Terms{
     string url;
     bytes32 hash;
 }
 
  // key is the hash from the terms hashed with the agreeing address.
 mapping(bytes32 => Participant) agreements;
 
 // The participant any wallet that accepts the terms.
 struct Participant {
     bool signed;
     string proof;
 }
 
 
constructor(){
    issuer = msg.sender;
} 
 
 // The setTerms allows an issuer to add new Term to their contract 
 function setTerms(string calldata _url,bytes32  _hash,uint8 _v, bytes32 _r, bytes32 _s) external {
    // The signature is verified first
    address signer = ecrecover(_hash,_v,_r,_s);
    require(signer == issuer,"Invalid signature");
    // If the issuer signature is detected, the terms can be updated
    terms = Terms({
        url: _url,
        hash: _hash
        
    });
    emit NewTerms(_url, _hash);
 }
 
 // The accept function is called when a user accepts an agreement represented by the hash
 function accept(string calldata _url,bytes32 _hash,uint8 _v, bytes32 _r, bytes32 _s ) external {
    require(terms.hash == _hash,"Invalid agreement");
    address signer = ecrecover(_hash,_v,_r,_s);
    require(signer == msg.sender,"Signer must be the sender");
    bytes32 access = keccak256(abi.encodePacked(msg.sender,terms.hash));
    agreements[access] = Participant({signed: true,proof: _url});
    emit NewParticipant(msg.sender, _hash, _url);
 }
// We can check if an address accepted the current terms or not
function acceptedTerms(address _address) external view returns (bool){
     bytes32 access = keccak256(abi.encodePacked(_address,terms.hash));
     return agreements[access].signed;
 }
 
 // The modifier allows a contract inheriting from this, to controll access easily based on agreement signing.
 modifier checkAcceptance{
     bytes32 access = keccak256(abi.encodePacked(msg.sender,terms.hash));
     require(agreements[access].signed,"You must accept the terms first..");
     _;
 }
}
