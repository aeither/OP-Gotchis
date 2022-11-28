"use client";

import { useContract, useNFTs } from "@thirdweb-dev/react";
import type { FC } from "react";
import { INITIATIVE_ADDRESS } from "../utils/constants";
import type { CardProps } from "./GotchiCard";
import GotchiCard from "./GotchiCard";
import SkeletonCards from "./SkeletonCards";

const InitiativeList: FC = () => {
  const { contract } = useContract(INITIATIVE_ADDRESS, "edition-drop");
  const {
    data: nfts,
    isLoading,
    refetch,
  } = useNFTs(contract, { start: 0, count: 100 });

  return (
    <div>
      <div className="flex w-full flex-col">
        <h2 className="text-xl font-bold text-white">Trending projects</h2>
        <p className="text-neutral-light">Most traction in the last 24 hours</p>
      </div>

      <div className="grid grid-cols-3 gap-8">
        {!isLoading && nfts ? (
          nfts.map((nft) => {
            const data: CardProps = {
              title: String(nft.metadata.name) || "",
              description: nft.metadata.description || "",
              image: nft.metadata.animation_url || "",
              btnText: "Fund 5 USDC",
              btnAction: async () => {
                if (contract) {
                  await contract.claim(nft.metadata.id, 1);
                  await fetch(`/api/register?id=${nft.metadata.id}`)
                  refetch();
                }
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

export default InitiativeList;
