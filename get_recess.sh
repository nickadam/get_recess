#!/usr/bin/env bash


function curl_mp4 {
	mp4_url=$1
	src_url=$2
	file_name=$3
	curl -L "$mp4_url" -b "/tmp/cookie" -c "/tmp/cookie" -H 'Pragma: no-cache' -H 'DNT: 1' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.89 Safari/537.36' -H 'Accept: */*' -H 'Cache-Control: no-cache' -H 'Connection: keep-alive' --compressed -o "$file_name"
}

function get_mp4_url {
	src_url=$1
	curl -s "$src_url" -b "/tmp/cookie" -c "/tmp/cookie" -H 'Pragma: no-cache' -H 'DNT: 1' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.89 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: no-cache' -H 'Connection: keep-alive' --compressed | grep url | tail -n 1 | awk '{print $2}' | tr -d \' | sed 's/,$//' | php -r '$f=fopen("php://stdin","r");echo rawurldecode(fgets($f));'
}

function get_show_urls {
	curl -s "http://www.toonova.com/recess?page=1" | grep href |grep episode | sed 's/^[^"]*"//g' | sed 's/".*//g'
	curl -s "http://www.toonova.com/recess?page=2" | grep href |grep episode | sed 's/^[^"]*"//g' | sed 's/".*//g'
	curl -s "http://www.toonova.com/recess?page=3" | grep href |grep episode | sed 's/^[^"]*"//g' | sed 's/".*//g'	
}

function get_show_url {
	url=$1
	curl -s "$url"  | grep "\."mp4 | head -n 1 | awk -F src\=\" '{print $2}' | sed 's/\".*//'
}

urls=($(get_show_urls))

for i in "${!urls[@]}"
do
 	url=${urls[$i]}
	show_url=$(get_show_url $url)
	file_name=$(echo $show_url | sed 's/^.*\///g')
	curl_mp4 "$(get_mp4_url "$show_url")" "$show_url" "$file_name"
done
