const { keccak256 } = require("@ethersproject/keccak256");
const { expect } = require("chai");
const { ethers } = require("hardhat");
const { fromRpcSig } = require("ethereumjs-util");

const { recoverTypedSignature_v4 } = require("eth-sig-util");

//TODO: WRITE PROPER SIGNING TEST USING THE EIP712 EXAMPLE

describe("SimpleTerms", function () {
  it("should work", async function () {
    const SimpleTerms = await hre.ethers.getContractFactory("SimpleTerms");
    const simpleTerms = await SimpleTerms.deploy();

    await simpleTerms.deployed();

    const url =
      "http://localhost:8080/ipfs/QmV8xpepZgcS3PvoQUz4mkAAyBufL4Wi6keHDAvVjjCJmp";

    const hash =
      "0xe29b7c1bd8418177d93e9b6910a53120394979538aa0532f530abad5ddc5b097";

    const issuer = "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec";
    const signature =
      "0xa2ed474adc7e23228cf242bd1d3d15e7a96c883f5970dd216887f35f2484b8984bea776728ba9c767350be3a77bbbbe36bb70555c1efb10913b4383ac41128131c";

    const sigParams = getSigParams(signature);
    //TODO: GET VerifyingContract right
    const msgParams = JSON.parse(
      `{"domain":{"chainId":"31337","name":"Ricardian Fabric","verifyingContract":"0x2279B7A0a67DB372996a5FaB50D91eAA73d2eBe6","version":"1"},"types":{"EIP712Domain":[{"name":"name","type":"string"},{"name":"version","type":"string"},{"name":"chainId","type":"uint256"},{"name":"verifyingContract","type":"address"}],"doc":[{"name":"value","type":"string"},{"name":"url","type":"string"}]},"primaryType":"doc","message":{"value":"0xe29b7c1bd8418177d93e9b6910a53120394979538aa0532f530abad5ddc5b097","url":"http://localhost:8080/ipfs/QmV8xpepZgcS3PvoQUz4mkAAyBufL4Wi6keHDAvVjjCJmp"}}`
    );

    console.log("issuer: " + issuer);

    const result = await simpleTerms.verifySignature(
      sigParams.v,
      sigParams.r,
      sigParams.s,
      hash,
      url
    );
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
