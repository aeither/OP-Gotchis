import { type NextPage } from "next";
import Card from "../components/Card";
import Navbar from "../components/Navbar";

const Home: NextPage = () => {
  return (
    <>
      <Navbar />
      <main className="flex min-h-[calc(100vh-80px)] flex-col items-center justify-center bg-neutral-dark">
        <div className="flex flex-col items-center justify-center gap-12 px-4 py-16 ">
          <div className="flex w-full flex-col">
            <h2 className="text-xl font-bold text-white">Eggs</h2>
            <p className="text-neutral-light">Ready to hatch?</p>
          </div>
          <div className="grid grid-cols-3 gap-8">
            <Card />
            <Card />
            <Card />
          </div>
          <div className="flex w-full flex-col">
            <h2 className="text-xl font-bold text-white">Gotchis</h2>
            <p className="text-neutral-light">Play with them and evolve!</p>
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
