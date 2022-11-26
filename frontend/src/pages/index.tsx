import { type NextPage } from "next";
import Card from "../components/Card";
import Navbar from "../components/Navbar";

const Home: NextPage = () => {
  return (
    <>
      <Navbar />
      <main className="flex min-h-[calc(100vh-80px)] flex-col items-center justify-center bg-neutral-dark">
        <div className="container flex flex-col items-center justify-center gap-12 px-4 py-16 ">
          <h1 className="text-5xl font-extrabold italic tracking-tight text-white sm:text-[5rem]">
            <span className="text-primary">OP</span> Gotchis
          </h1>
          <p className="text-neutral-light">
            Fund public good initiatives and receive an OP Gotchi egg.
          </p>
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
