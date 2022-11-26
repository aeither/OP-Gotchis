"use client";

import type { FC } from "react";
import { useState } from "react";
import Card from "../components/Card";
import * as RadioGroupPrimitive from "@radix-ui/react-radio-group";
import clsx from "clsx";

const starters = [
  { id: "bg-yellow-600", title: "Electric" },
  { id: "bg-green-600", title: "Grass" },
  { id: "bg-blue-600", title: "Water" },
  { id: "bg-red-600", title: "Fire" },
  { id: "bg-violet-600", title: "Poison" },
];

const BattlefieldBody: FC = () => {
  const [selected, setSelected] = useState(false);
  const [value, setValue] = useState(starters[0]!.title);

  if (selected)
    return (
      <div className="flex flex-col items-center gap-4">
        <div className="flex flex-row gap-2">
          <RadioGroupPrimitive.Root
            defaultValue={"Bulbasaur"}
            onValueChange={setValue}
          >
            <div className="flex">
              {starters.map((item) => (
                <div key={item.id} className="flex items-center">
                  <RadioGroupPrimitive.Item
                    id={item.id}
                    value={item.title}
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
          <button className="btn-primary btn">Attack with {value}!</button>
        </div>
      </div>
    );

  return (
    <div className="grid grid-cols-5 gap-8">
      <div className="flex flex-col gap-12">
        <h2 className="text-xl">Your gotchis</h2>
        <button onClick={() => setSelected(true)}>select</button>
        <Card />
      </div>
    </div>
  );
};

export default BattlefieldBody;
