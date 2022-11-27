"use client";

import { useContract, useNFTs } from "@thirdweb-dev/react";
import type { FC } from "react";
import { useState } from "react";
import type { CardProps } from "./GotchiCard";
import GotchiCard from "./GotchiCard";

const GotchiList: FC = () => {
  const INITIATIVE_ADDRESS = "0x8F0f425515fA0Ff0702dc890f3f062cba348d624";

  const [selected, setSelected] = useState(false);
  const { contract } = useContract(INITIATIVE_ADDRESS, "edition-drop");
  const { data: nfts, isLoading } = useNFTs(contract, { start: 0, count: 100 });

  return (
    <div>
     
    </div>
  );
};

export default GotchiList;
