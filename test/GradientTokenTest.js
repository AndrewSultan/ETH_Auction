const GradientToken = artifacts.require("GradientToken");
const {expectRevert} = require('openzeppelin-test-helpers');
const { expect } = require('chai');
contract("Gradient token", accounts => {
  it("Should make first account an owner", async () => {
    let instance = await GradientToken.deployed();
    let owner = await instance.owner();
    assert(owner == accounts[0]);
  });
  describe("mint", () => {
    it("creates token with specified outer and inner colors", async () => {
      let instance = await GradientToken.deployed();
      let owner = await instance.owner();
 
      let token = await instance.mint("#ff00dd", "#ddddff");

      let tokens = await instance.tokensOf(owner);
      //console.log(tokens);
      let gradients = await instance.getGradient(tokens[0]);
      //console.log(gradients);
      //console.log(["#ff00dd", "#ddddff"]);
      gradients = [gradients[0], gradients[1]];
      assert.deepEqual(gradients, ["#ff00dd", "#ddddff"]);
    });
    it("allows to mint only to owner", async () => {
  let instance = await GradientToken.deployed();
  let other = accounts[1];

  await instance.transferOwnership(other);
  await expectRevert.unspecified(instance.mint("#ff00dd", "#ddddff"));
    });
  });
});
