const GradientToken = artifacts.require("GradientToken");
const TokenAuction = artifacts.require("TokenAuction");

contract("Auction", accounts => {
  it("Should accept nft on creation", async () => {
    let nft = await GradientToken.new("a", "b");
    let auction = await TokenAuction.new(nft.address);
    const nftAddr = await auction.nonFungibleContract();
    assert.equal(nftAddr, nft.address);
  });
  describe("createAuction", () => {
  let nft, auctionContract, tokens;

  before(async () => {
    nft = await GradientToken.new("a", "b");
    auctionContract = await TokenAuction.new(nft.address);

    await nft.mint("#ff00dd", "#ddddff");
    tokens = await nft.tokensOf(accounts[0]);

    await nft.approve(auctionContract.address, tokens[0]);
    await auctionContract.createAuction(tokens[0], 100);
  });

  it("Should take ownership of a token", async () => {
    //gradients = await instance.getGradient(tokens[0]);
    //console.log(gradients);
    const tokenOwner = await nft.ownerOf(tokens[0]);
    assert.equal(tokenOwner, auctionContract.address);
  });

  it("Should create new auction", async () => {
    const auction = await auctionContract.tokenIdToAuction(tokens[0]);
    assert.equal(auction[0], accounts[0]);
    assert.equal(auction[1].toNumber(), 100);
  });
});
});
