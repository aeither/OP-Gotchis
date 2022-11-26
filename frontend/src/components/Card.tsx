import type { FC } from "react";

const Card: FC = () => {
  return (
    <div className="card w-auto bg-neutral-medium border border-neutral-medium transition duration-300 hover:border-white">
      <figure>
        <img src="https://placeimg.com/400/225/arch" alt="car!" />
      </figure>
      <div className="card-body">
        <h2 className="card-title">title</h2>
        <p>description</p>
        <div className="card-actions justify-end">
          <button className="btn-primary btn w-full">Fund 1$ USDC</button>
        </div>
      </div>
    </div>
  );
};

export default Card;
