// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SBTGradeCalculator {
    uint8 private constant A_THRESHOLD = 80;
    uint8 private constant B_THRESHOLD = 60;
    uint8 private constant C_THRESHOLD = 40;
    uint8 private constant D_THRESHOLD = 20;

    struct Score {
        uint256 renewableEnergy;
        uint256 employeeWelfare;
        uint256 communityEngagement;
        uint256 governanceScore;
    }

    struct GradeResult {
        Score scores;
        string enterpriseName;
        uint256 eGrade;
        uint256 sGrade;
        uint256 gGrade;
        uint256 timestamp;
    }

    mapping(address => GradeResult[]) private gradeHistory;

    event GradeCalculated(
        address indexed enterprise,
        string enterpriseName,
        uint256 renewableEnergy,
        uint256 employeeWelfare,
        uint256 communityEngagement,
        uint256 governanceScore,
        uint256 eGrade,
        uint256 sGrade,
        uint256 gGrade,
        uint256 timestamp
    );

    function getGrade(uint256 score) private pure returns (uint256) {
        if (score >= A_THRESHOLD) {
            return 1;
        } else if (score >= B_THRESHOLD) {
            return 2;
        } else if (score >= C_THRESHOLD) {
            return 3;
        } else if (score >= D_THRESHOLD) {
            return 4;
        } else {
            return 5;
        }
    }

    function calculateGrade(string memory enterpriseName, Score memory scores) public returns (string memory) {
        uint256 eGrade = getGrade(scores.renewableEnergy);

        uint256 sAverage = (scores.employeeWelfare + scores.communityEngagement) / 2;
        uint256 sGrade = getGrade(sAverage);

        uint256 gGrade = getGrade(scores.governanceScore);

        GradeResult memory result = GradeResult({
            scores: scores,
            enterpriseName: enterpriseName,
            eGrade: eGrade,
            sGrade: sGrade,
            gGrade: gGrade,
            timestamp: block.timestamp
        });

        gradeHistory[msg.sender].push(result);

        emit GradeCalculated(
            msg.sender,
            enterpriseName,
            scores.renewableEnergy,
            scores.employeeWelfare,
            scores.communityEngagement,
            scores.governanceScore,
            eGrade,
            sGrade,
            gGrade,
            block.timestamp
        );

        return string(abi.encodePacked("E:", eGrade, " S:", sGrade, " G:", gGrade));
    }

    function getGradeHistory(address enterprise) public view returns (GradeResult[] memory) {
        return gradeHistory[enterprise];
    }
}