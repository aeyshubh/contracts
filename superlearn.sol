pragma solidity ^0.8.7;
Contract Addr : 0x5D21BC215f873a97e8923eD74d38c78D8a2ad69f
contract superlearn{

    struct courseCreator{
        string[] _vids;
        uint256[] timestamps;
        string[] _titles;
        address _creator;
    }
    mapping(uint256=>courseCreator)public courseInfo;
    mapping(address => uint256[]) public CourseTakenByStudent;
    //mapping(uint256=>string[])
            function setCourseCreator(uint256 _courseId,string memory _vid,string memory _title,uint256 _date ) public{
        courseInfo[_courseId]._vids.push(_vid);
        courseInfo[_courseId].timestamps.push(_date);
        courseInfo[_courseId]._creator = msg.sender;
        courseInfo[_courseId]._titles.push(_title);


            }

        function getCourseDetails(uint256 _courseId) public view returns(courseCreator memory){
            return(courseInfo[_courseId]);
        }

        function setCourseTakenByStudent(uint256 _courseId) public{
            CourseTakenByStudent[msg.sender].push(_courseId);
            }

        function getCourseTakenByStudent() public view returns(uint256[] memory){
            return(CourseTakenByStudent[msg.sender]);
        }
}
