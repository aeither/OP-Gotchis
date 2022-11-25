// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@tableland/evm/contracts/ITablelandTables.sol";
import "./IDropERC1155.sol";

contract Gotchi is
    ERC721URIStorageUpgradeable,
    ERC721HolderUpgradeable,
    OwnableUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable,
    UUPSUpgradeable
{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    ITablelandTables private _tableland;

    // egg collection
    IDropERC1155 public _accessKeysCollection;

    string private _baseURIString =
        "https://testnet.tableland.network/query?s=";
    string private _metadataTable;
    uint256 private _metadataTableId;
    string private _tablePrefix;
    // someday we update this with a nuxt app that diplays x,y and
    // gives you the interface to move x,y.
    string private _externalURL;

    // Our will be pulled from the network

    function initialize(string memory externalURL, address accessKeysCollection)
        public
        initializer
    {
        __ERC721URIStorage_init();
        __ERC721Holder_init();
        __Ownable_init();
        __Pausable_init();
        __ReentrancyGuard_init();

        _tablePrefix = "canvas";
        _externalURL = externalURL;

        _accessKeysCollection = IDropERC1155(accessKeysCollection);
    }

    // registry goerli optimism 0xC72E8a7Be04f2469f8C2dB3F1BdF69A7D516aBbA
    function createMetadataTable(address registry)
        external
        onlyOwner
        returns (uint256)
    {
        /*
         * registry if the address of the Tableland registry. You can always find those
         * here https://github.com/tablelandnetwork/evm-tableland#currently-supported-chains
         */
        _tableland = ITablelandTables(registry);

        _metadataTableId = _tableland.createTable(
            address(this),
            /*
             *  CREATE TABLE prefix_chainId (
             *    int id,
             *    string name,
             *    string description,
             *    string external_link,
             *    int x,
             *    int y
             *  );
             */
            string.concat(
                "CREATE TABLE ",
                _tablePrefix,
                "_",
                Strings.toString(block.chainid),
                " (id int, external_link text, x int, y int);"
            )
        );

        _metadataTable = string.concat(
            _tablePrefix,
            "_",
            Strings.toString(block.chainid),
            "_",
            Strings.toString(_metadataTableId)
        );

        return _metadataTableId;
    }

    /*
     * safeMint allows anyone to mint a token in this project.
     * Any time a token is minted, a new row of metadata will be
     * dynamically insterted into the metadata table.
     */
    function safeMint(address to, uint256[] memory tokenIds)
        public
        returns (uint256)
    {
        require(
            _accessKeysCollection.balanceOf(msg.sender, tokenIds[0]) > 0,
            "Rejected: Claimer does not have access key"
        );
        // require because the operator can not set approval status for self
        require(
            _accessKeysCollection.isApprovedForAll(msg.sender, address(this)),
            "Rejected: caller is not approved"
        );

        uint256[] memory burnAmount = new uint256[](1);
        burnAmount[0] = 1;
        _accessKeysCollection.burnBatch(
            msg.sender, // Burn from the receiver
            tokenIds, // Token ID
            burnAmount // Amount to burn is the quantity they are claiming
        );

        uint256 newItemId = _tokenIds.current();
        _tableland.runSQL(
            address(this),
            _metadataTableId,
            string.concat(
                "INSERT INTO ",
                _metadataTable,
                " (id, external_link, x, y) VALUES (",
                Strings.toString(newItemId),
                ", '",
                _externalURL,
                "', 0, 0)"
            )
        );
        _safeMint(to, newItemId, "");
        _tokenIds.increment();
        return newItemId;
    }

    /*
     * makeMove is an example of how to encode gameplay into both the
     * smart contract and the metadata. Whenever a token owner calls
     * make move, they can supply a new x,y coordinate and update
     * their token's metadata.
     */
    function makeMove(
        uint256 tokenId,
        uint256 x,
        uint256 y
    ) public {
        // check token ownership
        require(this.ownerOf(tokenId) == msg.sender, "Invalid owner");
        // simple on-chain gameplay enforcement
        require(x < 512 && 0 <= x, "Out of bounds");
        require(y < 512 && 0 <= y, "Out of bounds");
        // Update the row in tableland
        _tableland.runSQL(
            address(this),
            _metadataTableId,
            string.concat(
                "UPDATE ",
                _metadataTable,
                " SET x = ",
                Strings.toString(x),
                ", y = ",
                Strings.toString(y),
                " WHERE id = ",
                Strings.toString(tokenId),
                ";"
            )
        );
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseURIString;
    }

    /*
     * tokenURI is an example of how to turn a row in your table back into
     * erc721 compliant metadata JSON. here, we do a simple SELECT statement
     * with function that converts the result into json.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721URIStorage: URI query for nonexistent token"
        );

        string memory base = _baseURI();

        /*
         * SELECT json_object('id',id,'external_link',external_link,'x',x,'y',y)
         *  as meta FROM canvas_5_4 WHERE id=11
         */
        return
            string.concat(
                base,
                "SELECT%20json_object(%27id%27,id,%27external_link%27,external_link,%27x%27,x,%27y%27,y)%20as%20meta%20FROM%20",
                _metadataTable,
                "%20WHERE%20id=",
                Strings.toString(tokenId),
                "&mode=list"
            );
    }

    /*
     * setExternalURL provides an example of how to update a field for every
     * row in an table.
     */
    function setExternalURL(string calldata externalURL) external onlyOwner {
        _externalURL = externalURL;
        _tableland.runSQL(
            address(this),
            _metadataTableId,
            string.concat(
                "update ",
                _metadataTable,
                " set external_link = ",
                externalURL,
                "||'?tokenId='||id", // Turns every row's URL into a URL including get param for tokenId
                ";"
            )
        );
    }

    function _addressToString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint256 i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint256(uint160(x)) / (2**(8 * (19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2 * i] = char(hi);
            s[2 * i + 1] = char(lo);
        }
        return string(s);
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }

    /**
     * @dev See {UUPSUpgradeable-_authorizeUpgrade}.
     */
    function _authorizeUpgrade(address) internal view override onlyOwner {} // solhint-disable no-empty-blocks
}
