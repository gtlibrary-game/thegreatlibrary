pragma solidity ^0.8.0;

contract XSpaces {
    struct XSpace {
        address author;
        string message;
        string[] hashtags;
    }

    struct Profile {
        string name;
        string bio;
    }

    mapping(address => Profile) public profiles;
    mapping(uint => XSpace) public xspaces;
    mapping(address => uint[]) public xspacesByAuthor;
    mapping(string => uint[]) public xspacesByHashtag;

    uint public xspaceCount = 0;

    function createProfile(string memory _name, string memory _bio) public {
        profiles[msg.sender] = Profile(_name, _bio);
    }

    function createXSpace(string memory _message, string[5] memory _hashtags) public {
        require(bytes(_message).length > 0, "Message cannot be empty");

        // Convert fixed-size array to dynamic array
        string[] memory hashtags = new string[](5);
        for(uint i = 0; i < 5; i++) {
            hashtags[i] = _hashtags[i];
        }

        xspaces[xspaceCount] = XSpace(msg.sender, _message, hashtags);
        xspacesByAuthor[msg.sender].push(xspaceCount);

        for(uint i = 0; i < hashtags.length; i++) {
            if(bytes(hashtags[i]).length > 0) {
                xspacesByHashtag[hashtags[i]].push(xspaceCount);
            }
        }

        xspaceCount++;
    }

    function getXSpace(uint _index) public view returns(address, string memory, string[5] memory) {
        XSpace memory xspace = xspaces[_index];
        string[5] memory hashtags;

        for(uint i = 0; i < 5; i++) {
            if(i < xspace.hashtags.length) {
                hashtags[i] = xspace.hashtags[i];
            } else {
                hashtags[i] = "";
            }
        }

        return (xspace.author, xspace.message, hashtags);
    }

    function getXSpaceByAuthor(address _author, uint _index) public view returns(uint) {
        return xspacesByAuthor[_author][_index];
    }

    function getXSpaceByHashtag(string memory _hashtag, uint _index) public view returns(uint) {
        return xspacesByHashtag[_hashtag][_index];
    }

    function getLatestXSpaceIndex() public view returns(uint) {
        return xspaceCount - 1;
    }

    function getLatestXSpaceIndexByAuthor(address _author) public view returns(uint) {
        uint[] memory authorXSpaces = xspacesByAuthor[_author];
        return authorXSpaces.length - 1;
    }

    function getLatestXSpaceIndexByHashtag(string memory _hashtag) public view returns(uint) {
        uint[] memory hashtagXSpaces = xspacesByHashtag[_hashtag];
        return hashtagXSpaces.length - 1;
    }
}
