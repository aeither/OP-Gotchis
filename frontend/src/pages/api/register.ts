import { ThirdwebSDK } from "@thirdweb-dev/sdk/evm";
import dotenv from "dotenv";
import type { NextApiRequest, NextApiResponse } from "next";
import { TREASURY_ABI } from "../../utils/abis";
import { TREASURY_ADDRESS } from "../../utils/constants";
dotenv.config();

if (!process.env.ADMIN_KEY) throw "ADMIN_KEY not found";
const ADMIN_KEY = process.env.ADMIN_KEY;

const getGotchis = async (req: NextApiRequest, res: NextApiResponse) => {
  const { id } = req.query;

  const sdk = ThirdwebSDK.fromPrivateKey(ADMIN_KEY, "optimism-goerli");
  const treasury = await sdk.getContractFromAbi(TREASURY_ADDRESS, TREASURY_ABI);
  const tx = await treasury.call("addFund", id, 5 * 10 ** 6);
  res.json({ data: tx });
};

export default getGotchis;
