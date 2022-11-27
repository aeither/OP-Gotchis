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
    string private _attributesTable;
    uint256 private _metadataTableId;
    uint256 private _attributesTableId;
    string private _tablePrefix;
    string private _tableAttributesPrefix;
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

        _tablePrefix = "gotchi_main";
        _tableAttributesPrefix = "gotchi_attributes";
        _externalURL = externalURL;

        _accessKeysCollection = IDropERC1155(accessKeysCollection);
    }

    // registry goerli optimism 0xC72E8a7Be04f2469f8C2dB3F1BdF69A7D516aBbA
    function createMetadataTable(address registry) external onlyOwner {
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
             *    string image,
             *    string external_link,
             *    int level,
             *    int hp,
             *    int offensive
             *  );
             */
            string.concat(
                "CREATE TABLE ",
                _tablePrefix,
                "_",
                Strings.toString(block.chainid),
                " (id int primary key, name text, description text, image text, external_link text, level int, hp int, offensive int);"
            )
        );

        _metadataTable = string.concat(
            _tablePrefix,
            "_",
            Strings.toString(block.chainid),
            "_",
            Strings.toString(_metadataTableId)
        );

        _attributesTableId = _tableland.createTable(
            address(this),
            string.concat(
                "CREATE TABLE ",
                _tableAttributesPrefix,
                "_",
                Strings.toString(block.chainid),
                " (main_id int not null, trait_type text not null, value text);"
            )
        );

        _attributesTable = string.concat(
            _tableAttributesPrefix,
            "_",
            Strings.toString(block.chainid),
            "_",
            Strings.toString(_attributesTableId)
        );
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
                " (id, name, description, image, external_link, level, hp, offensive) VALUES (",
                Strings.toString(newItemId),
                ", '",
                "Gotchi",
                "', '",
                "Your Gotchi",
                "', '",
                "https://bafkreihgwdkt5yuro2hqiuszs2v7lt7zz2hupfwitpthhn5vp6gi4e37ni.ipfs.nftstorage.link/",
                "', '",
                _externalURL,
                "', 0, 20, 5)"
            )
        );
        _tableland.runSQL(
            address(this),
            _attributesTableId,
            string.concat(
                "INSERT INTO ",
                _attributesTable,
                " (main_id, trait_type, value) VALUES (",
                Strings.toString(newItemId),
                ", '",
                "Level",
                "', 0)"
            )
        );
        _safeMint(to, newItemId, "");
        _tokenIds.increment();
        return newItemId;
    }

    /*
     * levelUp is an example of how to encode gameplay into both the
     * smart contract and the metadata. Whenever a token owner calls
     * level up, they can update their token's metadata.
     */
    function levelUp(uint256 tokenId) public {
        // check token ownership
        require(this.ownerOf(tokenId) == msg.sender, "Invalid owner");
        // simple on-chain gameplay enforcement
        // Update the row in tableland
        _tableland.runSQL(
            address(this),
            _metadataTableId,
            string.concat(
                "UPDATE ",
                _metadataTable,
                " SET image = '",
                "https://bafkreigtdvbylrd5icv545523ca5dbaksryzdymfaovj3ia3w6z7pto7su.ipfs.nftstorage.link/",
                "' ",
                " WHERE id = ",
                Strings.toString(tokenId),
                ";"
            )
        );

        _tableland.runSQL(
            address(this),
            _attributesTableId,
            string.concat(
                "UPDATE ",
                _attributesTable,
                " SET value = ",
                "1",
                " ",
                " WHERE main_id = ",
                Strings.toString(tokenId),
                ";"
            )
        );
    }

    function random5(uint256 nonce) private view returns (uint256) {
        uint256 randomHash = uint256(
            keccak256(
                abi.encodePacked(
                    block.difficulty,
                    block.timestamp,
                    msg.sender,
                    nonce
                )
            )
        );
        return randomHash % 5;
    }

    function play(uint8 number) public view returns (uint8, bool) {
        // require time limited not implemented for demo
        uint8 random1 = uint8(random5(1));
        bool winner = false;
        if (number == random1) {
            winner = true;
        }

        return (random1, winner);
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
        // return
        //     string.concat(
        //         base,
        //         "SELECT%20json_object(%27id%27%2Cid%2C%27name%27%2Cname%2C%27description%27%2Cdescription%2C%27image%27%2Cimage%2C%27external_link%27%2Cexternal_link%2C%20%27level%27%2Clevel%2C%27hp%27%2Chp%2C%27offensive%27%2Coffensive)%20as%20meta%20FROM%20",
        //         _metadataTable,
        //         "%20WHERE%20id=",
        //         Strings.toString(tokenId),
        //         "&mode=list"
        //     );
        string memory query = string.concat(
            "SELECT%20json_object%28%27id%27%2Cid%2C%27name%27%2Cname%2C%27image%27%2Cimage%2C%27description%27%2Cdescription%2C%27attributes%27%2Cjson_group_array%28json_object%28%27trait_type%27%2Ctrait_type%2C%27value%27%2Cvalue%29%29%29%20as%20meta%20FROM%20",
            _metadataTable,
            "%20JOIN%20",
            _attributesTable,
            "%20ON%20",
            _metadataTable,
            "%2Eid%20%3D%20",
            _attributesTable,
            "%2Emain_id%20WHERE%20id%3D"
        );
        return
            string.concat(
                base,
                query,
                Strings.toString(tokenId),
                "%20group%20by%20id",
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

    function getMetadataTable() public view returns (string memory) {
        return _metadataTable;
    }

    function getAttributesTable() public view returns (string memory) {
        return _attributesTable;
    }

    /**
     * @dev See {UUPSUpgradeable-_authorizeUpgrade}.
     */
    function _authorizeUpgrade(address) internal view override onlyOwner {} // solhint-disable no-empty-blocks
}
