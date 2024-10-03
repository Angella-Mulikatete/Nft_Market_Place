import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const NftMarketPlaceModule = buildModule("NftMarketPlaceModule", (m) => {

    const nftMarket = m.contract("NftMarketPlace");

    return { nftMarket };
});

export default NftMarketPlaceModule;
