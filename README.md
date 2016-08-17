# docker-overpass-api

OpenStreetMap Docker for [Overpass API](http://wiki.openstreetmap.org/wiki/Overpass_API).

## Building the Docker image

Download a OSM file in XML format compressed in bzip format and save as `planet.osm.bz2`. [Geofabrik](http://download.geofabrik.de/) is an excellent resource for this.

```
curl -o planet.osm.bz2 http://download.geofabrik.de/australia-oceania/new-zealand-latest.osm.bz2
docker build -t overpass-api:<TAG> .
```

## Running the Docker image

`docker run -d 80:80 overpass-api:<TAG>`

## Example

`http://localhost:80/api/interpreter?data=%5Bout:json%5D%5Btimeout:25%5D;(way(around:15,-36.91616249427225,174.831023812294)%5B%22highway%22%5D;._;%3E;);out;`