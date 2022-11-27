import { type NextPage } from "next";
import Card from "../components/Card";
import EggList from "../components/EggList";
import GotchiList from "../components/GotchiList";
import Navbar from "../components/Navbar";

const Home: NextPage = () => {
  return (
    <div>
      <Navbar />
      <main className="flex min-h-[calc(100vh-80px)] flex-col items-center justify-center bg-neutral-dark">
        <div className="container flex flex-col items-center justify-center gap-12 px-4 py-16 ">
          <EggList />
          <GotchiList />
        </div>
      </main>
    </div>
  );
};

export default Home;
