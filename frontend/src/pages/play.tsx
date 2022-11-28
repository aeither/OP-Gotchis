import { type NextPage } from "next";
import BattlefieldBody from "../components/BattlefieldBody";
import BattlefieldHead from "../components/BattlefieldHead";
import Navbar from "../components/Navbar";

const Play: NextPage = () => {
  return (
    <>
      <Navbar />
      <main className="flex min-h-[calc(100vh-80px)] flex-col items-center bg-neutral-dark">
        <div className="container flex flex-col items-center justify-start gap-12 px-4 py-16 ">
          <BattlefieldHead />
          <BattlefieldBody />
        </div>
      </main>
    </>
  );
};

export default Play;
