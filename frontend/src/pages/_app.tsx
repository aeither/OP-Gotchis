import { type AppType } from "next/dist/shared/lib/utils";
import NextHead from "../components/NextHead";
import { ChainId, ThirdwebProvider } from "@thirdweb-dev/react";

import "../styles/globals.css";

const MyApp: AppType = ({ Component, pageProps }) => {
  return (
    <>
      <ThirdwebProvider desiredChainId={ChainId.OptimismGoerli}>
        <NextHead />
        <Component {...pageProps} />
      </ThirdwebProvider>
    </>
  );
};

export default MyApp;
