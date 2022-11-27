"use client";

import {
  useAddress,
  useContract,
  useContractWrite,
  useOwnedNFTs,
} from "@thirdweb-dev/react";
import type { FC } from "react";
import { GOTCHI_ABI } from "../utils/abis";
import { GOTCHI_ADDRESS, INITIATIVE_ADDRESS } from "../utils/constants";
import type { CardProps } from "./GotchiCard";
import GotchiCard from "./GotchiCard";
import SkeletonCards from "./SkeletonCards";

const EggList: FC = () => {
  const address = useAddress();
  const { contract: eggContract } = useContract(
    INITIATIVE_ADDRESS,
    "edition-drop"
  );

  const { contract: gotchiContract } = useContract(GOTCHI_ADDRESS, GOTCHI_ABI);
  const { mutateAsync: hatchEggToGotchi } = useContractWrite(
    gotchiContract,
    "safeMint"
  );

  const { data: nfts, isLoading, refetch } = useOwnedNFTs(eggContract, address);

  return (
    <div>
      <div className="flex w-full flex-col pb-8">
        <h2 className="text-xl font-bold text-white">Eggs</h2>
        <p className="text-neutral-light">Ready to hatch?</p>
      </div>
      <div className="grid grid-cols-3 gap-8">
        {!isLoading && nfts ? (
          nfts.map((nft) => {
            const data: CardProps = {
              title: String(nft.metadata.name) || "",
              description: nft.metadata.description || "",
              image: nft.metadata.image || "",
              btnText: "Hatch",
              btnAction: async () => {
                if (eggContract && address) {
                  const isApproved = await eggContract.erc1155.isApproved(
                    address,
                    GOTCHI_ADDRESS
                  );

                  if (!isApproved) {
                    await eggContract.erc1155.setApprovalForAll(
                      GOTCHI_ADDRESS,
                      true
                    );
                  }

                  await hatchEggToGotchi([address, [nft.metadata.id]]);
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

export default EggList;
