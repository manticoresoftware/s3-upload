#!/bin/bash

# Colors and formatting
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Clear screen and show welcome message
clear
echo -e "${BLUE}🚀 Welcome to Manticore Search Upload Tool! 🚀${NC}\n"

# Check if directory is empty
if [ -z "$(ls -A . 2>/dev/null)" ]; then
    echo -e "${RED}❌ Error: Current directory is empty. Please make sure you have files to upload.${NC}"
    exit 1
fi

# Show directory contents
echo -e "${YELLOW}📂 Files to be uploaded:${NC}"
ls -lh | grep -v "^total" | awk '{print "  " $9 " (" $5 ")"}'
echo

# Use provided argument if available
if [ -n "$1" ]; then
    upload_path="$1"
else
    # Ask for issue/PR number
    echo -e "${BLUE}🔗 Please enter the related issue URL/number${NC}"
    echo -e "${GRAY}(e.g., https://github.com/manticoresoftware/manticoresearch/issues/123 or just 123):${NC}"
    read issue_input

    # Extract number from input
    if [[ $issue_input =~ [0-9]+$ ]]; then
        issue_number=${BASH_REMATCH[0]}
    else
        echo -e "${RED}❌ Error: Could not extract issue number from input${NC}"
        exit 1
    fi

    # Generate timestamp
    timestamp=$(date +%Y%m%d)

    # Create upload path
    upload_path="issue-${timestamp}-${issue_number}"
fi

# Show progress message
echo -e "\n${YELLOW}📤 Starting upload process...${NC}"

# Upload files with progress and capture the exit code
s3cmd put -r . "s3://write-only/${upload_path}/" --progress -v
upload_status=$?

if [ $upload_status -eq 0 ]; then
    # Show completion message
    echo -e "\n${GREEN}✅ Upload complete!${NC}"
    echo -e "${YELLOW}📋 Please share this path with the developers:${NC}"
    echo -e "${BOLD}${upload_path}${NC}\n"
    
    # Show helpful tip
    echo -e "${BLUE}💡 Tip: Make sure to include this path when communicating with the Manticore team${NC}\n"
else
    echo -e "\n${RED}❌ Upload failed!${NC}"
    echo -e "${YELLOW}🔍 Common issues:${NC}"
    echo -e "  • Upload interruption"
    echo -e "  • Check your internet connection"
    echo -e "  • Ensure the S3 service is accessible"
    echo -e "  • Verify you have sufficient permissions"
    echo -e "\n${BLUE}💡 If the problem persists, please contact Manticore team for support${NC}\n"
    exit 1
fi
