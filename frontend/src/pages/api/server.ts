import type { NextApiRequest, NextApiResponse } from "next";
import axios from "axios";
import dotenv from "dotenv";
import { GOTCHI_ADDRESS } from "../../utils/constants";
dotenv.config();

if (!process.env.API_URL) throw "API_URL not found";
const API_URL = process.env.API_URL;

const getGotchis = async (req: NextApiRequest, res: NextApiResponse) => {
  const { address } = req.query;

  const options = {
    url: `https://opt-goerli.g.alchemy.com/v2/${API_URL}/getNFTs`,
    params: {
      owner: address,
      "contractAddresses[]": GOTCHI_ADDRESS,
      withMetadata: "true",
    },
  };

  const response: any = await axios.request(options).catch(function (error) {
    console.error(error);
  });

  res.json({ data: response.data });
};

export default getGotchis;
