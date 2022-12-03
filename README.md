# OP Gotchis
Fund public goods and play evolving NFT game.

![Hero](https://user-images.githubusercontent.com/36173828/205454155-dbdb50ce-d659-441d-854f-e656cfea8d7e.png)

## DEMO

VIDEO LINK

[TOKEN GATED](https://app.niftykit.com/drops/early-gothis)

[WEBSITE](https://op-gotchis.vercel.app/)

[Google Slides](https://docs.google.com/presentation/d/1Ca2fyj3LaQt47lMieRgiLIc5V6XjELvT1piQw-M2KwA/edit?usp=sharing)


## Summary  
OP Gotchis is an evolving NFT game for public goods built on optimism.

Users fund initiatives to receive an NFT of an egg. The fund will be supplied to AAVE to accrue interest while the rise is still ongoing. The players receive an egg that hatches into a starter Gochi, which they can use to play minigames. For the demo, we showcased the first game. As the player progresses, the Gotchi can evolve, changing aspects and statistics.

## Problem
The problems we identified are that the benefit of public goods to each individual is small and that benefits are realized far into the future while costs are realized today.

Funds are idle in the wallet while rising funds.

Most NFTs have immutable data and do not take advantage of their programmability.

## Solution
- Gated Early Access
- Donate to worthy causes
- Gather interest while the initiative is being funded.
- Play fun games.
- Evolve NFTs as the player progresses.

## Technical overview  

- Users acknowledge it is an alpha version, the contracts are not audited, and there are risks. They can continue by minting an Early Pass NFT to be redirected to the website.
- The user can explore on the home page all the initiatives that are raising funds for public goods. When the user donates, the USDC will be sent to the Treasury contract that transfers the deposit to Ave to mature interest.
- The user receives an ERC1155 Egg NFT. To receive a dynamic NFT from the gotchi contract, the user must hatch the NFT.
- The user can play a minigame and evolve the Gochi by upgrading its metadata.

![technical-flow](https://user-images.githubusercontent.com/36173828/204342587-1ce8e3a2-cc6e-49d3-ae58-fe836ce9cc43.png)

## Tech Stack
- FE: typescript, reactjs, nextjs, tailwindCSS, Niftykit
- BE: Solidity, Remix, Tableland, Aave

## Future plans  
- Multiplayer and new game mechanics
- Items and consumables
- Set of composable creatures
- Built-in marketplace
- Lands
- Decentralise public goods application
