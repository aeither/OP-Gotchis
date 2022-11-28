"use client";

import * as RadioGroupPrimitive from "@radix-ui/react-radio-group";
import {
  useAddress,
  useContract,
  useContractEvents,
  useContractWrite,
} from "@thirdweb-dev/react";
import clsx from "clsx";
import type { FC } from "react";
import { useEffect, useState } from "react";
import toast, { Toaster } from "react-hot-toast";
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

const elementsType = [
  { value: "0", id: "bg-yellow-600", title: "Electric" },
  { value: "1", id: "bg-green-600", title: "Grass" },
  { value: "2", id: "bg-blue-600", title: "Water" },
  { value: "3", id: "bg-red-600", title: "Fire" },
  { value: "4", id: "bg-violet-600", title: "Poison" },
];

const BattlefieldBody: FC = () => {
  const [selected, setSelected] = useState<number>(-1);
  const [value, setValue] = useState(elementsType[0]!.value);
  const [type, setType] = useState(elementsType[0]!.title);
  const [gotchisData, setGotchisData] = useState<NFTData[]>();

  const address = useAddress();
  const { contract: gotchiContract } = useContract(GOTCHI_ADDRESS, GOTCHI_ABI);
  const { mutateAsync: battle, data } = useContractWrite(
    gotchiContract,
    "play"
  );

  const events = useContractEvents(gotchiContract, "Play", { subscribe: true });
  useEffect(() => {
    if (!events.data) {
      return;
    }

    console.log(events.data);
    if (events.data[0]?.data._result === true) {
      toast.success(`You win`);
    }
    if (events.data[0]?.data._result === false) {
      const element = elementsType.find(
        (x) => +x.value === events.data[0]?.data._type
      )?.title;
      toast.error(`You lose, enemy weakness was ${element}`);
    }
  }, [events.data]);

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

  const attack = async () => {
    await battle([selected, value]);
  };

  if (selected !== -1)
    return (
      <div className="flex flex-col items-center gap-4">
        <div className="flex flex-row gap-2">
          <RadioGroupPrimitive.Root
            onValueChange={(e) => {
              setValue(e);
              setType(elementsType[Number(e)]!.title);
            }}
          >
            <div className="flex">
              {elementsType.map((item) => (
                <div key={item.id} className="flex items-center">
                  <RadioGroupPrimitive.Item
                    id={item.id}
                    value={item.value}
                    className={clsx(
                      "peer relative h-4 w-4 rounded-full",
                      "focus:outline-none focus:ring-0 focus:ring-offset-0 focus-visible:ring focus-visible:ring-purple-500 focus-visible:ring-opacity-75 focus-visible:ring-offset-2 dark:focus-visible:ring-offset-gray-800"
                    )}
                  ></RadioGroupPrimitive.Item>
                  <label
                    htmlFor={item.id}
                    className={clsx(
                      "ml-2 block rounded text-sm font-medium text-gray-700 dark:text-gray-400",
                      "cursor-pointer rounded border border-neutral-dark px-12 py-6 transition hover:border-white",
                      item.id
                    )}
                  >
                    <p className="text-white">{item.title}</p>
                  </label>
                </div>
              ))}
            </div>
          </RadioGroupPrimitive.Root>
        </div>
        <div className="pt-16">
          <Toaster />
          <button onClick={attack} className="btn-primary btn">
            Attack with {type}!
          </button>
        </div>
      </div>
    );

  return (
    <div>
      <div className="flex w-full flex-col pb-8">
        <h2 className="text-xl font-bold text-white">Gotchis</h2>
        <p className="text-neutral-light">Play with them and evolve!</p>
      </div>
      <div className="grid grid-cols-3 gap-8">
        {gotchisData ? (
          gotchisData.map((nft) => {
            const data: CardProps = {
              title: String(nft.metadata.name) || "",
              description: nft.metadata.description || "",
              image: nft.metadata.image || "",
              btnText: "Select",
              btnAction: async () => {
                setSelected(nft.metadata.id);
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

export default BattlefieldBody;
