import { type NextPage } from "next";
import Card from "../components/Card";
import Navbar from "../components/Navbar";

const Home: NextPage = () => {
  return (
    <>
      <Navbar />
      <main className="flex min-h-[calc(100vh-80px)] flex-col items-center justify-center bg-neutral-dark">
        <div className="flex flex-col items-center justify-center gap-8 px-4 py-16 ">
          <div className="flex w-full items-center justify-between pb-12">
            <div>
              <h1 className="text-5xl font-extrabold italic tracking-tight text-white sm:text-[5rem]">
                <span className="text-primary">OP</span> Gotchis
              </h1>
              <p className="pt-4 text-lg text-neutral-light">
                Fund public good initiatives and receive an OP Gotchi egg.
              </p>
            </div>
            <div>
              <img src="https://placeimg.com/400/225/arch" alt="car!" />
            </div>
          </div>
          <div className="flex w-full flex-col">
            <h2 className="text-xl font-bold text-white">Trending projects</h2>
            <p className="text-neutral-light">
              Most traction in the last 24 hours
            </p>
          </div>
          <div className="grid grid-cols-3 gap-8">
            <Card />
            <Card />
            <Card />
          </div>
        </div>
      </main>
    </>
  );
};

export default Home;
