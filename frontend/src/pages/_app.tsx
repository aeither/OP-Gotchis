import { type AppType } from "next/dist/shared/lib/utils";
import NextHead from "../components/NextHead";

import "../styles/globals.css";

const MyApp: AppType = ({ Component, pageProps }) => {
  return (
    <>
      <NextHead />
      <Component {...pageProps} />
    </>
  );
};

export default MyApp;
