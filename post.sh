d=`date +%Y-%m-%d`

echo "title"
read title
titlef=`echo $title|sed s/\ /-/g`

echo "extension"
read ext

echo $title

file="_posts/"$d"-"$titlef"."$ext

content="---\npublished: true\nlayout: post\ntitle: "$title"\ncategory: misc\n---\n"


if [ -e $file ]
then
	echo "file exists"
	exit
fi

echo -e $content >$file

gedit $file &
