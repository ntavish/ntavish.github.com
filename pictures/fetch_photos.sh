#!/bin/sh
# Downloads the gallery photos into img/. Safe to re-run: existing files are skipped.
# Flickr links are permanent; the Instagram links are signed and stop working
# around 2026-11-05, so run this before then.
cd "$(dirname "$0")" || exit 1
mkdir -p img
UA="Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0"
failed=0
get() {
  [ -s "img/$1" ] && { echo "skip  img/$1"; return; }
  case "$2" in *cdninstagram*) ref="https://www.instagram.com/" ;; *) ref="https://www.flickr.com/" ;; esac
  code=$(curl -sSL -A "$UA" -e "$ref" -H "Accept: image/avif,image/webp,image/*,*/*;q=0.8" -o "img/$1.part" -w "%{http_code}" "$2")
  if [ "$code" = "200" ] && [ -s "img/$1.part" ]; then mv "img/$1.part" "img/$1"; echo "ok    img/$1";
  else rm -f "img/$1.part"; echo "FAIL  img/$1 (HTTP $code)"; failed=$((failed+1)); fi
}
get light-trails.jpg 'https://live.staticflickr.com/65535/52593094669_4b8a92fc98_b.jpg'
get tokyo-clouds.jpg 'https://scontent-nrt1-2.cdninstagram.com/v/t51.82787-15/619219297_18069051161439024_6460764304868936224_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=107&ig_cache_key=MjU3OTg2NjU3MTA1NTg4NjAyMg%3D%3D.3-ccb7-5&ccb=7-5&_nc_sid=58cdad&efg=eyJ2ZW5jb2RlX3RhZyI6IkZFRUQueHBpZHMuMTA4MC5zZHIucmVndWxhcl9waG90by5DMyJ9&_nc_ohc=iOEgPx_P7L4Q7kNvwFRofbo&_nc_oc=Adqlug_iPskyX4HBs7XslvR6HdGJNXu3U22rMO0OAl9uEBOp_wYWKfmtu-Hb-b--760ar618d1MbBgEDw7CiiDpL&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent-nrt1-2.cdninstagram.com&_nc_gid=3hZEISVTebxi-vo5Edb-3w&_nc_ss=7322e&oh=00_AQRpkjTcwyGu3zKbtRidsNDa6aikKnw6N4ycTT2RdQObsw&oe=6AEBEE2F'
get night-stairs.jpg 'https://live.staticflickr.com/65535/52578040190_1aa97d8d15_b.jpg'
get garden-pavilion.jpg 'https://scontent-nrt1-1.cdninstagram.com/v/t51.82787-15/649205822_18081479732040994_1284407411192665328_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=109&ig_cache_key=MjUxOTE0NjQ5MjkxMjAyNzgzMA%3D%3D.3-ccb7-5&ccb=7-5&_nc_sid=58cdad&efg=eyJ2ZW5jb2RlX3RhZyI6IkNBUk9VU0VMX0lURU0ueHBpZHMuMTA4MC5zZHIucmVndWxhcl9waG90by5DMyJ9&_nc_ohc=PuLa3NrGGy4Q7kNvwGFp3tV&_nc_oc=AdpZwFYPRzC19w5RAz2VAhUcJSEOy-Q25-fMPw1x2NV0rXhnmyYdgA79UPoM9c9ZK-s5zx6miHUNimzj2yPSrqif&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent-nrt1-1.cdninstagram.com&_nc_gid=gW9xgF_GWJ4sU-DCKCWAvA&_nc_ss=7322e&oh=00_AQTwWcu53nd0eNYwWYjCOVA_i7zSc__63edKKVMQ8ZS8bg&oe=6AEBC9BE'
get skytree-clouds.jpg 'https://live.staticflickr.com/65535/51673813153_755f00751d_b.jpg'
get fuji-dusk.jpg 'https://live.staticflickr.com/65535/53437418245_afd01c53c2_b.jpg'
get glass-tower.jpg 'https://scontent-nrt6-1.cdninstagram.com/v/t51.82787-15/623127949_18101547346667603_207075364363576330_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=106&ig_cache_key=MjM4ODcxMzAzMjM0MzY3ODQzMA%3D%3D.3-ccb7-5&ccb=7-5&_nc_sid=58cdad&efg=eyJ2ZW5jb2RlX3RhZyI6IkZFRUQueHBpZHMuODY0LnNkci5yZWd1bGFyX3Bob3RvLkMzIn0%3D&_nc_ohc=YaXRVLKq9WYQ7kNvwH6-ECG&_nc_oc=AdriZXNKR-7zg32Vs7-1RaqqiybIhiPn3EIi4kO80prQLUvJADvfSHd1A4-xcCZTCQljcbDuRHSgdRwMLMzhroxA&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent-nrt6-1.cdninstagram.com&_nc_gid=jCH7XK1t1Lsb53KSCSNY1w&_nc_ss=7322e&oh=00_AQTokXqXr4bCPus1b1DZA73jiS-KuxOzykoMcQKvmId6YA&oe=6AEBE5FF'
get old-street.jpg 'https://live.staticflickr.com/65535/52583466446_6569cb63d8_b.jpg'
get shirakawa-go.jpg 'https://scontent-nrt1-2.cdninstagram.com/v/t51.82787-15/622505475_18075681809070539_860758680472080786_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=102&ig_cache_key=MjYyODUzNTgwNzc4ODk5NjEyNg%3D%3D.3-ccb7-5&ccb=7-5&_nc_sid=58cdad&efg=eyJ2ZW5jb2RlX3RhZyI6IkZFRUQueHBpZHMuMTA4MC5zZHIucmVndWxhcl9waG90by5DMyJ9&_nc_ohc=G2cAKWqzVAUQ7kNvwGLVweC&_nc_oc=AdptAXOXGfdSZH9-SyA9moE7J2QSy1rIUt4LiU6leJbO0PEiNFmycgsF5nhyA8jAg7Bv7jwp3QL8QRmBic2wRBwa&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent-nrt1-2.cdninstagram.com&_nc_gid=N-ZHdKibonrB9eLJcjDXXg&_nc_ss=7322e&oh=00_AQTC9P0092nP4s3cwXcJOcYfiK9jOpTgG0L9npQ2dMycWA&oe=6AEBF6CF'
get autumn-garden.jpg 'https://live.staticflickr.com/65535/52583651244_395edd5ebf_b.jpg'
get lantern.jpg 'https://live.staticflickr.com/65535/52592351402_35bec204c8_b.jpg'
get evening-run.jpg 'https://scontent-nrt1-2.cdninstagram.com/v/t51.82787-15/608429064_18077867219255755_2453651793760171184_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=102&ig_cache_key=MjUyMTgyOTExODYxMzYwMjc3Mw%3D%3D.3-ccb7-5&ccb=7-5&_nc_sid=58cdad&efg=eyJ2ZW5jb2RlX3RhZyI6IkZFRUQueHBpZHMuMTA4MC5zZHIucmVndWxhcl9waG90by5DMyJ9&_nc_ohc=pJHfDM1Cx1oQ7kNvwH_e4It&_nc_oc=AdonMu1A8eV3qDppD9CsjWpZEJgtOvFfEvNthgbCdGjwlPMfVTvr1Xs5dlA1V2kueL3Hk2utuHjwWITPrbsEWT1p&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent-nrt1-2.cdninstagram.com&_nc_gid=OQJtMTj0r7_IRQue-3RpJQ&_nc_ss=7322e&oh=00_AQSa436BUYrszY5juUPslGqQyGzNvQ5btudArN9DV4jMXw&oe=6AEBF548'
get night-water.jpg 'https://live.staticflickr.com/65535/52459444997_dde46f9668_b.jpg'
get plum-blossoms.jpg 'https://scontent-nrt1-2.cdninstagram.com/v/t51.82787-15/622593393_18149527705449895_3609583040404835390_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=104&ig_cache_key=MjUyMTI1NDgwMzE1MzE3OTk4Nw%3D%3D.3-ccb7-5&ccb=7-5&_nc_sid=58cdad&efg=eyJ2ZW5jb2RlX3RhZyI6IkZFRUQueHBpZHMuMTA4MC5zZHIucmVndWxhcl9waG90by5DMyJ9&_nc_ohc=nhzwwnQsABEQ7kNvwGSmnAx&_nc_oc=AdoNo3s4GMjCimBcxPy0xLYqZ3S3WzgZSOQcPdz7N6N9YVJMC3_t5m0Q915B99AOy8HFgEZTUOQ8ohsZdU7P2k4D&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent-nrt1-2.cdninstagram.com&_nc_gid=SAKMQ0rUev2ESnX4smdv0w&_nc_ss=7322e&oh=00_AQRF5W-NlOpsCueIxT4TFmTpD74BNZOi14F7bwy7genmMw&oe=6AEBC699'
get city-dusk.jpg 'https://live.staticflickr.com/65535/51247043806_795f1d9a37_b.jpg'
get taiko.jpg 'https://live.staticflickr.com/65535/53437137783_06b776e27a_b.jpg'
get cherry-blossoms.webp 'https://scontent-nrt6-1.cdninstagram.com/v/t51.82787-15/623908291_18069438173168742_2579777340984545347_n.webp?_nc_cat=111&ig_cache_key=MjgwNTE4NTM4NjA1MDU4ODg5NQ%3D%3D.3-ccb7-5&ccb=7-5&_nc_sid=58cdad&efg=eyJ2ZW5jb2RlX3RhZyI6IkZFRUQueHBpZHMuMTA4MC5zZHIucmVndWxhcl9waG90by5DMyJ9&_nc_ohc=K0oh4N6dLIkQ7kNvwE9XrOR&_nc_oc=AdpBaxf_yOZY5BhDyFO14_58zSARQ6dEADS9budNQtRW959QuVC0urHPYWsMSSzSv31Ujm3u8mpTyazFLHkUU04W&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent-nrt6-1.cdninstagram.com&_nc_gid=0-W-MfPD_I1o1ah2J3Ze5Q&_nc_ss=7322e&oh=00_AQQn7lzk-sCqpg3ytDiTbdrCwztCtNeuBypAIx8FTW_nwQ&oe=6AEBE72F'
get kimono.jpg 'https://live.staticflickr.com/65535/53338441121_19fcd4da5b_b.jpg'
get pool-of-light.jpg 'https://live.staticflickr.com/65535/52459445532_2dc8dd60ca_b.jpg'
get spot-the-violinist.jpg 'https://scontent-nrt6-1.cdninstagram.com/v/t51.82787-15/625590801_18142224646473254_3907273918362950696_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=106&ig_cache_key=MjU5MjkwNTc5OTg1OTgwMjMzMw%3D%3D.3-ccb7-5&ccb=7-5&_nc_sid=58cdad&efg=eyJ2ZW5jb2RlX3RhZyI6IkZFRUQueHBpZHMuMTA4MC5zZHIucmVndWxhcl9waG90by5DMyJ9&_nc_ohc=vnHGu1zeNyUQ7kNvwHMbRDN&_nc_oc=AdptpFL8fgGqRnOaUFxZgO5xkmOjrBdmIdRUraYPjsb_rNMy9PV3zg0E15BVP7wOckByR5hJc1vFi1w0cIekezRV&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent-nrt6-1.cdninstagram.com&_nc_gid=SYfjbuCIV4vEZvETrB-SgA&_nc_ss=7322e&oh=00_AQTBjDXZmrVL85c2fOUWTGatF83lmAXChUmlGr7Oq9B9kw&oe=6AEBF314'
get fuji-lakeshore.jpg 'https://live.staticflickr.com/65535/53437318084_487e467b88_b.jpg'
get torii.jpg 'https://scontent-nrt6-1.cdninstagram.com/v/t51.82787-15/620721155_18091753292069231_999295449049589099_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=106&ig_cache_key=MjQ4MzQzMzcyOTI1ODc5OTQxNQ%3D%3D.3-ccb7-5&ccb=7-5&_nc_sid=58cdad&efg=eyJ2ZW5jb2RlX3RhZyI6IkZFRUQueHBpZHMuMTA4MC5zZHIucmVndWxhcl9waG90by5DMyJ9&_nc_ohc=NxDhLC5-MKUQ7kNvwHgm--8&_nc_oc=AdokU3cTRZvWoMq9TGyh377xzJuJM3GgHvUmz1EncGFyZ7QRwUGVombvxre5SVBzyvDVwAWptvKeegWf885ENWZU&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent-nrt6-1.cdninstagram.com&_nc_gid=vu78Swb1TZR0OWt3U0JHNg&_nc_ss=7322e&oh=00_AQQGKi4zloHipjGcntHV3lw1Dqn8g5rN7ClRmwnJDWiq4g&oe=6AEBDD26'
get fuji-pampas.jpg 'https://live.staticflickr.com/65535/53437418070_4178c205dd_b.jpg'
get eclipse.jpg 'https://live.staticflickr.com/65535/52490612005_abda0c60a9_b.jpg'
get lily.jpg 'https://live.staticflickr.com/65535/51889231546_ec236b576c_b.jpg'
echo; [ "$failed" -eq 0 ] && echo "All done." || { echo "$failed failed."; exit 1; }
