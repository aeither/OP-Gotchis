# OP Gotchis
Fund public goods and play evolving NFT game.

![Hero](https://user-images.githubusercontent.com/36173828/205454155-dbdb50ce-d659-441d-854f-e656cfea8d7e.png)

## DEMO

[VIDEO DEMO](https://www.youtube.com/watch?v=bNaCIFKt0Yg)

[TOKEN GATED](https://app.niftykit.com/drops/early-gothis)

[WEBSITE](https://op-gotchis.vercel.app/)

[Google Slides](https://docs.google.com/presentation/d/1Ca2fyj3LaQt47lMieRgiLIc5V6XjELvT1piQw-M2KwA/edit?usp=sharing)

## Requirements
- Metamask with Optimism - Goerli Optimism https://chainlist.org/
- USDC from Aave. Enable Test Mode in settings. https://app.aave.com/
- Goerli Optimism test ETH https://optimismfaucet.xyz/

## Summary  
OP Gotchis is an exciting and evolving NFT game for public goods that is currently in its Alpha phase. To access the game, users will need to mint an Early Pass NFT, which will allow them to access the website and begin playing.

![TokenGated](https://user-images.githubusercontent.com/36173828/205516031-ad22dc65-23ac-4975-a515-8543c1469e72.png)


Once on the website, users can fund initiatives to receive an NFT of an egg. These funds will be supplied to AAVE, where they will accrue interest while the rise is ongoing.

![Initiatives](https://user-images.githubusercontent.com/36173828/205516046-276244e9-2c3f-4210-b241-f049f718922f.png)


Players can hatch the egg NFT to reveal a starter Gochi. With their Gochi, players can play with it.

![Eggs](https://user-images.githubusercontent.com/36173828/205516057-2fddc8a5-0fb3-4828-bfa4-289658ca023b.png)

As players progress through the game, their Gotchis can evolve, changing various aspects and statistics. This adds an exciting layer of progression to the game and encourages players to continue playing to see how their Gotchis will change over time.

![PlayGame](https://user-images.githubusercontent.com/36173828/205516080-48e81560-eaa0-4002-a687-aa9057451702.png)

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
- Frontend: typescript, reactjs, nextjs, tailwindCSS, Niftykit
- Backend: Solidity, Remix, Tableland, Aave

## Future plans  
- Multiplayer and new game mechanics
- Items and consumables
- Set of composable creatures
- Built-in marketplace
- Lands
- Decentralise public goods application
