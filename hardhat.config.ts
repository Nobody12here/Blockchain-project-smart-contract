import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import { network } from "hardhat";

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  etherscan: {
    apiKey: "1JJP4ICUSMGD9TSAPTRRM1F1ZA8PRHBG7Q",
      customChains:[{
        network:"holesky",
        chainId:17000,
        urls:{
          apiURL:"https://api-holesky.etherscan.io/api",
          browserURL:"https://api-holesky.etherscan.io/api"
        }
      }]
  },

  networks: {
    holesky: {
      url: "https://holesky.infura.io/v3/41a2cbec68d84427a8d29f87f5f56d02",
      accounts: [
        "eb24a248e3e6f93b452af40f67367dbcb5565c1df609a6f4a35f0d776b00ee01",
      ],
      chainId: 17000,
    },
  },
};

export default config;
