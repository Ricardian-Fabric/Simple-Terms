//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "hardhat/console.sol";

contract SimpleTerms {
    //The issuer must create the agreement on ricardian fabric
    address public issuer;

    event NewTerms(string url, string value);
    event NewParticipant(address indexed participantAddress, string proof);

    Terms terms;

    struct Terms {
        string url;
        bytes32 value;
    }

    // The key here is the hash from the terms hashed with the agreeing address.
    mapping(bytes32 => Participant) agreements;

    // The participant any wallet that accepts the terms.
    struct Participant {
        bool signed;
        string proof;
    }

    constructor() {
        issuer = msg.sender;
    }

    function verifySignature(
        uint8 v,
        bytes32 r,
        bytes32 s,
        string calldata value,
        string calldata url
    ) public pure returns (address) {
        uint256 chainId = 4;

        bytes32 eip712DomainHash = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes("Ricardian Fabric")),
                keccak256(bytes("1")),
                chainId,
                address(0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC)
            )
        );

        bytes32 hashStruct = keccak256(
            abi.encode(
                keccak256(bytes("doc(string value,string url)")),
                keccak256(bytes(value)),
                keccak256(bytes(url))
            )
        );

        bytes32 hash = keccak256(
            abi.encodePacked("\x19\x01", eip712DomainHash, hashStruct)
        );
        address signer = ecrecover(hash, v, r, s);
        return signer;
    }

    // The setTerms allows an issuer to add new Term to their contract
    function setTerms(string calldata _url, string calldata value)
        external
        returns (bool)
    {
        require(msg.sender == issuer, "Only the deployer can call this.");
        // If the issuer signature is detected, the terms can be updated
        terms = Terms({url: _url, value: keccak256(abi.encodePacked(value))});
        emit NewTerms(_url, value);
        return true;
    }

    function Accept(
        uint8 v,
        bytes32 r,
        bytes32 s,
        string calldata value,
        string calldata url
    ) external {
        //The value signed must be the same as the terms value stored
        require(
            keccak256(abi.encodePacked(value)) == terms.value,
            "Invalid terms"
        );

        address signer = verifySignature(v, r, s, value, url);
        require(signer == msg.sender, "The signer must be the sender");
        _accept(url);
    }

    // The accept function is called when a user accepts an agreement represented by the hash
    function _accept(string calldata url) internal {
        bytes32 access = keccak256(abi.encodePacked(msg.sender, terms.value));
        agreements[access] = Participant({signed: true, proof: url});
        emit NewParticipant(msg.sender, url);
    }

    // We can check if an address accepted the current terms or not
    function acceptedTerms(address _address) external view returns (bool) {
        bytes32 access = keccak256(abi.encodePacked(_address, terms.value));
        return agreements[access].signed;
    }

    function getTerms() external view returns (string memory, bytes32) {
        return (terms.url, terms.value);
    }

    // The modifier allows a contract inheriting from this, to controll access easily based on agreement signing.
    modifier checkAcceptance() {
        bytes32 access = keccak256(abi.encodePacked(msg.sender, terms.value));
        require(agreements[access].signed, "You must accept the terms first..");
        _;
    }
}
