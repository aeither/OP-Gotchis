"use client";

import type { FC } from "react";
import { useState } from "react";

const BattlefieldHead: FC = () => {
  const [selected, setSelected] = useState(false);

  return (
    <div className="grid grid-cols-3">
      <div className="p-12">
        <img className="" src="/attack.png" alt="car!" />
      </div>
      <div className="self-center text-center">
        <h1 className="text-5xl font-extrabold italic tracking-tight text-white sm:text-[5rem]">
          <span className="text-primary">Battlefield</span>
        </h1>
        <div className="pt-8">
          <p className="text-neutral-light">Instructions:</p>
          <p className="text-neutral-light">1. Select your Gotchi.</p>
          <p className="text-neutral-light">
            2. Choose a type to attack the enemy.
          </p>
          <p className="text-neutral-light">
            3. A random enemy will spawn with a type weakness.
          </p>
          <p className="text-neutral-light">
            You win if you attacked the enemy&apos;s weakness.
          </p>
        </div>
      </div>
      <div className="p-12">
        <img src="/defense.png" alt="car!" />
      </div>
    </div>
  );
};

export default BattlefieldHead;
