import { type NextPage } from "next";
import { HomeImage } from "../components/HomeImage";
import InitiativeList from "../components/InitiativeList";
import Navbar from "../components/Navbar";

const Home: NextPage = () => {
  return (
    <>
      <Navbar />
      <main className="flex min-h-[calc(100vh-80px)] flex-col items-center justify-center bg-neutral-dark">
        <div className="container flex flex-col items-center justify-center gap-8 px-4 py-16 ">
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
              <HomeImage />
            </div>
          </div>
          <InitiativeList />
        </div>
      </main>
    </>
  );
};

export default Home;
