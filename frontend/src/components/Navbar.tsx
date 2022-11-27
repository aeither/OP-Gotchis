"use client";

import { ConnectWallet } from "@thirdweb-dev/react";
import { clsx } from "clsx";
import Link from "next/link";
import { useRouter } from "next/router";
import type { FC } from "react";

const Navbar: FC = () => {
  const router = useRouter();

  return (
    <div className="navbar bg-neutral-medium">
      <div className="navbar-start">
        <div className="dropdown">
          <label tabIndex={0} className="btn-ghost btn lg:hidden">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-5 w-5"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                d="M4 6h16M4 12h8m-8 6h16"
              />
            </svg>
          </label>
          <ul
            tabIndex={0}
            className="dropdown-content menu rounded-box menu-compact mt-3 w-52 bg-base-100 p-2 shadow"
          >
            <li>
              <a>Initiatives</a>
            </li>
            <li>
              <a>Play</a>
            </li>
            <li>
              <a>My Gotchis</a>
            </li>
          </ul>
        </div>
        <a className=" ml-2 p-2 text-xl font-bold normal-case italic text-primary ">
          OP <span className="font-normal text-white">Gotchis</span>
        </a>
      </div>
      <div className="navbar-center hidden lg:flex">
        <ul className="menu menu-horizontal p-2 ">
          <li>
            <Link
              className={clsx(
                "active:bg-transparent",
                router.pathname === "/" && "text-white"
              )}
              href={"/"}
            >
              Initiatives
            </Link>
          </li>
          <li>
            <Link
              className={clsx(
                "active:bg-transparent",
                router.pathname === "/play" && "text-white"
              )}
              href={"/play"}
            >
              Play
            </Link>
          </li>
          <li>
            <Link
              className={clsx(
                "active:bg-transparent",
                router.pathname === "/gotchis" && "text-white"
              )}
              href={"/gotchis"}
            >
              My Gotchis
            </Link>
          </li>
        </ul>
      </div>
      <div className="navbar-end">
        <ConnectWallet colorMode="dark" accentColor="#F50029" />
      </div>
    </div>
  );
};

export default Navbar;
