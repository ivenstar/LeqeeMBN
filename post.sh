#!/bin/sh
curl -verbose -X POST --data-binary "@/Users/moh/Development/image-upload/small.png" \
    -H "Accept: application/json; charset=utf-8" \
    -H "Accept-Encoding: UTF-8" \
    -H "X-Unique-Device-Id: 855A4307-90E3-4A55-8723-58925FA4C0D3" \
    -H "X-Authentication-Token: be41b2349bbe452e8b33aafceeedf715" \
    -H "X-Brand: NNBN" \
    -H "X-Country: FR" \
    -H "X-Language: fr" \
    -H "Content-Type: image/png" \
    http://babynes-int-fr.dev.isc4u.de/_vti_bin/DGNG/MobileServices/BabyNesService.svc/baby/image/upload/00001b19-0001-0001-0001-020304050607
