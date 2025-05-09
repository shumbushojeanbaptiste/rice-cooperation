const { ethers } = require("hardhat");

async function main() {
  try {
    // Get the deployer account
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with account:", deployer.address);

    // Get the contract factory
    const RiceCooperative = await ethers.getContractFactory("RiceCooperative");
    console.log("Deploying RiceCooperative contract...");

    // Deploy the contract
    const riceCooperative = await RiceCooperative.deploy();
    
    // Wait for deployment to complete (new method)
    console.log("Waiting for deployment confirmation...");
    const deploymentReceipt = await riceCooperative.deploymentTransaction().wait();
    
    console.log("\n✅ Deployment successful!");
    console.log("Contract address:", await riceCooperative.getAddress());
    console.log("Block number:", deploymentReceipt.blockNumber);
    
    // Verify deployment by calling a contract function
    console.log("\nTesting contract...");
    const tx = await riceCooperative.registerFarmer("Test Farmer");
    await tx.wait();
    console.log("✅ Test transaction completed");
    
  } catch (error) {
    console.error("\n❌ Deployment failed:", error.message);
    process.exit(1);
  }
}

main().then(() => process.exit(0));