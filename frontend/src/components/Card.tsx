import type { FC } from "react";

const Card: FC = () => {
  return (
    <div className="card w-auto border border-neutral-medium bg-neutral-dark transition duration-300 hover:border-white">
      <figure>
        <img src="https://placeimg.com/400/225/arch" alt="car!" />
      </figure>
      <div className="card-body">
        <h2 className="card-title text-white">title</h2>
        <p className="text-neutral-light">description</p>
        <div className="card-actions justify-end">
          <button className="btn w-full bg-neutral-dark text-primary hover:border-neutral-light">
            Fund 1$ USDC
          </button>
        </div>
      </div>
    </div>
  );
};

export default Card;
