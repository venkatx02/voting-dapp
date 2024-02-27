const hre = require("hardhat");

async function main() {
  const Create = await hre.ethers.deployContract("Create");
  const create = await Create.waitForDeployment();

  console.log(create.target);
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});