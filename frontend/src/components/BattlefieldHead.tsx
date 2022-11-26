"use client";

import type { FC } from "react";
import { useState } from "react";
import Card from "../components/Card";

const BattlefieldHead: FC = () => {
  const [selected, setSelected] = useState(false);

  return (
    <div className="grid grid-cols-3">
      <img src="https://placeimg.com/400/225/arch" alt="car!" />
      <div className="text-center">
        <h1 className="text-5xl font-extrabold italic tracking-tight text-white sm:text-[5rem]">
          <span className="text-primary">Battlefield</span>
        </h1>
        <p className="text-neutral-light">Instructions:</p>
        <p className="text-neutral-light">1. Choose a Gotchi.</p>
        <p className="text-neutral-light">
          2. Choose a type to attack the enemy.
        </p>
        <p className="text-neutral-light">
          3. The enemy will block 3 types.
        </p>
        <p className="text-neutral-light">
          You win if the chosen color is not blocked.
        </p>
      </div>
      <img src="https://placeimg.com/400/225/arch" alt="car!" />
    </div>
  );
};

export default BattlefieldHead;
