#!/bin/bash
# author:songxinfang
#读取工程配置所有的targets,然后编译打包

xcodebuild -list > file1

i=0
while read line
do
  if [[ $line = "Targets:" ]];
  then
    tag=1

  elif [[ $tag == 1 && ${#line} == 0 ]];
  then
    break

  elif [[ $tag == 1 ]];
   then
     scheme_array[$i]=$line
     let i=i+1
  fi
done<file1


for scheme_name in ${scheme_array[*]}
do
#echo ${scheme_name}

#clean 工程
/usr/bin/xcodebuild -target ${scheme_name} clean
#生产xcarchive
xcodebuild archive -workspace DoctorBuestionBank.xcworkspace -scheme ${scheme_name} -archivePath ${project_path}/${scheme_name}.xcarchive
#生产ipa
/usr/bin/xcrun -sdk iphoneos PackageApplication -v  ${project_path}/${scheme_name}.xcarchive/Products/Applications/${scheme_name}.app -o ${project_path}/${scheme_name}.ipa

done
