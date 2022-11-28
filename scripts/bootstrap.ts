import { ThirdwebSDK } from "@thirdweb-dev/sdk";
import { ThirdwebStorage } from "@thirdweb-dev/storage";
import fs from "fs";
import path from "path";
import dotenv from "dotenv";
dotenv.config();

if (!process.env.PRIVATE_KEY) throw "PRIVATE_KEY not found";
const PRIVATE_KEY = process.env.PRIVATE_KEY;

const main = async () => {
  // Constants
  // const initiativeAddress = "0x8F0f425515fA0Ff0702dc890f3f062cba348d624";

  // get contract
  const sdk = ThirdwebSDK.fromPrivateKey(PRIVATE_KEY, "optimism-goerli");
  // const contract = await sdk.getContract(initiativeAddress, "edition-drop");
  //   const address = contract.getAddress();
  //   console.log(address);

  // create contract
  const contractAddress = await sdk.deployer.deployEditionDrop({
    name: "OP Gotchis",
    primary_sale_recipient: "0x9Ed18213603B9082d786D75d9fBDE34B15960025",
  });
  const contract = await sdk.getContract(contractAddress, "edition-drop");
  console.log(contractAddress);

  // upload images to ipfs
  const refiparty = fs.readFileSync(
    path.resolve(__dirname, "../assets/refiparty.jpg")
  );
  const wetech = fs.readFileSync(
    path.resolve(__dirname, "../assets/wetech.jpg")
  );
  const terraimpact = fs.readFileSync(
    path.resolve(__dirname, "../assets/terra-impact.jpg")
  );

  // And now we can upload it to IPFS with a single line of code
  const storage = new ThirdwebStorage();
  const refipartyUri = await storage.upload(refiparty);
  const wetechUri = await storage.upload(wetech);
  const terraimpactUri = await storage.upload(terraimpact);

  // Create new initiative
  const metadatas = [
    {
      name: "Refi Party",
      description: "Refi party supports events for marginalized communities.",
      image: fs.readFileSync(path.resolve(__dirname, "../assets/egg.jpg")),
      animation_url: refipartyUri,
      attributes: [{ trait_type: "Initiative", value: "Refi Party" }],
    },
    {
      name: "WeTech",
      description: "Our mission to help women of color break into technology.",
      image: fs.readFileSync(path.resolve(__dirname, "../assets/egg.jpg")),
      animation_url: wetechUri,
      attributes: [{ trait_type: "Initiative", value: "WeTech" }],
    },
    {
      name: "Terra Impact",
      description:
        "Bringing integrity to Carbon and ESG markets and ending greenwashing.",
      image: fs.readFileSync(path.resolve(__dirname, "../assets/egg.jpg")),
      animation_url: terraimpactUri,
      attributes: [{ trait_type: "Initiative", value: "Terra Impact" }],
      //   external_url: "https://google.com",
      //   background_color: "FFD700",
    },
  ];

  const results = await contract.erc1155.lazyMint(metadatas); // uploads and creates the NFTs on chain
  const firstTokenId = results[0].id; // token id of the first created NFT
  //   const firstNFT = await results[0].data();

  // init claim conditions - make claimable
  const claimConditions = [
    {
      startTime: new Date(),
      price: 0.01,
    },
  ];

  await contract.claimConditions.set(firstTokenId, claimConditions);

  // Fund and Mint
  //   const tx = await contract.claim(firstTokenId, 1);
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
