const MintableERC721 = artifacts.require("MintableERC721");

contract("MintableERC721", (accounts) => {
  let instance;
  beforeEach(async () => {
    // Deploy contract
    instance = await MintableERC721.new("Mintable NFT", "mNFT", { from: accounts[0] });
  });

  it("MintNFT", async() => {
    const name = await instance.name.call();

    assert.equal(name, "Mintable NFT");

    let receivers = [
      accounts[1],
      accounts[1],
      accounts[2],
      accounts[3],
    ];

    let uris = [
      "ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi",
      "ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi",
      "ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi",
      "ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi",
    ];

    await instance.mint(receivers, uris);

    const account1Balance = await instance.balanceOf.call(accounts[1]);
    assert.equal(account1Balance.toNumber(), 2);

    const ownerOfToken2 = await instance.ownerOf.call(2);
    assert.equal(ownerOfToken2, accounts[2]);

    const nexTokenId = await instance._CUR_TOKENID_.call();
    assert.equal(nexTokenId.toNumber(), 4);
  });

})
