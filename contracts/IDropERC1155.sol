interface IDropERC1155 {
    event ApprovalForAll(
        address indexed account,
        address indexed operator,
        bool approved
    );
    event ClaimConditionsUpdated(
        uint256 indexed tokenId,
        ClaimCondition[] claimConditions,
        bool resetEligibility
    );
    event ContractURIUpdated(string prevURI, string newURI);
    event DefaultRoyalty(
        address indexed newRoyaltyRecipient,
        uint256 newRoyaltyBps
    );
    event Initialized(uint8 version);
    event MaxTotalSupplyUpdated(uint256 tokenId, uint256 maxTotalSupply);
    event OwnerUpdated(address indexed prevOwner, address indexed newOwner);
    event PlatformFeeInfoUpdated(
        address indexed platformFeeRecipient,
        uint256 platformFeeBps
    );
    event PrimarySaleRecipientUpdated(address indexed recipient);
    event RoleAdminChanged(
        bytes32 indexed role,
        bytes32 indexed previousAdminRole,
        bytes32 indexed newAdminRole
    );
    event RoleGranted(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );
    event RoleRevoked(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );
    event RoyaltyForToken(
        uint256 indexed tokenId,
        address indexed royaltyRecipient,
        uint256 royaltyBps
    );
    event SaleRecipientForTokenUpdated(
        uint256 indexed tokenId,
        address saleRecipient
    );
    event TokensClaimed(
        uint256 indexed claimConditionIndex,
        address indexed claimer,
        address indexed receiver,
        uint256 tokenId,
        uint256 quantityClaimed
    );
    event TokensLazyMinted(
        uint256 indexed startTokenId,
        uint256 endTokenId,
        string baseURI,
        bytes encryptedBaseURI
    );
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );
    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 value
    );
    event URI(string value, uint256 indexed id);

    struct ClaimCondition {
        uint256 startTimestamp;
        uint256 maxClaimableSupply;
        uint256 supplyClaimed;
        uint256 quantityLimitPerWallet;
        bytes32 merkleRoot;
        uint256 pricePerToken;
        address currency;
        string metadata;
    }

    struct AllowlistProof {
        bytes32[] proof;
        uint256 quantityLimitPerWallet;
        uint256 pricePerToken;
        address currency;
    }

    function DEFAULT_ADMIN_ROLE() external view returns (bytes32);

    function balanceOf(address account, uint256 id)
        external
        view
        returns (uint256);

    function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
        external
        view
        returns (uint256[] memory);

    function burnBatch(
        address account,
        uint256[] memory ids,
        uint256[] memory values
    ) external;

    function claim(
        address _receiver,
        uint256 _tokenId,
        uint256 _quantity,
        address _currency,
        uint256 _pricePerToken,
        AllowlistProof memory _allowlistProof,
        bytes memory _data
    ) external payable;

    function claimCondition(uint256)
        external
        view
        returns (uint256 currentStartId, uint256 count);

    function contractType() external pure returns (bytes32);

    function contractURI() external view returns (string memory);

    function contractVersion() external pure returns (uint8);

    function getActiveClaimConditionId(uint256 _tokenId)
        external
        view
        returns (uint256);

    function getBaseURICount() external view returns (uint256);

    function getBatchIdAtIndex(uint256 _index) external view returns (uint256);

    function getClaimConditionById(uint256 _tokenId, uint256 _conditionId)
        external
        view
        returns (ClaimCondition memory condition);

    function getDefaultRoyaltyInfo() external view returns (address, uint16);

    function getPlatformFeeInfo() external view returns (address, uint16);

    function getRoleAdmin(bytes32 role) external view returns (bytes32);

    function getRoleMember(bytes32 role, uint256 index)
        external
        view
        returns (address member);

    function getRoleMemberCount(bytes32 role)
        external
        view
        returns (uint256 count);

    function getRoyaltyInfoForToken(uint256 _tokenId)
        external
        view
        returns (address, uint16);

    function getSupplyClaimedByWallet(
        uint256 _tokenId,
        uint256 _conditionId,
        address _claimer
    ) external view returns (uint256 supplyClaimedByWallet);

    function grantRole(bytes32 role, address account) external;

    function hasRole(bytes32 role, address account)
        external
        view
        returns (bool);

    function hasRoleWithSwitch(bytes32 role, address account)
        external
        view
        returns (bool);

    function initialize(
        address _defaultAdmin,
        string memory _name,
        string memory _symbol,
        string memory _contractURI,
        address[] memory _trustedForwarders,
        address _saleRecipient,
        address _royaltyRecipient,
        uint128 _royaltyBps,
        uint128 _platformFeeBps,
        address _platformFeeRecipient
    ) external;

    function isApprovedForAll(address account, address operator)
        external
        view
        returns (bool);

    function isTrustedForwarder(address forwarder) external view returns (bool);

    function lazyMint(
        uint256 _amount,
        string memory _baseURIForTokens,
        bytes memory _data
    ) external returns (uint256 batchId);

    function maxTotalSupply(uint256) external view returns (uint256);

    function multicall(bytes[] memory data)
        external
        returns (bytes[] memory results);

    function name() external view returns (string memory);

    function nextTokenIdToMint() external view returns (uint256);

    function owner() external view returns (address);

    function primarySaleRecipient() external view returns (address);

    function renounceRole(bytes32 role, address account) external;

    function revokeRole(bytes32 role, address account) external;

    function royaltyInfo(uint256 tokenId, uint256 salePrice)
        external
        view
        returns (address receiver, uint256 royaltyAmount);

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) external;

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) external;

    function saleRecipient(uint256) external view returns (address);

    function setApprovalForAll(address operator, bool approved) external;

    function setClaimConditions(
        uint256 _tokenId,
        ClaimCondition[] memory _conditions,
        bool _resetClaimEligibility
    ) external;

    function setContractURI(string memory _uri) external;

    function setDefaultRoyaltyInfo(
        address _royaltyRecipient,
        uint256 _royaltyBps
    ) external;

    function setMaxTotalSupply(uint256 _tokenId, uint256 _maxTotalSupply)
        external;

    function setOwner(address _newOwner) external;

    function setPlatformFeeInfo(
        address _platformFeeRecipient,
        uint256 _platformFeeBps
    ) external;

    function setPrimarySaleRecipient(address _saleRecipient) external;

    function setRoyaltyInfoForToken(
        uint256 _tokenId,
        address _recipient,
        uint256 _bps
    ) external;

    function setSaleRecipientForToken(uint256 _tokenId, address _saleRecipient)
        external;

    function supportsInterface(bytes4 interfaceId) external view returns (bool);

    function symbol() external view returns (string memory);

    function totalSupply(uint256) external view returns (uint256);

    function uri(uint256 _tokenId) external view returns (string memory);

    function verifyClaim(
        uint256 _conditionId,
        address _claimer,
        uint256 _tokenId,
        uint256 _quantity,
        address _currency,
        uint256 _pricePerToken,
        AllowlistProof memory _allowlistProof
    ) external view returns (bool isOverride);
}
