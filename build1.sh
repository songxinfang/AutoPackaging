#!/bin/bash
project_path=$(pwd)

target_array[0]=DoctorBuestionBank
target_array[1]=NewDoctorBuestionBank

for scheme_name in ${target_array[*]}
do
echo ${scheme_name}

#clean 工程
/usr/bin/xcodebuild -target ${scheme_name} clean
#生产xcarchive
xcodebuild archive -workspace DoctorBuestionBank.xcworkspace -scheme ${scheme_name} -archivePath ${project_path}/${scheme_name}.xcarchive
#生产ipa
/usr/bin/xcrun -sdk iphoneos PackageApplication -v  ${project_path}/${scheme_name}.xcarchive/Products/Applications/${scheme_name}.app -o ${project_path}/${scheme_name}.ipa

done