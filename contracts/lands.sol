pragma solidity 0.5.4;
pragma experimental ABIEncoderV2;

contract Lands {
    
    struct Title {
        bytes32 landNumber;
        bytes32 location;
        bytes32 size;
    }

    struct Specs {
        address owner;
        Coordinates[] map;
        string ipfsTitleDeed;
        string issueDate;
        bool alloted;
        bool registered;
    }

    struct Coordinates {
        int long;
        int lat;
    } 
   
    struct SaleCondition {
        uint256 amount;
        string conditions;
        bool accepted;
    
    }

    struct History {
        string date;
        uint256 sellamount;
        address currentowner;
    } 

    enum State {onsell, oncaveat }

    State public state;

    Title[] public titleDetails;
    History[] public landHistory;

    mapping(bytes32=>Specs)public landDetails;
    mapping (bytes32=>History[])public landHistories;
    mapping (bytes32=>State)public landState;
    mapping (address=>mapping (bytes32=>SaleCondition)) public landSales;


    address private government;

    constructor ()public {
        government = msg.sender;
    }
   
    // modifier name() {
    //     _
    // }

    function registerLand
    (bytes32 _landnumber, bytes32 _location, bytes32 _size, int _long, int _lat,
    string memory _issueDate, string memory _ipfsTitleDeed) public  
    {
        require(msg.sender == government);
        require(!landDetails[_landnumber].registered);
        Title[] storage titl = titleDetails;
        Specs storage spec = landDetails[_landnumber];
        Coordinates[] storage cord = landDetails[_landnumber].map;
        titl.push(Title({
            landNumber : _landnumber,
            location : _location,
            size : _size
        }));
        spec.issueDate = _issueDate;
        spec.registered = true;
        spec.ipfsTitleDeed = _ipfsTitleDeed;
        cord.push(Coordinates({
            long : _long,
            lat : _lat
        }));
    }

    function allotLand(address _to, bytes32 _landnumber)public returns(bool success) {
        Specs storage spec = landDetails[_landnumber];
        require(!spec.alloted);
        spec.owner = _to;
        return true;
    }

    function initiateSell
    (bytes32 _landnumber, address _to, uint256 _amount, string memory _condition )public 
    {
        require(landDetails[_landnumber].registered);
        require(landDetails[_landnumber].owner == msg.sender); 
        SaleCondition storage scon = landSales[_to][_landnumber];
        scon.amount = _amount;
        scon.conditions = _condition;
    }

    function acceptSell
    (bytes32 _landnumber, string memory _date )public returns(address _from) 
    {
        require(!landSales[msg.sender][_landnumber].accepted);
        _from = landDetails[_landnumber].owner;
        transferland(_from, msg.sender, _landnumber, _date);
        SaleCondition storage scon = landSales[msg.sender][_landnumber];
        scon.accepted = true;
    }

    function transferland
    (address _from, address _to, bytes32 _landnumber, string memory _date ) public returns(uint256 _amount)
    {   
        require(_from == landDetails[_landnumber].owner);
        Specs storage spec = landDetails[_landnumber];
        History[] storage hist = landHistory;
        spec.owner = _to;
        _amount = landSales[_to][_landnumber].amount;
        hist.push(History({
            currentowner:_to,
            sellamount:_amount,
            date:_date
        }));

    } 

    function registeredLands()public view returns(Title[] memory) {
        return titleDetails;
    }
}