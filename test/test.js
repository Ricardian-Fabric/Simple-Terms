const { keccak256 } = require("@ethersproject/keccak256");
const { expect } = require("chai");
const { ethers } = require("hardhat");
const { fromRpcSig } = require("ethereumjs-util");

const { recoverTypedSignature_v4 } = require("eth-sig-util");

describe("Agreement", function () {
  it("should work", async function () {
    const Agreement = await hre.ethers.getContractFactory("Agreement");
    const agreement = await Agreement.deploy();

    await agreement.deployed();

    const url =
      "http://localhost:8080/ipfs/Qma6qaUo6p1YiBcN2a2u1jGogw457Rnhypz62Rhw4EYygp";

    const hash =
      "0xe7008dead711dffd4550d1f724b251feb1ab801855d5a48e4a0f492a5dbb37c1";

    const issuer = "0x050e8c2dc9454ca53da9efdad6a93bb00c216ca0";
    const signature =
      "0xa6b473661b364087780775adbd3c026b7f1f99a17afe137f3b7eb5d6e505d44927c40190f35a52005f420a1e9244f4a9abdf5ff76a4ff6b76ed12edcf70e946d1c";

    const sigParams = getSigParams(signature);

    const msgParams = JSON.parse(`{
  "domain": {
    "chainId": "4",
    "name": "Ricardian Fabric",
    "verifyingContract": "0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC",
    "version": "1"
  },
  "types": {
    "EIP712Domain": [
      {
        "name": "name",
        "type": "string"
      },
      {
        "name": "version",
        "type": "string"
      },
      {
        "name": "chainId",
        "type": "uint256"
      },
      {
        "name": "verifyingContract",
        "type": "address"
      }
    ],
    "doc": [
      {
        "name": "value",
        "type": "string"
      },
      {
        "name": "url",
        "type": "string"
      }
    ]
  },
  "primaryType": "doc",
  "message": {
    "value": "0xe7008dead711dffd4550d1f724b251feb1ab801855d5a48e4a0f492a5dbb37c1",
    "url": "http://localhost:8080/ipfs/Qma6qaUo6p1YiBcN2a2u1jGogw457Rnhypz62Rhw4EYygp"
  }
}`);

    console.log("issuer: " + issuer);
    const result = await agreement.verifySignature(
      sigParams.v,
      sigParams.r,
      sigParams.s,
      hash,
      url
    );
    console.table(result)
    console.log("solidity result: " + result);
    const jsres = await recoverTypedSignature(msgParams, signature);
    console.log("js result: " + jsres);
  });
});

async function recoverTypedSignature(msgParams, signature) {
  const recovered = await recoverTypedSignature_v4({
    data: msgParams,
    sig: signature,
  });
  return recovered;
}
function getSigParams(sig) {
  return fromRpcSig(sig);
}
