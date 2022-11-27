"use client";

import { useAddress, useContract, useContractWrite } from "@thirdweb-dev/react";
import type { FC } from "react";
import { useEffect, useState } from "react";
import { GOTCHI_ABI } from "../utils/abis";
import { GOTCHI_ADDRESS } from "../utils/constants";
import type { CardProps } from "./GotchiCard";
import GotchiCard from "./GotchiCard";
import SkeletonCards from "./SkeletonCards";

interface Attribute {
  value: string;
  trait_type: string;
}
interface NFTData {
  balance: string;
  title: string;
  description: string;
  metadata: {
    name: string;
    image: string;
    description: string;
    attributes: Attribute[];
    id: number;
  };
  timeLastUpdated: string;
}

const GotchiList: FC = () => {
  const address = useAddress();
  const { contract: gotchiContract } = useContract(GOTCHI_ADDRESS, GOTCHI_ABI);
  const { mutateAsync: evolveGotchi } = useContractWrite(
    gotchiContract,
    "levelUp"
  );
  const [gotchisData, setGotchisData] = useState<NFTData[]>();

  const getGotchis = async () => {
    if (!address) return;

    const response = await fetch(`/api/server?address=${address}`)
      .then((response) => response.json())
      .catch((err) => console.error(err));

    setGotchisData(response.data.ownedNfts);
  };
  useEffect(() => {
    getGotchis();
  }, [address]);

  return (
    <div>
      <div className="flex w-full flex-col pb-8">
        <h2 className="text-xl font-bold text-white">Gotchis</h2>
        <p className="text-neutral-light">Play with them and evolve!</p>
      </div>
      <div className="grid grid-cols-3 gap-8">
        {gotchisData ? (
          gotchisData.map((nft) => {
            const level = nft.metadata.attributes[0]?.value;
            const canEvolve = Number(level) === 0;

            const data: CardProps = {
              title: String(nft.metadata.name) || "",
              description: nft.metadata.description || "",
              image: nft.metadata.image || "",
              btnText: canEvolve ? "Evolve" : "Max",
              disabled: !canEvolve,
              btnAction: async () => {
                await evolveGotchi([nft.metadata.id]);
              },
            };

            return (
              <>
                <GotchiCard {...data} />
              </>
            );
          })
        ) : (
          <SkeletonCards />
        )}
      </div>
    </div>
  );
};

export default GotchiList;
