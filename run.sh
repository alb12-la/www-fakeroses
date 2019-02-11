#!/bin/bash

export PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"

[ -n "$PROJECT_DIR" ]
. "${PROJECT_DIR}/vars.sh"


printf "******************************\n"
printf "* Update images"
printf "\n******************************\n"
 rsync -rv --ignore-existing  ${LOCAL_MEDIA_DIR} ${JEKYLL_IMAGES_DIR}

function create_post {
    #---
    # layout: post
    # title: "Some title"
    # categories: misc
    # image: 07_50_01.jpg
    # ---
    NAME=`echo "${1}" | awk '{split($0,a,"."); print a[1]}'`
    FILENAME="${JEKYLL_POSTS_DIR}/${NAME}-day.md"

    if [ -f ${FILENAME} ]; then
        echo "Skipping ${NAME}"
    else    
        echo "* Creating post for ${NAME}"
        # Create post.md file  
        echo "---" >> ${FILENAME}
        echo "title: '${NAME}'" >> ${FILENAME}
        echo "layout: post" >> ${FILENAME}
        echo "image: $1" >> ${FILENAME}
        echo "categories: misc" >> ${FILENAME}
        echo "---" >> ${FILENAME}
    fi
}

printf "******************************\n"
printf "* Create post for every image"
printf "\n******************************\n"

for f in `ls ${JEKYLL_IMAGES_DIR}`
    do
        create_post $f
done

printf "******************************\n"
printf "* Build Jekyll"
printf "\n******************************\n"
bundle exec jekyll build


printf "******************************\n"
printf "* Sync contents"
printf "\n******************************\n"

# Check directory exists
if [ ! -d ${WEB_ROOT} ]; then
    echo "* Creating output dir => ${WEB_ROOT}" 
    mkdir -p ${WEB_ROOT}
fi

echo "* sync ${JEKYLL_OUTPUT_DIR} => ${WEB_ROOT}" 
rsync -rv --ignore-existing  ${JEKYLL_OUTPUT_DIR} ${WEB_ROOT}