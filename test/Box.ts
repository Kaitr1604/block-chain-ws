import { expect } from 'chai';
import { ethers } from 'hardhat';
import { Contract } from 'ethers';
import { loadFixture } from '@nomicfoundation/hardhat-network-helpers';

describe('Box', function () {
  let box: Contract & any;
  let owner: string;
  let other: string;
  const value = ethers.toBigInt(42);

  // Fixture to deploy the contract
  async function deployBoxFixture() {
    const [deployer, otherAccount] = await ethers.getSigners();
    const Box = await ethers.getContractFactory('Box');
    const box = await Box.deploy();
    await box.deploymentTransaction();
    return { box, owner: deployer.address, other: otherAccount.address };
  }

  beforeEach(async function () {
    ({ box, owner, other } = await loadFixture(deployBoxFixture));
  });

  it('retrieve returns a value previously stored', async function () {
    await box.store(value);

    // Use large integer comparisons
    expect(await box.retrieve()).to.equal(value);
  });

  it('store emits an event', async function () {
    await expect(box.store(value))
      .to.emit(box, 'ValueChanged')
      .withArgs(value);
  });

  it('non-owner cannot store a value', async function () {
    const otherSigner = await ethers.getSigner(other);
    const connectedBox = await box.connect(otherSigner)
    try {
      const testValue = await connectedBox.store(value);
      throw new Error("test")
    } catch (error: any) {
      expect(error).to.not.be.null;
      expect(error.message).to.not.equal("test");
    }
  });

});