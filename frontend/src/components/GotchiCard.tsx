import { MediaRenderer } from "@thirdweb-dev/react";
import type { FC } from "react";

export interface CardProps {
  title: string;
  description: string;
  image: string;
  btnText: string;
  btnAction: (id: number) => void;
}

const GotchiCard: FC<CardProps> = ({
  title,
  description,
  image,
  btnText,
  btnAction,
}) => {
  return (
    <div className="card w-auto border border-neutral-medium bg-neutral-dark transition duration-300 hover:border-white">
      <figure>
        <MediaRenderer src={image} alt={"nft"} />
      </figure>
      <div className="card-body">
        <h2 className="card-title text-white">{title}</h2>
        <p className="text-neutral-light">{description}</p>
        <div className="card-actions justify-end">
          <button
            onClick={() => btnAction(2)}
            className="btn w-full bg-neutral-dark text-primary hover:border-neutral-light"
          >
            {btnText}
          </button>
        </div>
      </div>
    </div>
  );
};

export default GotchiCard;