import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: {
    compilers: [ {
      version:"0.8.13",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        },
      },
    }],
  }}

export default config;
